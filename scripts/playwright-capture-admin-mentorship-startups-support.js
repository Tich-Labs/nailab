const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const outDir = './tmp/screenshots';
  fs.mkdirSync(outDir, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1300, height: 900 } });

  const pages = [
    { path: '/admin/mentor', name: 'admin_mentor' },
    { path: '/admin/mentorship_request', name: 'admin_mentorship_request' },
    { path: '/admin/startup_profile', name: 'admin_startup_profile' },
    { path: '/admin/support_ticket', name: 'admin_support_ticket' }
  ];

  for (const p of pages) {
    try {
      const url = `http://127.0.0.1:3000${p.path}`;
      console.log('Visiting', url);
      const resp = await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
      const status = resp ? resp.status() : 'no-response';
      console.log('Status', status);
      const file = `${outDir}/${p.name}.png`;
      await page.screenshot({ path: file, fullPage: true });
      console.log('Saved', file);
      await page.waitForTimeout(300);
    } catch (err) {
      console.error('Error capturing', p.path, err && err.message);
    }
  }

  await browser.close();
})();
