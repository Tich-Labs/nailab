const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE_URL = process.env.BASE_URL || 'http://localhost:3000';
const SCREENSHOT_DIR = path.join(__dirname, '..', 'screenshots');

const PUBLIC_PAGES = [
  { path: '/', name: 'home' },
  { path: '/about', name: 'about' },
  { path: '/programs', name: 'programs' },
  { path: '/resources', name: 'resources' },
  { path: '/startups', name: 'startup-directory' },
  { path: '/mentors', name: 'mentor-directory' },
  { path: '/pricing', name: 'pricing' },
  { path: '/contact', name: 'contact' },
  { path: '/terms', name: 'terms' },
  { path: '/privacy', name: 'privacy' }
];

const FOUNDER_PAGES = [
  { path: '/founder', name: 'founder-dashboard' },
  { path: '/founder/account', name: 'founder-account' },
  { path: '/founder/startup_profile', name: 'founder-startup-profile' },
  { path: '/founder/progress', name: 'founder-progress' },
  { path: '/founder/mentorship', name: 'founder-mentorship' },
  { path: '/founder/mentors', name: 'founder-mentors' },
  { path: '/founder/sessions', name: 'founder-sessions' },
  { path: '/founder/resources', name: 'founder-resources' },
  { path: '/founder/opportunities', name: 'founder-opportunities' },
  { path: '/founder/community', name: 'founder-community' },
  { path: '/founder/account', name: 'founder-account' },
  { path: '/founder/support', name: 'founder-support' }
];

const VIEWPORTS = [
  { width: 1920, height: 1080, name: 'desktop' },
  { width: 768, height: 1024, name: 'tablet' },
  { width: 375, height: 812, name: 'mobile' }
];

function ensureDir(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

async function takeScreenshots() {
  console.log(`🎬 Starting screenshots for ${BASE_URL}`);
  
  ensureDir(SCREENSHOT_DIR);
  
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  
  try {
    // Capture public pages
    await capturePageGroup(PUBLIC_PAGES, context, 'public');
    
    // Capture founder pages (if test credentials are available)
    if (process.env.FOUNDER_EMAIL && process.env.FOUNDER_PASSWORD) {
      console.log('\n🔐 Authenticating for founder pages...');
      
      // Create a separate context for authenticated pages
      const authContext = await browser.newContext();
      const authPage = await authContext.newPage();
      
      try {
        // Login as founder
        await authPage.goto(`${BASE_URL}/users/sign_in`);
        await authPage.fill('input[name="user[email]"]', process.env.FOUNDER_EMAIL);
        await authPage.fill('input[name="user[password]"]', process.env.FOUNDER_PASSWORD);
        await authPage.click('input[type="submit"]');
        await authPage.waitForNavigation();
        
        console.log('✅ Founder authentication successful');
        
        await capturePageGroup(FOUNDER_PAGES, authContext, 'founder');
        
      } catch (error) {
        console.error(`❌ Founder authentication failed: ${error.message}`);
      } finally {
        await authPage.close();
        await authContext.close();
      }
    } else {
      console.log('\n⚠️  Founder pages skipped - set FOUNDER_EMAIL and FOUNDER_PASSWORD environment variables to capture authenticated pages');
    }
    
    console.log('\n🎉 Screenshots completed!');
    console.log(`📁 Screenshots saved to: ${SCREENSHOT_DIR}`);
    
  } finally {
    await browser.close();
  }
}

async function capturePageGroup(pages, context, groupType) {
  console.log(`\n📸 Capturing ${groupType} pages...`);
  
  for (const page of pages) {
    console.log(`📸 Capturing: ${page.name} (${page.path})`);
    
    ensureDir(path.join(SCREENSHOT_DIR, page.name));
    
    const pageInstance = await context.newPage();
    
    for (const viewport of VIEWPORTS) {
      await pageInstance.setViewportSize(viewport);
      
      console.log(`  🖥️  ${viewport.name} view (${viewport.width}x${viewport.height})`);
      
      try {
        await pageInstance.goto(`${BASE_URL}${page.path}`, { 
          waitUntil: 'networkidle',
          timeout: 30000 
        });
        
        // Wait for any dynamic content to load
        await pageInstance.waitForTimeout(2000);
        
        const screenshotPath = path.join(
          SCREENSHOT_DIR, 
          page.name, 
          `${page.name}-${viewport.name}.png`
        );
        
        await pageInstance.screenshot({ 
          path: screenshotPath,
          fullPage: true 
        });
        
        console.log(`    ✅ Saved: ${screenshotPath}`);
        
      } catch (error) {
        console.error(`    ❌ Failed to capture ${page.name} ${viewport.name}: ${error.message}`);
      }
    }
    
    await pageInstance.close();
  }
}

if (require.main === module) {
  takeScreenshots().catch(console.error);
}

module.exports = { takeScreenshots };