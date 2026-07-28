# Info Pioneer Funnel Style Guide

This style guide documents the visual system used in the latest **Info Pioneer modern interactive funnel**. It is a calm, blue-forward editorial funnel style with modern interactivity, scroll animation, and a responsive single-page conversion flow.

---

## 1. Design Direction

The funnel should feel:

- Modern
- Calm
- Editorial
- Trustworthy
- Practical
- Professional
- Minimal but interactive
- Conversion-focused without feeling pushy

The style combines a warm institutional layout with a primarily blue color system. It avoids a loud SaaS look while still feeling current, polished, and responsive.

### Design Keywords

```text
Blue editorial funnel, calm technology consulting style, soft blue-white background, deep navy text, restrained blue accents, large serif headings, clean sans-serif body copy, thin borders, spacious sections, modern scroll animation, interactive scorecard, responsive conversion layout.
```

---

## 2. Color Palette

The latest funnel uses a soft blue editorial palette.

| Role | Color Name | Hex / Value | Usage |
|---|---:|---:|---|
| Page Background | Soft Blue White | `#F3F7FB` | Main page background |
| Secondary Background | Pale Blue Gray | `#E7EEF7` | Value boxes, result panels, subtle sections |
| Card Background | Near White Blue | `#F9FBFE` | Lead card and offer cards |
| Text Primary | Deep Navy | `#0F172A` | Main headings, body emphasis |
| Text Secondary | Slate Blue Gray | `#526174` | Paragraphs, supporting copy |
| Border | Cool Blue Gray | `#C9D5E3` | Dividers, card borders, inputs |
| Primary Accent | Clear Blue | `#2563EB` | Primary buttons, labels, highlights |
| Accent Hover | Deep Blue | `#1D4ED8` | Button hover state |
| Secondary Accent | Sky Blue | `#0EA5E9` | Gradients, progress meter |
| Dark Section | Near Black Navy | `#0B1220` | Footer and final CTA section |
| Dark Muted Text | Pale Slate | `#B8C4D6` | Copy on dark backgrounds |
| Positive Fit | Deep Teal Blue | `#1D6F8F` | “Good fit” heading |
| Caution / Not Fit | Purple Accent | `#7C3AED` | “Not the right fit” heading |

### CSS Variables

```css
:root {
  --color-bg: #F3F7FB;
  --color-bg-soft: #E7EEF7;
  --color-card: #F9FBFE;
  --color-text: #0F172A;
  --color-muted: #526174;
  --color-border: #C9D5E3;
  --color-accent: #2563EB;
  --color-accent-hover: #1D4ED8;
  --color-accent-soft: rgba(37, 99, 235, 0.10);
  --color-accent-ring: rgba(37, 99, 235, 0.18);
  --color-sky: #0EA5E9;
  --color-dark: #0B1220;
  --color-dark-muted: #B8C4D6;
  --color-success: #1D6F8F;
  --color-alert: #7C3AED;
}
```

---

## 3. Typography

The funnel uses a strong editorial heading style paired with a clean sans-serif body font.

### Font Stack

```css
:root {
  --font-display: "Source Serif 4", Georgia, "Times New Roman", serif;
  --font-body: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}
```

### Typography Rules

| Element | Font | Style |
|---|---|---|
| Hero headline | Display serif | Very large, tight line-height, negative tracking |
| Section headings | Display serif | Large, calm, editorial |
| Card headings | Sans-serif | Bold, practical, readable |
| Body copy | Sans-serif | Clean and accessible |
| Labels | Sans-serif | Uppercase, small, blue accent |
| Buttons | Sans-serif | Bold, concise |

### CSS Type Scale

```css
body {
  font-family: var(--font-body);
  font-size: 17px;
  line-height: 1.58;
  color: var(--color-text);
}

h1,
h2 {
  font-family: var(--font-display);
  font-weight: 500;
  letter-spacing: -0.055em;
  color: var(--color-text);
}

h1 {
  font-size: clamp(54px, 8.6vw, 116px);
  line-height: 0.91;
  max-width: 1080px;
}

h2 {
  font-size: clamp(38px, 5.1vw, 76px);
  line-height: 0.96;
  max-width: 920px;
}

h3 {
  font-size: 22px;
  line-height: 1.2;
  letter-spacing: -0.025em;
  font-weight: 700;
}
```

---

## 4. Page Background

The page uses a soft blue-white background with subtle radial light effects.

```css
body {
  background:
    radial-gradient(circle at 6% 0%, rgba(37, 99, 235, 0.11), transparent 30rem),
    radial-gradient(circle at 100% 8%, rgba(14, 165, 233, 0.10), transparent 34rem),
    linear-gradient(180deg, #F3F7FB 0%, #EEF5FC 48%, #F3F7FB 100%);
}
```

