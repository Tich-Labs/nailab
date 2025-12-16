# Seed static pages for admin editing
StaticPage.create!(
  [
    {
      title: "About Nailab",
      slug: "about",
      content: <<~HTML
        <h1>About Nailab</h1>
        <p>We amplify African founders by connecting them with curated mentorship, tailored programs, and high-touch support.</p>
        <p>Our community includes operators, investors, and founders who share knowledge, capital, and networks.</p>
      HTML
    },
    {
      title: "Pricing",
      slug: "pricing",
      content: <<~HTML
        <h1>Pricing</h1>
        <p>We support founders via scholarships, cohort sponsorships, and pay-as-you-go mentor sessions.</p>
        <div class=\"card-grid\">
          <article class=\"card\">
            <h2>Founders</h2>
            <ul>
              <li>Access to matching mentors and bootcamps</li>
              <li>Equity-friendly program cohorts</li>
              <li>Flexible government-backed pricing</li>
            </ul>
          </article>
          <article class=\"card\">
            <h2>Mentors</h2>
            <ul>
              <li>Opportunity to join short-term engagements</li>
              <li>Paid pro-bono and paid mentorship slots</li>
              <li>Visibility in our partner network</li>
            </ul>
          </article>
        </div>
      HTML
    },
    {
      title: "Contact Nailab",
      slug: "contact",
      content: <<~HTML
        <h1>Contact Nailab</h1>
        <p>Reach out at <a href=\"mailto:hello@nailab.africa\">hello@nailab.africa</a> or visit us in Nairobi.</p>
        <form class=\"contact-form\" action=\"mailto:hello@nailab.africa\" method=\"post\" enctype=\"text/plain\">
          <label>Full Name<input type=\"text\" name=\"name\" required></label>
          <label>Email<input type=\"email\" name=\"email\" required></label>
          <label>Message
            <textarea name=\"message\" rows=\"4\" required></textarea>
          </label>
          <button type=\"submit\" class=\"btn primary\">Send message</button>
        </form>
      HTML
    }
  ]
)
