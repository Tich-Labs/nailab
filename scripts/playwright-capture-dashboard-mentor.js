const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const base = 'http://127.0.0.1:3000';
  const email = 'mentor@example.com';
  const password = 'password';
  const outDir = './tmp/screenshots/dashboard';
  fs.mkdirSync(outDir, { recursive: true });

  const browser = await chromium.launch();
  const page = await browser.newPage();

  async function tryLogin() {
    const paths = ['/users/sign_in', '/sign_in', '/login'];
    for (const p of paths) {
      const url = base + p;
      const resp = await page.goto(url, { waitUntil: 'networkidle' });
      if (!resp) continue;
      if (resp.status() >= 400) continue;

      const emailSelectors = ['input[name="user[email]"]', 'input[type="email"]', 'input[name="email"]'];
      const passSelectors = ['input[name="user[password]"]', 'input[type="password"]', 'input[name="password"]'];
      let eSel = null, pSel = null;
      for (const s of emailSelectors) { if (await page.$(s)) { eSel = s; break; } }
      for (const s of passSelectors) { if (await page.$(s)) { pSel = s; break; } }
      if (!eSel || !pSel) continue;

      await page.fill(eSel, email);
      await page.fill(pSel, password);
      await Promise.all([
        page.waitForNavigation({ waitUntil: 'networkidle', timeout: 10000 }).catch(() => {}),
        page.click('button[type="submit"], input[type="submit"], text=Log in, text="Sign in"').catch(() => {})
      ]);
      return true;
    }
    return false;
  }

  console.log('Attempting login as mentor');
  const ok = await tryLogin();
  if (!ok) console.warn('Login form not found or login failed — attempting direct /dashboard visit');

  await page.goto(base, { waitUntil: 'networkidle' });
  if (await page.$('text=Go to Dashboard')) {
    await Promise.all([page.waitForNavigation({ waitUntil: 'networkidle' }), page.click('text=Go to Dashboard')]).catch(() => {});
  } else {
    await page.goto(base + '/dashboard', { waitUntil: 'networkidle' }).catch(() => {});
  }

  const out = `${outDir}/mentor-dashboard.png`;
  await page.screenshot({ path: out, fullPage: true });
  console.log('Saved', out);

  await browser.close();
  console.log('Mentor dashboard capture complete');
})();
