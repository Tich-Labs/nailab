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
    for (const page of PUBLIC_PAGES) {
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
    
    console.log('🎉 Screenshots completed!');
    console.log(`📁 Screenshots saved to: ${SCREENSHOT_DIR}`);
    
  } finally {
    await browser.close();
  }
}

if (require.main === module) {
  takeScreenshots().catch(console.error);
}

module.exports = { takeScreenshots };