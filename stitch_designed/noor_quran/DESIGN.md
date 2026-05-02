---
name: Noor Quran
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1c1b1b'
  on-surface-variant: '#4e4639'
  inverse-surface: '#313030'
  inverse-on-surface: '#f3f0ef'
  outline: '#7f7667'
  outline-variant: '#d1c5b4'
  surface-tint: '#775a19'
  primary: '#775a19'
  on-primary: '#ffffff'
  primary-container: '#c5a059'
  on-primary-container: '#4e3700'
  inverse-primary: '#e9c176'
  secondary: '#3f6653'
  on-secondary: '#ffffff'
  secondary-container: '#beead1'
  on-secondary-container: '#436b58'
  tertiary: '#5e5e5c'
  on-tertiary: '#ffffff'
  tertiary-container: '#a6a5a2'
  on-tertiary-container: '#3b3b39'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdea5'
  primary-fixed-dim: '#e9c176'
  on-primary-fixed: '#261900'
  on-primary-fixed-variant: '#5d4201'
  secondary-fixed: '#c1ecd4'
  secondary-fixed-dim: '#a5d0b9'
  on-secondary-fixed: '#002114'
  on-secondary-fixed-variant: '#274e3d'
  tertiary-fixed: '#e4e2de'
  tertiary-fixed-dim: '#c8c6c3'
  on-tertiary-fixed: '#1b1c1a'
  on-tertiary-fixed-variant: '#474744'
  background: '#fcf9f8'
  on-background: '#1c1b1b'
  surface-variant: '#e5e2e1'
typography:
  quran-text-lg:
    fontFamily: Noto Serif
    fontSize: 40px
    fontWeight: '400'
    lineHeight: '1.8'
  quran-text-md:
    fontFamily: Noto Serif
    fontSize: 32px
    fontWeight: '400'
    lineHeight: '1.8'
  headline-display:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: '600'
    lineHeight: 38px
    letterSpacing: -0.02em
  headline-section:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 28px
  body-reading:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-ui:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-padding: 24px
  card-gap: 16px
  section-margin: 40px
  touch-target: 48px
---

## Brand & Style

The design system is centered on the concepts of "Noor" (Light) and "Sakinah" (Tranquility). It is crafted to facilitate a meditative and focused experience for the reader, removing all digital friction. The personality is deeply respectful, spiritual, and high-quality, avoiding the loud trends of modern apps in favor of a timeless, archival aesthetic.

The design style follows a **refined Minimalism**. It prioritizes vast amounts of whitespace (negative space) to symbolize clarity and peace. The visual language is intentional and quiet, using high-quality typography and subtle structural elements rather than decorative flourishes. The interface acts as a silent vessel for the sacred text, ensuring the user's focus remains entirely on the content.

## Colors

The color palette is divided into two distinct environments to accommodate different reading conditions while maintaining a spiritual essence.

- **Light Mode:** Uses a "Parchment" base (#FDFBF7). This is a warm, solid cream that reduces eye strain compared to pure white, mimicking the feel of high-quality traditional paper.
- **Dark Mode:** Employs "Midnight Charcoal" (#1A1A1A). This is a deep, solid neutral that provides a non-emissive background for nighttime recitation.
- **Accents:** 
    - **Respectful Gold (#C5A059):** Used sparingly for high-importance elements, verse markers, and active states. It conveys value and tradition.
    - **Forest Green (#1B4332):** Used for secondary actions or navigation elements, rooted in the traditional significance of the color in Islamic art.

All colors are solid; no gradients are permitted within the design system to maintain the minimalist and honest aesthetic.

## Typography

The typography system pairs the modern clarity of **Inter** with the timeless elegance of **Noto Serif** (serving as a high-quality proxy for Arabic script in UI documentation). 

- **Arabic Script:** Must use a high-quality Mushaf font with ample line height (1.8 or higher) to ensure diacritics (tashkeel) are perfectly legible and do not overlap.
- **UI Text:** **Inter** is used for all functional text. It provides a clean, neutral contrast to the intricate Arabic calligraphy.
- **Hierarchy:** Use weight and tracking rather than scale to create hierarchy. Labels should be small and uppercase with slight tracking to provide an "archival" feel.

## Layout & Spacing

This design system utilizes a **Fixed Margin Grid** with a fluid inner container.
- **Margins:** A generous 24px side margin on mobile creates a frame for the content, enhancing the feeling of a "page."
- **Rhythm:** An 8px linear scale is used for all spacing. Content sections are separated by large 40px gaps to prevent the UI from feeling cluttered.
- **Reading View:** In the Quran reading mode, the grid expands to provide a distraction-free experience, centering the text with increased horizontal padding (up to 32px) to focus the eye.

## Elevation & Depth

Hierarchy is established through **Tonal Layering** and **Subtle Shadows** rather than traditional elevation levels.

- **Surface Levels:** In light mode, the primary background is #FDFBF7. Surface containers (cards) use the same color but are defined by a very soft, diffused shadow (Blur: 12px, Y: 4px, Opacity: 4%). This creates a "resting" effect rather than a "floating" effect.
- **Outlines:** In dark mode, elevation is primarily conveyed through subtle 1px borders (#2A2A2A) instead of shadows, maintaining the deep charcoal aesthetic without introducing muddy grey glows.
- **Depth:** No glassmorphism or background blurs are used. The UI remains flat and grounded.

## Shapes

The shape language is "Softly Architectural." It avoids the playfulness of fully round "pill" shapes while moving away from the harshness of sharp corners.

- **Components:** Buttons and input fields use a consistent 8px radius.
- **Containers:** Cards and modal sheets use a 12px to 16px radius to create a gentle, welcoming enclosure for content.
- **Icons:** Use simple line icons with a 1.5pt or 2pt stroke weight. Icon ends should be rounded to match the component radius.

## Components

- **Buttons:** Flat and solid. The primary button uses the Gold accent with dark text or the Forest Green accent with cream text. No shadows are applied to buttons; they should feel integrated into the surface.
- **Cards:** Used for Surah listings or Juz selections. They feature the 12-16px radius and a subtle shadow. Content inside cards should be balanced with generous internal padding (20px).
- **Verse Markers:** Traditional geometric shapes (circles or octagons) rendered in the Gold accent color, containing the verse number in a clean sans-serif.
- **Search Bars:** Subtle, solid fills (a slightly darker cream in light mode, or a lighter charcoal in dark mode) with simple line icons for "Search" and "Clear."
- **Tab Bars:** Minimalist line-based navigation. Active states are indicated by the Gold accent color and a small 2px dot indicator below the icon, rather than a filled background.
- **Selection Chips:** Used for filtering (e.g., Makki/Madani). These should be outlined or solid neutral fills, avoiding bright colors.