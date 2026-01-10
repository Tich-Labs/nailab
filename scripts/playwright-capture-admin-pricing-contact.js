const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const outDir = './tmp/screenshots';
  fs.mkdirSync(outDir, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1280, height: 900 } });

  const pages = [
    { path: '/admin/pricing/edit', name: 'pricing_edit' },
    { path: '/admin/contact_page/edit', name: 'contact_page_edit' }
  ];

  for (const p of pages) {
    try {
      const url = `http://127.0.0.1:3000${p.path}`;
      console.log('Visiting', url);
      const resp = await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
      const status = resp ? resp.status() : 'no-response';
      console.log('Status', status);
      const file = `${outDir}/admin_${p.name}.png`;
      await page.screenshot({ path: file, fullPage: true });
      console.log('Saved', file);
      await page.waitForTimeout(300);
    } catch (err) {
      console.error('Error capturing', p.path, err && err.message);
    }
  }

  await browser.close();
})();