### Background Guidance

Use:

- Soft blue tints
- Minimal gradients
- Large radial glows
- Low contrast backgrounds
- Thin borders instead of heavy surfaces

Avoid:

- Neon blues
- Heavy shadows everywhere
- Dark full-page backgrounds
- Overly glossy SaaS gradients

---

## 5. Layout System

### Max Width

```css
:root {
  --max: 1240px;
}
```

### Section Spacing

```css
section {
  max-width: var(--max);
  margin: 0 auto;
  padding: clamp(70px, 9vw, 130px) 24px;
}
```

### Hero Layout

The latest version top-aligns the hero copy and lead card so the tops are flush.

```css
.hero {
  min-height: calc(100vh - 74px);
  display: grid;
  grid-template-columns: 1.05fr 0.95fr;
  gap: clamp(36px, 6vw, 76px);
  align-items: start;
  padding-top: clamp(70px, 8vw, 130px);
  padding-bottom: clamp(70px, 8vw, 130px);
}

.hero > * {
  align-self: start;
}
```

---

## 6. Navigation

The navigation is sticky, translucent, and lightly blurred.

### Behavior

- Sticky at top
- Adds shadow when scrolled
- Thin border at bottom
- Mobile menu replaces desktop links under tablet width
- Scroll progress bar appears at top

### CSS

```css
.nav {
  position: sticky;
  top: 0;
  z-index: 50;
  background: rgba(243, 247, 251, 0.88);
  backdrop-filter: blur(18px);
  border-bottom: 1px solid rgba(201, 213, 227, 0.82);
  transition: box-shadow .25s ease, background .25s ease;
}

.nav.scrolled {
  background: rgba(243, 247, 251, 0.95);
  box-shadow: 0 12px 38px rgba(15, 23, 42, 0.08);
}
```

### Brand Mark

```css
.brand-mark {
  width: 38px;
  height: 38px;
  display: grid;
  place-items: center;
  border: 1px solid var(--color-text);
  border-radius: 999px;
  font-family: var(--font-display);
  font-weight: 700;
  font-size: 18px;
}
```

---

## 7. Buttons

Buttons are rounded, blue, and modern, with subtle hover lift and shine animation.

### Primary Button

```css
.btn-primary {
  background: var(--color-accent);
  color: #fff;
  border-color: var(--color-accent);
  box-shadow: 0 14px 34px rgba(37, 99, 235, 0.18);
}

.btn-primary:hover {
  background: var(--color-accent-hover);
  border-color: var(--color-accent-hover);
  box-shadow: 0 20px 46px rgba(37, 99, 235, 0.24);
}
```

### Secondary Button

```css
.btn-secondary {
  background: rgba(255,255,255,.44);
  color: var(--color-text);
  border-color: var(--color-border);
}

.btn-secondary:hover {
  border-color: var(--color-text);
  box-shadow: 0 14px 34px rgba(15, 23, 42, 0.08);
}
```

### Button Motion

```css
.btn:hover {
  transform: translateY(-2px);
}

.btn::before {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,.28), transparent);
  transform: translateX(-120%);
  transition: transform .55s var(--ease);
}

.btn:hover::before {
  transform: translateX(120%);
}
```

---

## 8. Lead Capture Card

The lead card is the main conversion surface.

### Visual Style

- Near-white card background
- Thin blue-gray border
- Soft shadow
- Subtle radial blue glow
- Slight hover lift
- Top aligned with hero text

```css
.lead-card {
  border: 1px solid var(--color-border);
  background: rgba(249, 251, 254, 0.84);
  padding: clamp(24px, 3vw, 36px);
  box-shadow: 0 24px 80px rgba(15, 23, 42, 0.10);
  position: relative;
  overflow: hidden;
  transition: transform .35s var(--ease), box-shadow .35s var(--ease);
}

.lead-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 32px 90px rgba(15, 23, 42, 0.16);
}
```

---

## 9. Forms

Forms are clean and square-edged, matching the editorial style.

```css
input,
select,
textarea {
  width: 100%;
  border: 1px solid var(--color-border);
  background: #FFFFFF;
  color: var(--color-text);
  border-radius: 0;
  padding: 14px 15px;
  font: inherit;
  outline: none;
  transition: border-color .18s ease, outline .18s ease, transform .18s ease, background .18s ease;
}

input:focus,
select:focus,
textarea:focus {
  border-color: var(--color-accent);
  outline: 2px solid var(--color-accent-ring);
}
```

### Form Layout

```css
.field-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

textarea {
  grid-column: 1 / -1;
  min-height: 104px;
}
```

---

## 10. Cards and Content Blocks

