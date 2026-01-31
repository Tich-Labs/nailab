const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
  const page = await context.newPage();
  try {
    await page.goto('http://127.0.0.1:3000/users/sign_in', { waitUntil: 'networkidle' });
    await page.evaluate(async (creds) => {
      const tokenInput = document.querySelector('input[name="authenticity_token"]');
      const token = tokenInput ? tokenInput.value : (document.querySelector('meta[name="csrf-token"]')||{}).content;
      const params = new URLSearchParams();
      params.append('user[email]', creds.email);
      params.append('user[password]', creds.password);
      params.append('authenticity_token', token);
      await fetch('/users/sign_in', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params.toString(), credentials: 'same-origin', redirect: 'follow' });
    }, { email: 'founder4@test.nailab.app', password: 'TestPassword4!' });

    await page.goto('http://127.0.0.1:3000/founder/progress', { waitUntil: 'networkidle' });
    const info = await page.evaluate(() => {
      return {
        chartkickPresent: typeof window.Chartkick !== 'undefined',
        chartPresent: typeof window.Chart !== 'undefined',
        chartkickUse: !!(window.Chartkick && window.Chartkick.use),
        scripts: Array.from(document.scripts).map(s => s.src).filter(Boolean),
        inlineScripts: Array.from(document.scripts).map(s => s.innerText).filter(Boolean).slice(0,5)
      };
    });
    console.log('Chart info:', info);
  } catch (err) {
    console.error(err);
  } finally {
    await browser.close();
  }
})();
