const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const url = 'http://127.0.0.1:3000/founder_onboarding?step=personal';
  const outDir = './tmp/screenshots/onboarding/founder';
  fs.mkdirSync(outDir, { recursive: true });

  const browser = await chromium.launch();
  const page = await browser.newPage();
  console.log(`Visiting ${url}`);
  const resp = await page.goto(url, { waitUntil: 'networkidle' });
  console.log('Status', resp.status());
  const out = `${outDir}/step-1-personal.png`;
  await page.screenshot({ path: out, fullPage: true });
  console.log('Saved', out);
  await browser.close();
  console.log('Founder step 1 capture complete');
})();
