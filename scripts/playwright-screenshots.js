const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const outDir = path.resolve(__dirname, '..', 'tmp', 'screenshots');
  fs.mkdirSync(outDir, { recursive: true });

  const browser = await chromium.launch();
  const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
  const page = await context.newPage();

  const pages = [
    { url: 'http://127.0.0.1:3000/', name: 'homepage' },
    { url: 'http://127.0.0.1:3000/founder', name: 'founder', auth: { email: 'founder@example.com', password: 'password' } },
    { url: 'http://127.0.0.1:3000/mentor', name: 'mentor', auth: { email: 'mentor@example.com', password: 'password' } },
    { url: 'http://127.0.0.1:3000/partner_onboarding', name: 'partner_onboarding' },
  ];

  for (const p of pages) {
    try {
      console.log('Processing', p.name, p.url);
      // If page requires auth, perform sign in first
      if (p.auth) {
        await page.goto('http://127.0.0.1:3000/users/sign_in', { waitUntil: 'networkidle' });
        // Fill Devise sign-in form
        await page.fill('input[name="user[email]"]', p.auth.email);
        await page.fill('input[name="user[password]"]', p.auth.password);
        await Promise.all([
          page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }),
          page.click('input[type="submit"], button[type="submit"]'),
        ]).catch(() => {});
        await page.waitForTimeout(500);
      }

      const resp = await page.goto(p.url, { waitUntil: 'networkidle', timeout: 30000 });
      if (resp) console.log(p.url, 'status', resp.status());
      await page.waitForTimeout(1000);
      const file = path.join(outDir, `${p.name}.png`);
      await page.screenshot({ path: file, fullPage: true });
      console.log('Saved', file);
      // If we logged in, sign out for next iteration
      if (p.auth) {
        try {
          await page.goto('http://127.0.0.1:3000/users/sign_out', { waitUntil: 'networkidle' });
        } catch (e) {}
        await context.clearCookies();
      }
    } catch (err) {
      console.error('Error capturing', p.url, err.message);
    }
  }

  await browser.close();
  console.log('Done');
})();

// Additional flow: mentor onboarding automation (authenticated)
// This function logs in as the mentor test user and walks through onboarding steps,
// filling simple sample values and saving a screenshot for each step.
(async () => {
  const outDir = require('path').resolve(__dirname, '..', 'tmp', 'screenshots');
  const browser = await chromium.launch();
  const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
  const page = await context.newPage();
  const mentor = { email: 'mentor@example.com', password: 'password' };

  try {
    console.log('Mentor onboarding: running as guest (no sign-in)');
    // Ensure we start as a guest
    await context.clearCookies();

    const steps = [
      { step: 'basic_details', data: {
        'user_profile[full_name]': 'Automated Mentor',
        'user_profile[bio]': 'Experienced founder and advisor with 10+ years in tech. I help startups scale.',
        'user_profile[title]': 'Senior Advisor'
      }},
      { step: 'work_experience', data: {
        'user_profile[organization]': 'Mentor Org',
        'user_profile[years_experience]': '12',
        'user_profile[advisory_experience]': 'true',
        'user_profile[advisory_description]': 'Advised several startups on go-to-market and fundraising.'
      }},
      { step: 'mentorship_focus', data: {
        // arrays: try to set by creating hidden inputs if selects are not present
        'user_profile[sectors][]': 'Technology',
        'user_profile[expertise][]': 'Fundraising',
        'user_profile[stage_preference][]': 'seed'
      }},
      { step: 'mentorship_style', data: {
        'user_profile[mentorship_approach]': 'Hands-on, weekly check-ins and milestone-driven support.',
        'user_profile[motivation]': 'I enjoy helping founders build sustainable businesses.'
      }},
      { step: 'availability', data: {
        'user_profile[availability_hours_month]': '8',
        'user_profile[preferred_mentorship_mode]': 'online',
        'user_profile[rate_per_hour]': '0',
        'user_profile[pro_bono]': 'true',
        'user_profile[linkedin_url]': 'https://linkedin.example/mentor',
        'user_profile[professional_website]': 'https://mentor.example'
      }},
    ];

    for (let i = 0; i < steps.length; i++) {
      const s = steps[i];
      const url = `http://127.0.0.1:3000/mentor_onboarding?step=${s.step}`;
      console.log('Visiting', url);
      await page.goto(url, { waitUntil: 'networkidle' });
      // Fill inputs based on keys present
      for (const [name, value] of Object.entries(s.data)) {
        try {
          const exists = await page.$(`[name="${name}"]`);
          if (exists) {
            await page.fill(`[name="${name}"]`, value.toString()).catch(() => {});
          } else {
            // Try to inject hidden input for array params
            if (name.endsWith('[]')) {
              await page.evaluate((n, v) => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = n;
                input.value = v;
                document.querySelector('form')?.appendChild(input);
              }, name, value).catch(() => {});
            }
          }
        } catch (e) {
          console.warn('Error filling', name, e.message);
        }
      }
      // Submit the form (try common submit selectors)
      try {
        await Promise.all([
          page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {}),
          page.click('input[type="submit"], button[type="submit"], button.next, a.button').catch(() => {}),
        ]).catch(() => {});
      } catch (e) {}

      const file = require('path').join(outDir, `mentor_onboarding_${String(i+1).padStart(2,'0')}_${s.step}.png`);
      await page.screenshot({ path: file, fullPage: true });
      console.log('Saved', file);
      await page.waitForTimeout(500);
    }

    // Final review/confirm page
    await page.goto('http://127.0.0.1:3000/mentor_onboarding?step=review', { waitUntil: 'networkidle' });
    const reviewFile = require('path').join(outDir, `mentor_onboarding_review.png`);
    await page.screenshot({ path: reviewFile, fullPage: true });
    console.log('Saved', reviewFile);

  } catch (err) {
    console.error('Mentor onboarding flow failed:', err.message);
  } finally {
    await browser.close();
  }
})();

