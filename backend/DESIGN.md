# Design System: Healytics App
**Project ID:** N/A (local Flutter app theme spec for Stitch)

## 1. Visual Theme & Atmosphere
This design language should feel calm, clinical, and trustworthy without becoming cold. The overall mood is clean and breathable: bright white or near-white surfaces in light mode, deep low-glare charcoal in dark mode, and a tightly related family of medical blues to signal clarity, safety, and action.

The visual personality is not playful or ornamental. It leans on clarity, generous spacing, and consistent rounded geometry. Interaction feedback should be visible and polished, but never loud. The app should read like a modern care platform: reassuring, structured, and easy to scan under time pressure.

## 2. Color Palette & Roles
### Core brand blues
* **Clinical Anchor Blue** (`#1565C0` light, `#90CAF9` dark): The primary action color for main buttons, active states, focused controls, selected navigation, and high-importance highlights.
* **Supportive Care Blue** (`#90CAF9` light container, `#0D47A1` dark container): The softer companion to the primary tone, used for highlighted cards, selected chips, supportive panels, and surfaces that need emphasis without becoming loud.
* **Action Azure** (`#039BE5` light, `#81D4FA` dark): The brighter secondary accent for assistive actions, informational highlights, progress cues, and interactive secondary UI.
* **Mist Container Blue** (`#CBE6FF` light, `#004B73` dark): The restrained secondary container used behind supportive badges, filters, and grouped controls.
* **Ocean Signal Blue** (`#0277BD` light, `#E1F5FE` dark): A crisp tertiary accent for navigational emphasis, indicator states, and subtle visual separation inside the blue family.
* **Airwashed Blue** (`#BEDCFF` light, `#1A567D` dark): The tertiary container tone for gentle emphasis blocks, tags, and low-pressure callouts.

### Neutral surfaces
* **Sterile Canvas White** (`#FFFFFF`): Default light surface, card face, and scaffold tone. It keeps the interface crisp and medically clean.
* **Soft Clinical Background** (`#FDFDFD`): The light background behind grouped content, giving white cards just enough separation without visible heaviness.
* **Quiet Night Surface** (`#121212`): The base dark surface for dark mode. It should feel calm and premium, not pure black.
* **Deep Night Background** (`#101010`): The dark background tone used behind layered content so blue accents can glow gently without harsh contrast.

### Feedback colors
* **Clinical Alert Red** (`#B00020` light, `#CF6679` dark): Error, destructive states, and blocking validation.
* **Tinted Disabled State** (derived from active color family): Disabled controls should look softly washed with theme color, not flat gray. They remain clearly inactive while still belonging to the system.

## 3. Typography Rules
Typography should use a modern system sans-serif voice with Material 3 proportions. The tone is neutral, legible, and practical rather than expressive. Headings should feel confident but not oversized; body copy should remain easy to scan during booking, onboarding, and health-service browsing flows.

Use medium to semibold weight for section titles, cards, and actionable labels. Use regular weight for supporting text, explanations, and metadata. Letter spacing should stay mostly neutral. Avoid decorative, condensed, or editorial typography. The interface should prioritize clarity, speed, and reassurance over brand theatrics.

## 4. Component Stylings
* **Buttons:** Primary buttons should use the anchor blue fill with strong contrast text, clear hover and press feedback, and softly rounded corners. Secondary actions can shift into outlined or tonal treatments using the lighter blue containers. Destructive actions should only use alert red when the action is truly irreversible.
* **Cards and containers:** Cards should sit on bright neutral surfaces with whisper-soft elevation or fine dividers rather than heavy shadows. Corners should be gently to generously rounded: smaller controls can sit around `8px`, while larger cards and feature panels can expand into the `16px` to `24px` range.
* **Inputs and forms:** Inputs should be filled and outlined rather than underlined. Borders should remain explicit and calm, with clear focus states in the primary blue family. Form controls should feel structured, accessible, and easy to parse in multi-step onboarding or booking flows.
* **Tags, pills, and badges:** Use pill or near-pill geometry for filter chips, category markers, and lightweight status treatments. Prefer container blues and quiet neutrals over saturated fills unless the state is highly important.
* **Navigation:** Selection should be unmistakable. Navigation rail items should use an indicator treatment, not just icon recoloring, so active context remains visible at a glance.
* **Dividers and disabled states:** Dividers should be subtle and functional. Disabled states should be softly tinted by the theme rather than reduced to generic gray, preserving brand cohesion.

## 5. Layout Principles
The layout should be mobile-first and comfort-oriented. Favor breathable vertical rhythm, clear sectioning, and obvious grouping over dense dashboards. Default spacing should build from a compact but flexible scale: `4`, `8`, `12`, `16`, `20`, `24`, and `32` pixels. In practice, page padding should usually land around `16` to `24` pixels, major section spacing around `16` to `24` pixels, and card padding around `14` to `20` pixels.

Use stacked sections, wide tap targets, and strong alignment lines so health information, appointment details, and service metadata remain easy to scan. Keep content blocks visually distinct with spacing first, color second, and elevation last. The interface should feel steady and readable, with just enough softness in radius and surface treatment to avoid clinical sterility.