Cards are minimal. Structure comes from borders, spacing, and typography.

### General Card

```css
.card {
  border-top: 1px solid var(--color-border);
  padding: 28px 0 0;
  transition: transform .25s var(--ease), border-color .25s ease;
}

.card:hover {
  transform: translateY(-5px);
  border-color: rgba(37,99,235,.45);
}
```

### Icon Block

```css
.icon {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  border: 1px solid var(--color-border);
  margin-bottom: 18px;
  color: var(--color-accent);
  font-weight: 800;
  font-size: 15px;
}
```

---

## 11. Process Steps

The process section uses a bordered grid.

```css
.process {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 0;
  border-top: 1px solid var(--color-border);
  border-left: 1px solid var(--color-border);
  margin-top: 38px;
  counter-reset: process;
}

.step {
  counter-increment: process;
  min-height: 230px;
  padding: 26px;
  border-right: 1px solid var(--color-border);
  border-bottom: 1px solid var(--color-border);
  background: rgba(255, 255, 255, 0.42);
}
```

### Step Hover

```css
.step:hover {
  background: #fff;
  transform: translateY(-4px);
  box-shadow: 0 18px 44px rgba(15,23,42,.08);
}
```

---

## 12. Offer Section

The offer area uses two large cards: one for the main paid offer, one for the offer stack.

```css
.offer-section {
  display: grid;
  grid-template-columns: 0.98fr 1.02fr;
  gap: 24px;
  align-items: stretch;
}

.offer-box,
.offer-stack {
  border: 1px solid var(--color-border);
  background: rgba(249, 251, 254, 0.70);
  padding: clamp(26px, 4vw, 42px);
  box-shadow: 0 18px 54px rgba(15,23,42,.07);
}
```

### Price Styling

```css
.price {
  font-family: var(--font-display);
  font-size: clamp(46px, 6vw, 72px);
  line-height: 0.95;
  letter-spacing: -0.055em;
  color: var(--color-text);
  margin: 24px 0 12px;
}
```

---

## 13. Fit Section

The fit section uses side-by-side cards to qualify good-fit and poor-fit visitors.

```css
.fit-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  margin-top: 34px;
}

.fit-card {
  border: 1px solid var(--color-border);
  background: rgba(255, 255, 255, 0.52);
  padding: 28px;
}

.fit-card h3 {
  color: var(--color-success);
}

.fit-card.not h3 {
  color: var(--color-alert);
}
```

---

## 14. Final CTA Section

The final CTA is a dark navy section with a subtle blue radial highlight.

```css
.cta-band {
  background:
    radial-gradient(circle at top right, rgba(37,99,235,.18), transparent 25rem),
    var(--color-dark);
  color: #fff;
  display: grid;
  grid-template-columns: 1.06fr 0.94fr;
  gap: clamp(30px, 5vw, 68px);
  align-items: center;
  padding: clamp(34px, 6vw, 70px);
  box-shadow: 0 30px 90px rgba(15,23,42,.18);
}
```

---

## 15. Animation System

The funnel uses restrained modern motion.

### Motion Variables

```css
:root {
  --ease: cubic-bezier(.2,.8,.2,1);
}
```

### Scroll Reveal

Elements start slightly faded and lower, then animate in when visible.

```css
[data-animate] {
  opacity: 0;
  transform: translateY(26px);
  transition: opacity .75s var(--ease), transform .75s var(--ease);
  transition-delay: var(--delay, 0ms);
}

[data-animate].is-visible {
  opacity: 1;
  transform: translateY(0);
}
```

### Directional Animation Options

```css
[data-animate="fade-left"] {
  transform: translateX(-28px);
}

[data-animate="fade-right"] {
  transform: translateX(28px);
}

[data-animate="scale"] {
  transform: scale(.96);
}

[data-animate="fade-left"].is-visible,
[data-animate="fade-right"].is-visible,
[data-animate="scale"].is-visible {
  transform: translateX(0) scale(1);
}
```

### Intersection Observer

```js
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add("is-visible");
      observer.unobserve(entry.target);
    }
  });
}, {
  threshold: 0.14,
  rootMargin: "0px 0px -60px 0px"
});

document.querySelectorAll("[data-animate]").forEach((element) => observer.observe(element));
```

---

## 16. Interactive Elements

The latest funnel includes:

- Sticky navigation
- Scroll progress bar
- Mobile menu
- Scorecard modal
- Live score meter
- Result calculation
- Toast notifications
- Hover effects
- Scroll-triggered reveals

### Scroll Progress Bar

```css
.progress-bar {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 999;
  height: 3px;
  width: 0;
  background: linear-gradient(90deg, var(--color-accent), var(--color-sky));
}
```

### Toast

