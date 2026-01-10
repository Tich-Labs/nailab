const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const base = 'http://127.0.0.1:3000';
  const email = 'founder@example.com';
  const password = 'password';
  const outDir = './tmp/screenshots/founder';
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

  console.log('Attempting login as founder');
  await tryLogin();

  // Go to dashboard/root
  await page.goto(base, { waitUntil: 'networkidle' });
  if (await page.$('text=Go to Dashboard')) {
    await Promise.all([page.waitForNavigation({ waitUntil: 'networkidle' }), page.click('text=Go to Dashboard')]).catch(() => {});
  } else {
    await page.goto(base + '/founder', { waitUntil: 'networkidle' }).catch(() => {});
  }

  const rootOut = `${outDir}/founder-root.png`;
  await page.screenshot({ path: rootOut, fullPage: true });
  console.log('Saved', rootOut);

  const candidatePaths = [
    '/founder/account',
    '/founder/account/edit',
    '/founder/startup_profile',
    '/founder/startup_profile/edit',
    '/founder/progress',
    '/founder/mentorship'
  ];

  for (const p of candidatePaths) {
    try {
      const url = base + p;
      console.log('Visiting', url);
      const resp = await page.goto(url, { waitUntil: 'networkidle' });
      const status = resp ? resp.status() : 'n/a';
      console.log('Status', status);
      if (resp && resp.status() === 200) {
        const name = p.replace(/\//g, '-').replace(/^-/, '') || 'index';
        const out = `${outDir}/${name}.png`;
        await page.screenshot({ path: out, fullPage: true });
        console.log('Saved', out);
      }
    } catch (err) {
      console.warn('Error visiting', p, err.message);
    }
  }

  // Try clicking obvious links from founder area (Account, Profile, Startup)
  const linkSelectors = ['text=Account', 'text=My Account', 'text=Startup profile', 'text=Startup Profile', 'text=Profile', 'text=Edit Profile', 'text=Edit account'];
  for (const sel of linkSelectors) {
    if (await page.$(sel)) {
      try {
        await Promise.all([page.waitForNavigation({ waitUntil: 'networkidle' }), page.click(sel)]).catch(() => {});
        const slug = sel.replace(/[^a-z0-9]/gi, '_').slice(0, 40);
        const out = `${outDir}/founder-${slug}.png`;
        await page.screenshot({ path: out, fullPage: true });
        console.log('Saved', out);
        await page.goto(base + '/founder', { waitUntil: 'networkidle' }).catch(() => {});
      } catch (err) {
        console.warn('Failed to capture via selector', sel, err.message);
      }
    }
  }

  await browser.close();
  console.log('Founder pages capture complete');
})();
