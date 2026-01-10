const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const out = './tmp/screenshots/onboarding/mentor';
  fs.mkdirSync(out, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1200, height: 900 } });
  const url = 'http://127.0.0.1:3000/mentor_onboarding?step=review';
  try {
    console.log('Visiting', url);
    const resp = await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
    console.log('Status', resp ? resp.status() : 'no-response');
    await page.screenshot({ path: `${out}/review.png`, fullPage: true });
    console.log('Saved', `${out}/review.png`);
  } catch (err) {
    console.error('Error capturing review', err && err.message);
  }
  await browser.close();
})();
