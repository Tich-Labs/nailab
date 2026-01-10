const { chromium } = require('playwright');
const fs = require('fs');

async function captureFlow(name, basePath, steps) {
  const outDir = `./tmp/screenshots/onboarding/${name}`;
  fs.mkdirSync(outDir, { recursive: true });
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1200, height: 900 } });

  for (let i = 0; i < steps.length; i++) {
    const step = steps[i];
    const url = `${basePath}?step=${encodeURIComponent(step)}`;
    try {
      console.log(`Visiting ${url}`);
      const resp = await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
      const status = resp ? resp.status() : 'no-response';
      console.log('Status', status);
      const file = `${outDir}/step-${i+1}.png`;
      await page.screenshot({ path: file, fullPage: true });
      console.log('Saved', file);
      await page.waitForTimeout(300);
    } catch (err) {
      console.error('Error visiting', url, err && err.message);
    }
  }

  await browser.close();
}

(async () => {
  // Founder onboarding steps
  await captureFlow('founder', 'http://127.0.0.1:3000/founder_onboarding', ['personal','startup','professional','mentorship','confirm']);

  // Mentor onboarding steps
  await captureFlow('mentor', 'http://127.0.0.1:3000/mentor_onboarding', ['basic_details','work_experience','mentorship_focus','mentorship_style','availability','review']);

  // Partner onboarding steps
  await captureFlow('partner', 'http://127.0.0.1:3000/partner_onboarding', ['organization','type_and_contact','focus_and_collab','confirm']);

  console.log('Onboarding capture complete');
})();
