const { chromium } = require('playwright');

async function run(url, out) {
  const browser = await chromium.launch({ args: ['--no-sandbox'] });
  const page = await browser.newPage();
  await page.goto(url, { waitUntil: 'networkidle' });
  await page.screenshot({ path: out, fullPage: true });
  await browser.close();
}

(async () => {
  const url = 'http://127.0.0.1:3000/admin';
  const out = 'tmp/admin_home.png';
  console.log('Capturing', url, '->', out);
  await run(url, out);
  console.log('Done');
})();
