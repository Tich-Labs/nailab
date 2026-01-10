const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const BASE = 'http://127.0.0.1:3000';

function ensureDir(dir) {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
}

async function signIn(page, email, password) {
  await page.goto(`${BASE}/users/sign_in`, { waitUntil: 'networkidle' });
  await page.fill('input[name="user[email]"]', email).catch(() => {});
  await page.fill('input[name="user[password]"]', password).catch(() => {});
  await Promise.all([
    page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {}),
    page.click('input[type="submit"], button[type="submit"]').catch(() => {}),
  ]).catch(() => {});
}

async function capture(page, outDir, name) {
  ensureDir(outDir);
  const file = path.join(outDir, `${name}.png`);
  await page.screenshot({ path: file, fullPage: true });
  console.log('Saved', file);
}

async function runFounderFlow(context) {
  const page = await context.newPage();
  const outDir = path.resolve(__dirname, '..', 'tmp', 'screenshots', 'onboarding', 'founder');
  // Sign in
  await signIn(page, 'founder@example.com', 'password');

  // Steps: personal -> startup -> professional -> mentorship -> confirm
  const steps = [
    { url: `${BASE}/founder_onboarding?step=personal`, fills: [ ['founder_onboarding[user_profile][full_name]','Founder Test'], ['founder_onboarding[user_profile][phone]','+123456789'], ['founder_onboarding[user_profile][country]','Kenya'], ['founder_onboarding[user_profile][city]','Nairobi'] ] },
    { url: `${BASE}/founder_onboarding?step=startup`, fills: [ ['founder_onboarding[startup_profile][startup_name]','Founders Ltd'], ['founder_onboarding[startup_profile][description]','We build stuff'], ['founder_onboarding[startup_profile][stage]','seed'], ['founder_onboarding[startup_profile][value_proposition]','Great product'] ] },
    { url: `${BASE}/founder_onboarding?step=professional`, fills: [ ['founder_onboarding[startup_profile][sector]','tech'], ['founder_onboarding[startup_profile][funding_stage]','pre-seed'], ['founder_onboarding[startup_profile][funding_raised]','0'] ] },
    { url: `${BASE}/founder_onboarding?step=mentorship`, fills: [ ['founder_onboarding[startup_profile][mentorship_areas][]','strategy'], ['founder_onboarding[startup_profile][challenge_details]','Need help scaling'], ['founder_onboarding[startup_profile][preferred_mentorship_mode]','remote'] ] },
    { url: `${BASE}/founder_onboarding?step=confirm`, fills: [] },
  ];

  let i = 1;
  for (const s of steps) {
    console.log('Founder: visiting', s.url);
    await page.goto(s.url, { waitUntil: 'networkidle' });
    await capture(page, outDir, `step-${i}-before`);
    // fill fields
    for (const f of s.fills) {
      const [name, value] = f;
      try { await page.fill(`input[name="${name}"]`, value); } catch(e) { try { await page.fill(`textarea[name="${name}"]`, value); } catch(e2) {} }
    }
    // submit
    try {
      await Promise.all([
        page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {}),
        page.click('input[type="submit"], button[type="submit"]').catch(() => {}),
      ]).catch(() => {});
    } catch (e) {}
    await capture(page, outDir, `step-${i}-after`);
    i++;
  }
  await page.close();
}

