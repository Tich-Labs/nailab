# Mobile Responsiveness QA Testing Guide

## Overview
This document outlines manual testing procedures for mobile responsiveness across key user flows in the NaiLab application.

## Testing Environment Setup

### Browser Developer Tools
- Use Chrome DevTools Device Mode or Firefox Responsive Design Mode
- Test on actual devices when possible

### Key Viewport Sizes to Test
- **Mobile**: 375x667 (iPhone SE), 390x844 (iPhone 12/13), 414x896 (iPhone XR)
- **Tablet**: 768x1024 (iPad), 810x1080 (iPad Pro 11"), 1024x1366 (iPad Pro 12.9")
- **Desktop**: 1920x1080, 1440x900

## Test Cases by Page/Component

### 1. Landing Page (`/`)
**Mobile (< 768px):**
- [ ] Hamburger menu appears in top-right
- [ ] Hero section stacks vertically
- [ ] CTA buttons are full-width and touch-friendly (min 44px height)
- [ ] Navigation menu slides in from left when hamburger tapped
- [ ] Footer links are readable and clickable

**Tablet (768px - 1024px):**
- [ ] Navigation shows horizontally
- [ ] Hero content displays in 2-column layout
- [ ] Cards maintain proper spacing

**Desktop (> 1024px):**
- [ ] Full navigation bar visible
- [ ] Hero section displays in full width
- [ ] All elements properly aligned

### 2. Founder Dashboard (`/founder`)
**Mobile:**
- [ ] Sidebar collapses to hamburger menu
- [ ] Dashboard cards stack vertically
- [ ] Touch targets are at least 44px
- [ ] Text remains readable (min 14px font)
- [ ] Swipe gestures work for navigation

**Tablet:**
- [ ] Sidebar shows as overlay or collapsible
- [ ] Dashboard widgets display in 2-column grid
- [ ] Navigation remains accessible

**Desktop:**
- [ ] Full sidebar visible
- [ ] Dashboard uses full width layout
- [ ] All widgets display in optimal grid

### 3. Mentorship Directory (`/founder/mentorship`)
**Mobile:**
- [ ] Mentor cards stack vertically
- [ ] "Request Session" buttons are prominent and touch-friendly
- [ ] Modal dialogs display full-screen on small devices
- [ ] Form inputs are properly sized for thumbs

**Tablet:**
- [ ] Cards display in 2-column grid
- [ ] Modal dialogs are appropriately sized

**Desktop:**
- [ ] Cards display in 3-column grid
- [ ] Modal dialogs are desktop-optimized

### 4. Programs Page (`/programs`)
**Mobile:**
- [ ] Program cards stack vertically
- [ ] Filter buttons are horizontal scrollable or stacked
- [ ] Category tags are readable
- [ ] "Learn More" buttons are prominent

**Tablet:**
- [ ] Cards display in 2-column grid
- [ ] Filters display horizontally

**Desktop:**
- [ ] Cards display in 3-column grid
- [ ] Full filter functionality available

### 5. Forms (Onboarding, Profile Edit, etc.)
**Mobile:**
- [ ] Input fields are full-width
- [ ] Labels positioned above inputs
- [ ] Error messages display clearly
- [ ] Submit buttons are prominent
- [ ] Keyboard doesn't obscure inputs

**Tablet/Desktop:**
- [ ] Form layouts are optimized for larger screens
- [ ] Multi-column forms where appropriate

### 6. Navigation & Menus
**Mobile:**
- [ ] Hamburger menu opens/closes smoothly
- [ ] Menu items are large enough to tap
- [ ] Active page is clearly indicated
- [ ] Back/close buttons work properly

**Tablet/Desktop:**
- [ ] Navigation displays appropriately
- [ ] Dropdown menus work correctly

## Common Issues to Check

### Layout Issues
- [ ] Content doesn't overflow horizontally
- [ ] Images are properly sized/scaled
- [ ] Text doesn't wrap awkwardly
- [ ] Elements don't overlap

### Touch/Interaction Issues
- [ ] Buttons are at least 44px tall
- [ ] Links have sufficient spacing
- [ ] Swipe gestures work where expected
- [ ] Hover states don't break on touch devices

### Performance Issues
- [ ] Pages load quickly on mobile connections
- [ ] Images are optimized for mobile
- [ ] JavaScript doesn't block rendering

## Browser Compatibility Testing

### Mobile Browsers
- [ ] Safari iOS (latest 2 versions)
- [ ] Chrome Android (latest)
- [ ] Firefox Android (latest)
- [ ] Samsung Internet (latest)

### Desktop Browsers
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)

## Automated Testing Integration

Run the automated responsive tests:
```bash
rails test test/system/responsive_design_test.rb
```

## Reporting Issues

When reporting mobile responsiveness issues, include:
- Device/browser and version
- Viewport size
- Screenshots if possible
- Steps to reproduce
- Expected vs actual behavior

## Regression Testing Checklist

Before each deployment, verify:
- [ ] Automated tests pass
- [ ] Manual spot checks on key pages
- [ ] No horizontal scrolling on mobile
- [ ] Touch targets meet minimum size requirements
- [ ] Forms are usable on mobile devices