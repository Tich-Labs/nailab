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
    } catch (e) {
      // ignore
    }
  });

  try {
    // Navigate to sign-in
    await page.goto('http://127.0.0.1:3000/users/sign_in', { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(300);

    // Fill the sign-in form
    await page.fill('input[name="user[email]"]', 'founder4@test.nailab.app');
    await page.fill('input[name="user[password]"]', 'TestPAssword4!');

    // Try clicking the submit button, then fall back to form.submit() if still on sign-in
    try {
      await Promise.all([
        page.click('input[type="submit"], button[type="submit"], button:has-text("Log in"), button:has-text("Sign in"), button:has-text("Sign In")'),
        page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 })
      ]);
    } catch (e) {
      // Fallback: directly submit the form
      try {
        await page.evaluate(() => { const f = document.getElementById('new_user') || document.querySelector('form.new_user'); if (f) f.submit(); });
        await page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {});
      } catch (e2) {
        // ignore
      }
    }

    // Ensure we land on the dashboard
    await page.goto('http://127.0.0.1:3000/founder/progress', { waitUntil: 'networkidle', timeout: 30000 }).catch(() => {});
    await page.waitForTimeout(800);

    // Save screenshot
    const screenshotPath = path.join(outDir, 'founder_progress.png');
    await page.screenshot({ path: screenshotPath, fullPage: true });

    // Save HTML
    const html = await page.content();
    fs.writeFileSync(path.join(outDir, 'founder_progress.html'), html);

    // Save console logs
    fs.writeFileSync(path.join(outDir, 'founder_progress_console.log'), consoleLog.join('\n'));

    console.log('Saved:', screenshotPath);
    console.log('Saved HTML and console log to', outDir);
  } catch (err) {
    console.error('Error during Playwright run:', err);
  } finally {
    await browser.close();
  }
})();
