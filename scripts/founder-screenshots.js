const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE_URL = process.env.BASE_URL || 'http://localhost:3000';
const SCREENSHOT_DIR = path.join(__dirname, '..', 'screenshots');

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

async function captureFounderScreenshots() {
  const founderEmail = process.env.FOUNDER_EMAIL;
  const founderPassword = process.env.FOUNDER_PASSWORD;
  
  if (!founderEmail || !founderPassword) {
    console.error('❌ Missing founder credentials');
    console.log('Set FOUNDER_EMAIL and FOUNDER_PASSWORD environment variables');
    return;
  }
  
  console.log(`🎬 Starting founder screenshots for ${BASE_URL}`);
  console.log(`🔐 Using founder account: ${founderEmail}`);
  
  ensureDir(SCREENSHOT_DIR);
  
  const browser = await chromium.launch({ headless: true });
  const authContext = await browser.newContext();
  const authPage = await authContext.newPage();
  
  try {
    // Login as founder
    console.log('🔑 Logging in as founder...');
    await authPage.goto(`${BASE_URL}/users/sign_in`);
    await authPage.fill('input[name="user[email]"]', founderEmail);
    await authPage.fill('input[name="user[password]"]', founderPassword);
    await authPage.click('input[type="submit"]');
    
    // Wait for either navigation or success indicator
    try {
      await authPage.waitForNavigation({ timeout: 10000 });
    } catch (error) {
      // If navigation timeout, check if we're still on sign_in page
      const currentUrl = authPage.url();
      if (currentUrl.includes('/sign_in')) {
        throw new Error('Login failed - still on sign in page');
      }
    }
    console.log('✅ Founder authentication successful');
    
    // Capture all founder pages
    for (const page of FOUNDER_PAGES) {
      console.log(`📸 Capturing: ${page.name} (${page.path})`);
      
      ensureDir(path.join(SCREENSHOT_DIR, page.name));
      
      const pageInstance = await authContext.newPage();
      
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
    
    console.log('\n🎉 Founder screenshots completed!');
    console.log(`📁 Screenshots saved to: ${SCREENSHOT_DIR}`);
    
  } catch (error) {
    console.error(`❌ Error during founder screenshots: ${error.message}`);
  } finally {
    await authPage.close();
    await authContext.close();
    await browser.close();
  }
}

if (require.main === module) {
  captureFounderScreenshots().catch(console.error);
}

module.exports = { captureFounderScreenshots };