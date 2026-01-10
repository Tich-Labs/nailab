const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const base = 'http://127.0.0.1:3000';
  const email = 'foundert@email.com';
  const password = 'passWord$';
  const outDir = './tmp/screenshots/founder';
  fs.mkdirSync(outDir, { recursive: true });

  const browser = await chromium.launch();
  const page = await browser.newPage();

  // Go to sign in and fill credentials
  const signInUrl = base + '/users/sign_in';
  console.log('Visiting', signInUrl);
  await page.goto(signInUrl, { waitUntil: 'networkidle' });

  const emailSelectors = ['input[name="user[email]"]', 'input[type="email"]', 'input[name="email"]'];
  const passSelectors = ['input[name="user[password]"]', 'input[type="password"]', 'input[name="password"]'];
  let eSel = null, pSel = null;
  for (const s of emailSelectors) { if (await page.$(s)) { eSel = s; break; } }
  for (const s of passSelectors) { if (await page.$(s)) { pSel = s; break; } }

  if (!eSel || !pSel) {
    console.warn('Login form selectors not found; attempting to visit /founder directly');
    await page.goto(base + '/founder', { waitUntil: 'networkidle' });
  } else {
    await page.fill(eSel, email);
    await page.fill(pSel, password);
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle', timeout: 10000 }).catch(() => {}),
      page.click('button[type="submit"], input[type="submit"], text=Log in, text="Sign in"').catch(() => {})
    ]);
  }

  // Visit founder dashboard
  const url = base + '/founder';
  console.log('Visiting', url);
  const resp = await page.goto(url, { waitUntil: 'networkidle' }).catch(() => null);
  console.log('Page status', resp ? resp.status() : 'n/a');

  const out = `${outDir}/loggedin-founder-dashboard.png`;
  await page.screenshot({ path: out, fullPage: true });
  console.log('Saved', out);

  await browser.close();
  console.log('Capture complete');
})();
