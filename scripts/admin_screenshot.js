const { chromium } = require('playwright');

async function run(url, out) {
  const browser = await chromium.launch({ args: ['--no-sandbox'] });
  const page = await browser.newPage();
  await page.goto(url, { waitUntil: 'networkidle' });
  await page.screenshot({ path: out, fullPage: true });
  await browser.close();
}

(async () => {
  const pairs = [
    ['http://127.0.0.1:3000/admin/startup_profile/10/edit', 'tmp/admin_startup_profile_10_edit.png'],
    ['http://127.0.0.1:3000/admin/startup_profile', 'tmp/admin_startup_profile_index.png']
  ];
  for (const [url, out] of pairs) {
    console.log('Capturing', url, '->', out);
    await run(url, out);
  }
  console.log('Done');
})();