// Partner onboarding automation (guest flow)
(async () => {
  const outDir = require('path').resolve(__dirname, '..', 'tmp', 'screenshots');
  const browser = await chromium.launch();
  const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
  const page = await context.newPage();
  try {
    console.log('Partner onboarding: running as guest');
    await context.clearCookies();

    const steps = [
      { step: 'organization', data: {
        'partner_onboarding[organization_name]': 'Acme Corporation',
        'partner_onboarding[organization_website]': 'https://acme.example',
        'partner_onboarding[organization_country]': 'Nigeria',
        'partner_onboarding[organization_description]': 'We support startups with funding and mentorship.'
      }},
      { step: 'type_and_contact', data: {
        'partner_onboarding[organization_type]': 'Non-profit',
        'partner_onboarding[contact_person]': 'Sam Partner'
      }},
      { step: 'focus_and_collab', data: {
        'partner_onboarding[focus_sectors][]': 'Technology',
        'partner_onboarding[collaboration_areas][]': 'Funding'
      }},
      { step: 'confirm', data: {} }
    ];

    for (let i = 0; i < steps.length; i++) {
      const s = steps[i];
      const url = `http://127.0.0.1:3000/partner_onboarding?step=${s.step}`;
      console.log('Visiting', url);
      await page.goto(url, { waitUntil: 'networkidle' });
      // Fill fields
      for (const [name, value] of Object.entries(s.data)) {
        try {
          const exists = await page.$(`[name="${name}"]`);
          if (exists) {
            await page.fill(`[name="${name}"]`, value.toString()).catch(() => {});
          } else if (name.endsWith('[]')) {
            await page.evaluate((n, v) => {
              const input = document.createElement('input');
              input.type = 'hidden';
              input.name = n;
              input.value = v;
              document.querySelector('form')?.appendChild(input);
            }, name, value).catch(() => {});
          }
        } catch (e) {
          console.warn('Error filling', name, e.message);
        }
      }

      // Submit the form where present
      try {
        await Promise.all([
          page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {}),
          page.click('input[type="submit"], button[type="submit"], a.button').catch(() => {})
        ]).catch(() => {});
      } catch (e) {}

      const file = require('path').join(outDir, `partner_onboarding_${String(i+1).padStart(2,'0')}_${s.step}.png`);
      await page.screenshot({ path: file, fullPage: true });
      console.log('Saved', file);
      await page.waitForTimeout(500);
    }

  } catch (err) {
    console.error('Partner onboarding flow failed:', err.message);
  } finally {
    await browser.close();
  }
})();
