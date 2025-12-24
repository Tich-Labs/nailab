
# Nailab Design System & Core Components

**Version:** 1.0 (MVP - December 2025)  
**Brand Alignment:** Purple primary (#6A1B9A) from logo hexagon, teal accent (#00BCD4) from "i" dot. Clean, professional, approachable UX for African startup ecosystem.

## Color Palette

| Color Name         | Hex Code  | Usage Guidelines                                                                 | Tailwind Class Example                       |
|-------------------|-----------|----------------------------------------------------------------------------------|----------------------------------------------|
| Nailab Purple     | #6A1B9A   | Primary: Logo bg, buttons, CTAs, nav highlights. Visual anchor for trust/creativity. | `bg-purple-700 text-white` (hover: `hover:bg-purple-800`) |
| Nailab Dark Purple| #4A148C   | Secondary: Hover states, accents, footers. Depth for interactions.                | `bg-purple-900`                              |
| Nailab Teal Accent| #00BCD4   | Accents: Icons, links, tags, active states. Pop from logo "i".                    | `text-cyan-500` or `bg-cyan-500`             |
| Nailab Light Purple| #EDE7F6  | Background tint: Cards, sections, subtle highlights.                              | `bg-purple-100`                              |
| Nailab Gray       | #F5F5F5   | Neutral bg: Dashboards, resource lists. Calm canvas.                              | `bg-gray-100`                                |
| Nailab Dark Gray  | #424242   | Headings, text emphasis. High contrast.                                           | `text-gray-800`                              |
| White             | #FFFFFF   | Main bg, text on purple/teal.                                                     | `bg-white`                                   |
| Black             | #000000   | Logo text fallback, high-contrast elements.                                       | `text-black`                                 |
| Error Red         | #EF4444   | Errors/Required: Asterisks, validations.                                          | `text-red-500`                               |
| Success Green     | #10B981   | Success: Confirms, request submitted.                                             | `text-green-500`                             |

| Name              | Hex       | Tailwind Class          | Usage                              |
|-------------------|-----------|-------------------------|------------------------------------|
| Primary (Purple)  | #6A1B9A  | `primary`              | Buttons, CTAs, headings, logo bg  |
| Primary Dark      | #4A148C  | `primary-dark`         | Hovers, footers                   |
| Accent (Teal)     | #00BCD4  | `accent`               | Links, tags, icons, active states |
| Neutral           | #F5F5F5  | `neutral`              | Card/section bgs                  |
| Neutral Dark      | #424242  | `neutral-dark`         | Body text, headings               |
| Light Purple      | #EDE7F6  | `bg-purple-100`        | Card/section bg, onboarding steps |
| Error Red         | #EF4444  | `text-red-500`         | Errors, required asterisks        |
| Success Green     | #10B981  | `text-green-500`       | Success, confirmations            |
| White             | #FFFFFF  | `bg-white`             | Main bg, text on purple/teal      |
| Black             | #000000  | `text-black`           | Logo text fallback, high contrast |

Tailwind config extension:
```js
colors: {
  primary: '#6A1B9A',
  'primary-dark': '#4A148C',
  accent: '#00BCD4',
  neutral: '#F5F5F5',
  'neutral-dark': '#424242',
  'light-purple': '#EDE7F6',
  error: '#EF4444',
  success: '#10B981',
}
```

## Typography
- Font: Inter (Google Fonts) or system sans-serif—clean, modern.
- Headings: Bold purple (#6A1B9A) or dark gray.
- Body: Dark gray for readability.
- Links: Teal accent underline on hover.

## Core Components

### 1. Navigation Header
Fixed top bar with purple logo, dropdowns for "Our Network" and "Resources".

```erb
<header class="fixed top-0 w-full bg-white shadow-md z-50">
  <div class="container mx-auto px-4 py-4 flex justify-between items-center">
    <%= link_to root_path do %>
      <%= image_tag "logo1.og.original.png", alt: "Nailab Logo", class: "h-12" %>
    <% end %>
    <nav class="hidden md:flex space-x-8">
      <!-- Dropdowns with teal hover -->
      <%= link_to "Login", new_user_session_path, class: "bg-primary text-white px-6 py-2 rounded-md hover:bg-primary-dark" %>
    </nav>
  </div>
</header>
```

### 2. Hero Section
Light purple tint bg, bold headline, dual CTAs, live stats cards.

```erb
<section class="bg-primary/10 py-20 text-center">
  <h1 class="text-5xl font-bold text-primary mb-6">Grow your startup with people who’ve done it before.</h1>
  <div class="flex justify-center gap-6">
    <button class="bg-primary text-white px-8 py-4 rounded-md hover:bg-primary-dark">Find a Mentor</button>
    <button class="border-2 border-accent text-accent px-8 py-4 rounded-md hover:bg-accent hover:text-white">Become a Mentor</button>
  </div>
  <!-- Stats grid -->
</section>
```

### 3. Program Cards Grid (with Filters)
Responsive grid, teal category tags, "Learn More" CTA.

```erb
<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
  <div class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg">
    <span class="bg-accent/10 text-accent px-3 py-1 rounded-full text-sm">Incubation</span>
    <h3 class="text-2xl font-semibold text-primary mt-4">Program Title</h3>
    <p class="text-neutral-dark my-4">Brief summary...</p>
    <button class="bg-primary text-white px-6 py-3 rounded-md hover:bg-primary-dark">Learn More</button>
  </div>
</div>
```

### 4. Onboarding Wizard Forms
Multi-step with purple progress bar, underline inputs, teal focus, radio ovals.

```erb
<div class="max-w-2xl mx-auto">
  <div class="w-full bg-gray-200 h-2 rounded-full mb-4">
    <div class="bg-primary h-2 rounded-full" style="width: 33%;"></div>
  </div>
  <input type="text" class="w-full border-b-2 border-gray-300 pb-3 focus:border-accent outline-none" placeholder="Full Name *" />
  <!-- Radio groups with accent fill -->
  <button class="bg-primary text-white px-8 py-4 rounded-md mt-8">Next</button>
</div>
```

### 5. Mentor/Founder Profile Cards & Dashboard
Directory cards with photo, bio, teal industry tags. Dashboard: Sidebar + metrics cards.

```erb
<!-- Profile Card -->
<div class="bg-white rounded-lg shadow-md p-6 flex">
  <%= image_tag mentor.photo, class: "w-24 h-24 rounded-full mr-6" %>
  <div>
    <h3 class="text-xl font-bold text-primary"><%= mentor.name %></h3>
    <div class="flex gap-2 mt-2">
      <span class="bg-accent/10 text-accent px-3 py-1 rounded-full text-sm">Fintech</span>
    </div>
    <a href="#" class="text-accent hover:underline mt-4 block">Book Session</a>
  </div>
</div>
```

## Implementation Notes
- Use ViewComponent or partials for reusability.
- Hotwire/Turbo for smooth interactions (filters, wizards).
- Test mobile: Stacked cards, touch-friendly buttons.
- Accessibility: Purple/teal on white: Excellent contrast (5:1+). Use aria-labels for logo.
- Override ActiveAdmin CSS for purple headers, teal actions.
- If shifting to teal-primary later, swap primary/accent in config.

---

**This design system ensures Nailab’s brand is consistent, modern, and accessible across all platforms.**