```css
.toast {
  position: fixed;
  right: 18px;
  bottom: 18px;
  max-width: 340px;
  padding: 14px 16px;
  background: var(--color-dark);
  color: #fff;
  border: 1px solid rgba(255,255,255,.12);
  box-shadow: 0 20px 60px rgba(15,23,42,.24);
  transform: translateY(20px);
  opacity: 0;
  pointer-events: none;
  transition: opacity .25s ease, transform .25s var(--ease);
  z-index: 120;
  font-size: 14px;
}

.toast.show {
  transform: translateY(0);
  opacity: 1;
}
```

---

## 17. Modal Style

The diagnostic modal uses the same editorial style as the main page.

```css
.modal {
  position: fixed;
  inset: 0;
  display: none;
  align-items: center;
  justify-content: center;
  padding: 22px;
  background: rgba(15, 23, 42, 0.68);
  backdrop-filter: blur(12px);
  z-index: 100;
}

.modal.active {
  display: flex;
}

.modal-card {
  width: min(760px, 100%);
  max-height: 92vh;
  overflow: auto;
  background: var(--color-bg);
  border: 1px solid var(--color-border);
  padding: clamp(24px, 4vw, 42px);
  position: relative;
  box-shadow: 0 30px 100px rgba(15, 23, 42, .28);
  animation: modalIn .28s var(--ease) both;
}
```

---

## 18. Responsive Rules

### Tablet

```css
@media (max-width: 980px) {
  .hero,
  .problem-strip,
  .offer-section,
  .cta-band {
    grid-template-columns: 1fr;
  }

  .grid-3,
  .fit-grid {
    grid-template-columns: 1fr 1fr;
  }

  .process {
    grid-template-columns: 1fr 1fr;
  }

  .nav-links,
  .nav-inner > .btn {
    display: none;
  }

  .menu-toggle,
  .mobile-menu {
    display: flex;
  }
}
```

### Mobile

```css
@media (max-width: 680px) {
  section {
    padding-left: 18px;
    padding-right: 18px;
  }

  h1 {
    font-size: clamp(48px, 15vw, 74px);
  }

  .grid-3,
  .fit-grid,
  .field-grid,
  .process {
    grid-template-columns: 1fr;
  }

  .btn,
  .hero-actions {
    width: 100%;
  }
}
```

---

## 19. Accessibility and Motion Safety

The funnel includes a reduced-motion safeguard.

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: .001ms !important;
    animation-iteration-count: 1 !important;
    scroll-behavior: auto !important;
    transition-duration: .001ms !important;
  }

  [data-animate] {
    opacity: 1;
    transform: none;
  }
}
```

### Accessibility Notes

Use:

- Visible focus states
- Semantic buttons for modal controls
- `aria-expanded` on mobile menu button
- `aria-hidden` on modal
- `aria-live` for toast status
- Descriptive form labels or `aria-label`
- Strong contrast between text and background

---

## 20. Content Tone

The funnel copy should sound:

- Practical
- Clear
- Calm
- Confident
- Diagnostic
- Helpful before persuasive

### Avoid

- Hype
- Overpromising
- Aggressive sales language
- Excessive jargon
- “Crush it” style copy
- Complex technical claims

### Preferred Language

Use phrases like:

```text
Find the friction.
Clarify the workflow.
Make the work easier to manage.
Turn scattered knowledge into usable systems.
Start with diagnosis before investing in the wrong solution.
A better workflow starts with clearer diagnosis.
```

---

## 21. AI Prompt for Recreating This Style

```text
Create a modern, responsive, blue editorial single-page funnel.

Use a soft blue-white background, deep navy text, muted slate body copy, thin cool-blue borders, and a restrained clear-blue accent for buttons, labels, progress bars, and interactive states. Use large serif display typography for hero and section headings, paired with a clean sans-serif for body text, forms, buttons, and navigation.

The page should feel calm, trustworthy, modern, and professional. It should be conversion-focused without feeling pushy. Use generous whitespace, top-aligned hero columns, thin border systems, subtle card shadows, restrained hover effects, scroll-triggered reveal animations, a sticky blurred navigation bar, a mobile menu, an interactive scorecard modal, a live progress meter, and a dark navy final CTA section.

Avoid neon colors, heavy gradients, glossy SaaS design, exaggerated claims, and overly rounded card styling.
```

---

## 22. Implementation Notes

The latest funnel version should preserve:

- Top-aligned hero text and lead card
- Blue editorial color scheme
- Sticky blurred navigation
- Scroll progress bar
- Scroll reveal animations
- Interactive scorecard modal
- Live score meter
- Responsive mobile menu
- Dark final CTA section
- Conversion path from free diagnostic to clarity call
