const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const outFounder = './tmp/screenshots/onboarding/founder';
  const outMentor = './tmp/screenshots/onboarding/mentor';
  fs.mkdirSync(outFounder, { recursive: true });
  fs.mkdirSync(outMentor, { recursive: true });

  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1200, height: 900 } });

  const targets = [
    { url: 'http://127.0.0.1:3000/founder_onboarding?step=confirm', path: `${outFounder}/confirm.png` },
    { url: 'http://127.0.0.1:3000/mentor_onboarding?step=mentorship_focus', path: `${outMentor}/step-3-mentorship_focus.png` },
    { url: 'http://127.0.0.1:3000/mentor_onboarding?step=availability', path: `${outMentor}/step-5-availability.png` }
  ];

  for (const t of targets) {
    try {
      console.log('Visiting', t.url);
      const resp = await page.goto(t.url, { waitUntil: 'networkidle', timeout: 30000 });
      console.log('Status', resp ? resp.status() : 'no-response');
      await page.screenshot({ path: t.path, fullPage: true });
      console.log('Saved', t.path);
      await page.waitForTimeout(300);
    } catch (err) {
      console.error('Error capturing', t.url, err && err.message);
    }
  }

  await browser.close();
  console.log('Specific onboarding capture finished');
})();
