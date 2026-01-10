const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const outDir = './tmp/screenshots';
  fs.mkdirSync(outDir, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1280, height: 900 } });

  const pages = [
    { path: '/admin/homepage/hero', name: 'hero' },
    { path: '/admin/homepage/who_we_are', name: 'who_we_are' },
    { path: '/admin/homepage/how_we_support', name: 'how_we_support' },
    { path: '/admin/homepage/focus_areas', name: 'focus_areas' },
    { path: '/admin/homepage/connect_grow_impact', name: 'connect_grow_impact' },
    { path: '/admin/testimonials', name: 'testimonials' },
    { path: '/admin/homepage/impact_network', name: 'impact_network' },
    { path: '/admin/homepage/cta', name: 'cta' }
  ];

  for (const p of pages) {
    try {
      const url = `http://127.0.0.1:3000${p.path}`;
      console.log('Visiting', url);
      const resp = await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
      const status = resp ? resp.status() : 'no-response';
      console.log('Status', status);
      const file = `${outDir}/admin_homepage_${p.name}.png`;
      await page.screenshot({ path: file, fullPage: true });
      console.log('Saved', file);
      // small pause
      await page.waitForTimeout(300);
    } catch (err) {
      console.error('Error capturing', p.path, err.message);
    }
  }

  await browser.close();
})();
