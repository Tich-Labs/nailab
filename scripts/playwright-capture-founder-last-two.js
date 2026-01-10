const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const outDir = './tmp/screenshots/onboarding/founder';
  fs.mkdirSync(outDir, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1200, height: 900 } });

  const steps = [
    { step: 'mentorship', file: 'step-4-after.png' },
    { step: 'confirm', file: 'step-5-after.png' }
  ];

  for (const s of steps) {
    const url = `http://127.0.0.1:3000/founder_onboarding?step=${encodeURIComponent(s.step)}`;
    try {
      console.log('Visiting', url);
      const resp = await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
      console.log('Status', resp ? resp.status() : 'no-response');
      const path = `${outDir}/${s.file}`;
      await page.screenshot({ path, fullPage: true });
      console.log('Saved', path);
      await page.waitForTimeout(200);
    } catch (err) {
      console.error('Error capturing', s.step, err && err.message);
    }
  }

  await browser.close();
  console.log('Founder last-two capture finished');
})();
