const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const outDir = path.resolve(__dirname, '..', 'tmp', 'screenshots');
  fs.mkdirSync(outDir, { recursive: true });

  const browser = await chromium.launch();
  const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
  const page = await context.newPage();

  const pages = [
    { url: 'http://127.0.0.1:3000/admin/homepage/sections/edit', name: 'admin_homepage_sections_edit' },
    { url: 'http://127.0.0.1:3000/admin/about/sections/why_nailab_exists/edit', name: 'admin_about_why_nailab_exists_edit' },
    { url: 'http://127.0.0.1:3000/admin/about/sections/our_impact/edit', name: 'admin_about_our_impact_edit' },
    { url: 'http://127.0.0.1:3000/admin/about/sections/vision_mission/edit', name: 'admin_about_vision_mission_edit' },
    { url: 'http://127.0.0.1:3000/admin/about/sections/what_drives_us/edit', name: 'admin_about_what_drives_us_edit' },
    { url: 'http://127.0.0.1:3000/admin/pricing/edit', name: 'admin_pricing_edit' },
    { url: 'http://127.0.0.1:3000/admin/contact_page/edit', name: 'admin_contact_page_edit' }
  ];

  for (const p of pages) {
    try {
      console.log('Capturing', p.url);
      const resp = await page.goto(p.url, { waitUntil: 'networkidle', timeout: 30000 });
      if (resp) console.log(p.url, 'status', resp.status());
      await page.waitForTimeout(800);
      const file = path.join(outDir, `${p.name}.png`);
      await page.screenshot({ path: file, fullPage: true });
      console.log('Saved', file);
    } catch (err) {
      console.error('Error capturing', p.url, err.message);
    }
  }

  await browser.close();
  console.log('Done');
})();
