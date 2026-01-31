const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const outDir = path.resolve(__dirname, '..', 'tmp', 'playwright');
  fs.mkdirSync(outDir, { recursive: true });
  const consoleLog = [];

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
  const page = await context.newPage();

  page.on('console', msg => {
    try {
      const text = `${msg.type().toUpperCase()}: ${msg.text()}`;
      consoleLog.push(text);
      console.log(text);
    } catch (e) {}
  });

  try {
    await page.goto('http://127.0.0.1:3000/users/sign_in', { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(200);

    // Extract authenticity token and submit via fetch inside page context
    const loginResult = await page.evaluate(async (creds) => {
      const email = creds.email;
      const password = creds.password;
      const tokenInput = document.querySelector('input[name="authenticity_token"]');
      const token = tokenInput ? tokenInput.value : (document.querySelector('meta[name="csrf-token"]')||{}).content;
      if (!token) return { ok: false, error: 'no_csrf' };

      const params = new URLSearchParams();
      params.append('user[email]', email);
      params.append('user[password]', password);
      params.append('authenticity_token', token);

      const resp = await fetch('/users/sign_in', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString(),
        credentials: 'same-origin',
        redirect: 'follow'
      });
      return { ok: resp.ok, status: resp.status, redirected: resp.redirected, url: resp.url, text: await resp.text().catch(()=>null) };
    }, { email: 'founder4@test.nailab.app', password: 'TestPassword4!' });

    console.log('Login result:', loginResult);

    // Navigate to the dashboard
    await page.goto('http://127.0.0.1:3000/founder/progress', { waitUntil: 'networkidle', timeout: 30000 }).catch(()=>{});
    await page.waitForTimeout(500);

    // Save screenshot
    const screenshotPath = path.join(outDir, 'founder_progress_loggedin.png');
    await page.screenshot({ path: screenshotPath, fullPage: true });

    // Save HTML
    const html = await page.content();
    fs.writeFileSync(path.join(outDir, 'founder_progress_loggedin.html'), html);

    // Save console logs
    fs.writeFileSync(path.join(outDir, 'founder_progress_loggedin_console.log'), consoleLog.join('\n'));

    console.log('Saved:', screenshotPath);
    console.log('Saved HTML and console log to', outDir);
  } catch (err) {
    console.error('Error during Playwright run:', err);
  } finally {
    await browser.close();
  }
})();
