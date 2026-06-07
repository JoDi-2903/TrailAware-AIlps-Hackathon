---
name: Alpine Modernism
colors:
  surface: '#f9faf6'
  surface-dim: '#dadad7'
  surface-bright: '#f9faf6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f1'
  surface-container: '#eeeeeb'
  surface-container-high: '#e8e8e5'
  surface-container-highest: '#e2e3e0'
  on-surface: '#1a1c1a'
  on-surface-variant: '#414844'
  inverse-surface: '#2f312f'
  inverse-on-surface: '#f0f1ee'
  outline: '#717973'
  outline-variant: '#c1c8c2'
  surface-tint: '#3f6653'
  primary: '#012d1d'
  on-primary: '#ffffff'
  primary-container: '#1b4332'
  on-primary-container: '#86af99'
  inverse-primary: '#a5d0b9'
  secondary: '#386471'
  on-secondary: '#ffffff'
  secondary-container: '#bceaf9'
  on-secondary-container: '#3f6b78'
  tertiary: '#212536'
  on-tertiary: '#ffffff'
  tertiary-container: '#373b4c'
  on-tertiary-container: '#a2a5ba'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c1ecd4'
  primary-fixed-dim: '#a5d0b9'
  on-primary-fixed: '#002114'
  on-primary-fixed-variant: '#274e3d'
  secondary-fixed: '#bceaf9'
  secondary-fixed-dim: '#a1cedc'
  on-secondary-fixed: '#001f27'
  on-secondary-fixed-variant: '#1e4c59'
  tertiary-fixed: '#dee1f8'
  tertiary-fixed-dim: '#c2c5db'
  on-tertiary-fixed: '#171b2b'
  on-tertiary-fixed-variant: '#424658'
  background: '#f9faf6'
  on-background: '#1a1c1a'
  surface-variant: '#e2e3e0'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 34px
    fontWeight: '700'
    lineHeight: 41px
    letterSpacing: 0.37px
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: 0px
  headline-md-mobile:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 25px
  body-lg:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 22px
    letterSpacing: -0.41px
  body-sm:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.06em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  margin-mobile: 16px
  margin-desktop: 32px
  gutter: 16px
  stack-sm: 4px
  stack-md: 12px
  stack-lg: 24px
---

## Brand & Style
The brand personality is authoritative yet serene, designed for high-end trekking and mountain safety. The target audience includes experienced mountaineers and luxury alpine travelers who value precision and reliability. 

The design style is **Corporate / Modern** with strong **Glassmorphism** influences. It takes cues from Apple’s Human Interface Guidelines, emphasizing clarity, high-quality typography, and depth. The emotional response should be one of "calm confidence"—the UI feels as sturdy as the mountains but as light as the alpine air. We utilize backdrop blurs to maintain context and generous whitespace to ensure that critical safety information is never obscured by visual clutter.

## Colors
The palette is rooted in the natural tones of the high altitudes. **Deep Alpine Green** serves as the primary brand anchor, used for headers and primary actions. **Glacial Blue** is used for secondary interactive elements and illustrative backgrounds. **Slate Grey** provides the foundation for typography and structural icons.

Priority states are clearly delineated:
- **High Priority:** A vibrant Orange-to-Red gradient, reserved for critical weather alerts and emergency notifications.
- **Medium Priority:** A warm amber for cautionary trail updates.
- **Low Priority:** A soft forest green for general info and completed milestones.
- **Overlays:** Use semi-transparent white (0.7 opacity) with a background blur (20px-30px) to create the glassmorphic effect.

## Typography
While SF Pro is the native target, this design system utilizes **Inter** as the systematic equivalent for cross-platform alignment and web-based previews, mirroring the clean, sans-serif neo-grotesque aesthetic. 

Typography follows a strict hierarchy. Display sizes use bold weights to anchor the page, while body text adheres to iOS standard 17pt sizing for optimal readability in outdoor lighting conditions. Labels use uppercase tracking to distinguish metadata from actionable content. For mobile views, large headlines scale down to prevent awkward line breaks on narrow devices.

## Layout & Spacing
The layout model is a **Fluid Grid** based on an 8px spacing rhythm. On iOS, we utilize a standard 4-column grid for portrait views and an 8-column grid for landscape/iPad.

- **Safe Areas:** Adhere strictly to the iOS notch and home indicator safe areas.
- **Margins:** 16px is the minimum horizontal margin for mobile; 32px for larger tablet views.
- **Rhythm:** Vertical stacks should use 12px for related items (e.g., a card title and its description) and 24px to separate distinct sections.
- **Grouping:** Use generous 40px+ padding between major functional blocks to maintain the "airy" alpine feel.

## Elevation & Depth
Depth is created through **Glassmorphism** and **Ambient Shadows** rather than solid color fills.

1.  **Base Layer:** The solid #F8F9FA surface.
2.  **Mid Layer (Cards):** Soft, high-diffusion shadows (0px 4px 20px rgba(0,0,0,0.05)) on white backgrounds to create a subtle lift.
3.  **Top Layer (Overlays/Navigation):** Glassmorphic surfaces using `UIBlurEffectStyleSystemUltraThinMaterial`. These should include a 1px inner stroke in white at 40% opacity to simulate the edge of glass.
4.  **Floating Action Elements:** High-priority buttons use a more pronounced shadow (0px 8px 24px rgba(27, 67, 50, 0.15)) to invite interaction.

## Shapes
We adopt a **Rounded** (0.5rem / 8px) base language. This provides a professional yet approachable feel. 

- **Primary Buttons:** Use `rounded-lg` (16px) to appear more inviting and modern.
- **Cards & Modals:** Use `rounded-xl` (24px) for large surface areas to match the squircle aesthetic of iOS home screen widgets.
- **Input Fields:** 8px corner radius to maintain a structural, precise look.
- **Status Pills:** Always use the pill-shape (fully rounded) for status indicators to distinguish them from actionable buttons.

## Components
- **Buttons:** Primary buttons use Deep Alpine Green with white text. High-priority alerts use the Orange-Red gradient. Secondary buttons use Glacial Blue with Deep Green text.
- **Chips/Pills:** Used for trail tags (e.g., "Hard", "Steep"). Use a Slate Grey stroke with no fill, or a Glacial Blue tint fill.
- **Lists:** iOS-style "grouped" lists with 16px horizontal padding. Separators should be 0.5px Slate Grey at 10% opacity.
- **Cards:** White or Glassmorphic backgrounds. Cards should have a 1px border (`glass_stroke_hex`) when placed over images or complex backgrounds.
- **Icons:** Use thin-stroke (Light or Regular weight) SF Symbols. Icons should be monochrome Slate Grey or Deep Alpine Green.
- **Inputs:** Clean, bottom-border or subtle gray fill. On focus, the border transitions to Deep Alpine Green.
- **Specialty Components:** 
    - **Topographical Map Widget:** Large corner radius, floating "Recenter" button with glass background.
    - **Alert Banner:** Full-width glassmorphic header that uses the priority gradient as a top-border accent (3px).