async function runMentorFlow(context) {
  const page = await context.newPage();
  const outDir = path.resolve(__dirname, '..', 'tmp', 'screenshots', 'onboarding', 'mentor');
  await signIn(page, 'mentor@example.com', 'password');

  // Steps: basic_details -> work_experience -> mentorship_focus -> mentorship_style -> availability -> review
  const steps = [
    { url: `${BASE}/mentor_onboarding?step=basic_details`, fills: [ ['user_profile[full_name]','Mentor Test'], ['user_profile[bio]','Experienced founder and operator with 10+ years in startups.'], ['user_profile[title]','Advisor'] ] },
    { url: `${BASE}/mentor_onboarding?step=work_experience`, fills: [ ['user_profile[organization]','BigCo'], ['user_profile[years_experience]','10'], ['user_profile[advisory_experience]','true'], ['user_profile[advisory_description]','Advised multiple startups.'] ] },
    { url: `${BASE}/mentor_onboarding?step=mentorship_focus`, fills: [ ['user_profile[sectors][]','tech'], ['user_profile[expertise][]','fundraising'], ['user_profile[stage_preference][]','seed'] ] },
    { url: `${BASE}/mentor_onboarding?step=mentorship_style`, fills: [ ['user_profile[mentorship_approach]','Hands-on weekly sessions'], ['user_profile[motivation]','I enjoy helping founders.'] ] },
    { url: `${BASE}/mentor_onboarding?step=availability`, fills: [ ['user_profile[availability_hours_month]','5'], ['user_profile[preferred_mentorship_mode]','remote'], ['user_profile[rate_per_hour]','50'], ['user_profile[linkedin_url]','https://linkedin.example.com/test'] ] },
    { url: `${BASE}/mentor_onboarding?step=review`, fills: [] },
  ];

  let i = 1;
  for (const s of steps) {
    console.log('Mentor: visiting', s.url);
    await page.goto(s.url, { waitUntil: 'networkidle' });
    await capture(page, outDir, `step-${i}-before`);
    for (const f of s.fills) {
      const [name, value] = f;
      try { await page.fill(`input[name="${name}"]`, value); } catch(e) { try { await page.fill(`textarea[name="${name}"]`, value); } catch(e2) {} }
    }
    try {
      await Promise.all([
        page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {}),
        page.click('input[type="submit"], button[type="submit"]').catch(() => {}),
      ]).catch(() => {});
    } catch (e) {}
    await capture(page, outDir, `step-${i}-after`);
    i++;
  }
  await page.close();
}

async function runPartnerFlow(context) {
  const page = await context.newPage();
  const outDir = path.resolve(__dirname, '..', 'tmp', 'screenshots', 'onboarding', 'partner');

  const steps = [
    { url: `${BASE}/partner_onboarding?step=organization`, fills: [ ['partner_onboarding[organization_name]','Acme Corp'], ['partner_onboarding[organization_website]','https://acme.example.com'], ['partner_onboarding[organization_country]','Nigeria'], ['partner_onboarding[organization_description]','We run programs.'] ] },
    { url: `${BASE}/partner_onboarding?step=type_and_contact`, fills: [ ['partner_onboarding[organization_type]','NGO'], ['partner_onboarding[contact_person]','Sam Partner'] ] },
    { url: `${BASE}/partner_onboarding?step=focus_and_collab`, fills: [ ['partner_onboarding[focus_sectors][]','education'], ['partner_onboarding[collaboration_areas][]','events'] ] },
    { url: `${BASE}/partner_onboarding?step=confirm`, fills: [] },
  ];

  let i = 1;
  for (const s of steps) {
    console.log('Partner: visiting', s.url);
    await page.goto(s.url, { waitUntil: 'networkidle' });
    await capture(page, outDir, `step-${i}-before`);
    for (const f of s.fills) {
      const [name, value] = f;
      try { await page.fill(`input[name="${name}"]`, value); } catch(e) { try { await page.fill(`textarea[name="${name}"]`, value); } catch(e2) {} }
    }
    try {
      await Promise.all([
        page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {}),
        page.click('input[type="submit"], button[type="submit"]').catch(() => {}),
      ]).catch(() => {});
    } catch (e) {}
    await capture(page, outDir, `step-${i}-after`);
    i++;
  }
  await page.close();
}

(async () => {
  const outRoot = path.resolve(__dirname, '..', 'tmp', 'screenshots', 'onboarding');
  ensureDir(outRoot);
  const browser = await chromium.launch();
  const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });

  try {
    await runFounderFlow(context);
    await runMentorFlow(context);
    await runPartnerFlow(context);
  } catch (e) {
    console.error('Error during onboarding flows', e);
  }

  await browser.close();
  console.log('Onboarding screenshots complete');
})();
