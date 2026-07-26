# Nutrition OS — Design System
### Visual language, locked from the Today screen · v1.0

**Status:** Locked. This is the foundation for every screen in the app. New screens should reuse these tokens and components rather than inventing new ones. Any deviation should be a deliberate exception, not a default.

**Source concept:** Apple Health — native, calm, restrained, functional over decorative.

---

## 1. Design Principles

These are the filters every future screen gets checked against:

1. **Native over novel.** If iOS already has a convention for this, use it. Don't invent a control the system already provides.
2. **Color means something, or it isn't there.** Color is reserved for semantic meaning (protein, carbs, fat, water, positive/negative balance) — never for mood or decoration.
3. **One hero number per screen.** Every screen should have a single primary data point the eye lands on first. Everything else is supporting detail.
4. **Quiet chrome, loud data.** Cards, separators, and containers should be nearly invisible. The numbers and labels do the talking.
5. **No gamification.** No streaks, badges, confetti, or celebratory animation. Progress is reported, not rewarded.
6. **Dynamic Type and Dark Mode are not afterthoughts.** Every token below is defined for both appearances; text must scale without breaking layout.

---

## 2. Color Tokens

All colors are semantic tokens, not raw hex values, in the codebase. Light and dark values below are the resolved values for each appearance — implement as an iOS dynamic color (asset catalog color set or equivalent) so the system switches automatically with appearance.

| Token | Usage | Light | Dark |
|---|---|---|---|
| `bg.primary` | Screen background | `#F2F2F7` | `#000000` |
| `bg.card` | Card / grouped-list surface | `#FFFFFF` | `#1C1C1E` |
| `text.primary` | Primary text, hero numbers | `#1C1C1E` | `#FFFFFF` |
| `text.secondary` | Labels, timestamps, sub-text | `#8E8E93` | `#98989D` |
| `separator` | Hairline dividers inside cards/lists | `#E5E5EA` | `#38383A` |
| `accent.protein` | Protein data + icon badges | `#007AFF` | `#0A84FF` |
| `accent.carbs` | Carbs data + icon badges | `#FF9500` | `#FF9F0A` |
| `accent.fat` | Fat data + icon badges | `#AF52DE` | `#BF5AF2` |
| `accent.water` | Water data + icon badges | `#5AC8FA` | `#64D2FF` |
| `accent.positive` | Remaining calories, on-track balance | `#34C759` | `#30D158` |
| `accent.negative` | Over-goal / deficit warnings (reserved, not yet used on Today) | `#FF3B30` | `#FF453A` |
| `fab.surface` | Floating action button background | `rgba(255,255,255,0.82)` blurred | `rgba(28,28,30,0.82)` blurred |
| `fab.icon` | FAB "+" glyph | `#FF3B30` | `#FF453A` |

**Rules:**
- Never introduce a new accent color for a new nutrient or metric without adding it here first — the palette must stay closed and finite.
- Accent colors are for data (dots, bars, ring segments, icon badges) — never for button fills, backgrounds, or text that isn't reporting a value.
- Card surfaces never use shadows to separate from the background in dark mode — use the `bg.card` vs `bg.primary` contrast (elevation-by-fill), consistent with iOS's own dark mode convention.

---

## 3. Typography

System font only: **SF Pro** (Text/Display, resolved automatically by size). No custom or rounded fonts. All sizes support Dynamic Type scaling.

| Role | Size / Weight | Used for |
|---|---|---|
| Nav Large Title | 30–34pt / Bold (800) | Screen title ("Today") |
| Hero Number | 34pt / Bold (700), tabular figures | Primary metric (calories consumed) |
| Title / Card Heading | 17pt / Semibold (600) | Card headers, item titles |
| Body | 14–15pt / Medium–Semibold | Row labels, list item titles |
| Section Label | 12pt / Bold (700), uppercase, +0.06em tracking | Section headers ("Timeline," "Today's Totals") |
| Secondary / Caption | 12–13px / Medium (500), `text.secondary` | Timestamps, sub-labels, goal text |

**Rule:** Any numeral that represents a quantity (calories, grams, ml, %) uses tabular (monospaced) figure styling so values don't shift width as they update.

---

## 4. Spacing & Layout

- **Grid unit:** 4pt base, used in 8 / 12 / 16 / 20 / 24 increments.
- **Screen margin:** 16pt horizontal, matching Health's grouped-inset margin.
- **Card internal padding:** 16pt, with 12pt vertical rhythm between internal rows.
- **List row height:** ~54–58pt (icon + two lines of text), matching standard iOS table row sizing.
- **Section-to-section spacing:** 22pt above each section label, 8pt below it before content starts.
- **Card corner radius:** 14pt, consistently — never mix radii within the same screen.
- **Icon badge:** 30×30pt, 8pt corner radius.

---

## 5. Components

### Daily Summary Card
Single grouped-inset card. Contains, top to bottom: date (secondary style), hero number + goal (baseline-aligned), remaining-calories line (positive accent color), then a divider, then metric rows (protein, energy balance) using the standard row pattern: label with colored dot → linear progress bar → numeric value.

### Timeline
A single grouped list (not one card per entry). Each row: 30×30 icon badge (solid semantic color, white glyph) → title + subtitle (time · category) → right-aligned value. Hairline separators between rows, none before the first or after the last.

### Today's Totals
A 3-column grid of small cards (Calories, Protein, Carbs / Fat, Water span two rows of 3+2 or reflow to fit 5 items). Each card: small uppercase label, then a bold tabular-figure value. No icons here — this section is pure data density.

### Energy Distribution
One card containing a small ring (not a full Activity-style ring — a single thin 3pt-stroke multi-segment ring, ~74pt diameter) plus a legend list to its right (colored dot + label + percentage). Ring segments use the three macro accent colors only.

### Suggested Foods / Suggested Meals
Horizontally scrolling row of small chips (12pt radius), each with a name and a calorie value. No images, no colored backgrounds — chips use `bg.card` like everything else. These two sections are visually identical in style, differentiated only by their section label and content.

### Floating Action Button
52pt circle, translucent `fab.surface` with backdrop blur (not a solid fill), thin 0.5pt border, soft shadow. Glyph is a simple "+" in the reserved negative/action red. Deliberately understated — it should never compete visually with the data above it.

---

## 6. Icon Usage

- SF Symbols only, weight-matched to adjacent text (Regular by default).
- Icon badges (in Timeline) are the one place icons sit on a solid color fill — everywhere else, icons are line-only and tinted with `text.secondary` unless they represent a specific nutrient (in which case they take that nutrient's accent color).
- Never use icons decoratively — every icon must replace or reinforce a specific word (a water drop for water, not for anything else).

---

## 7. Motion & Interaction

- Standard iOS transitions only (push, sheet presentation, standard spring). No custom celebratory animation, no confetti, no bounce-on-success.
- Progress bars and ring segments may animate their fill on load (standard ease-out, ~0.3s) — this is the only permitted "flourish," and it must respect Reduce Motion (fall back to instant fill).
- Haptics: light impact on FAB tap and on logging confirmation only. No haptic feedback tied to hitting goals (that would edge toward gamification).

---

## 8. Accessibility

- All type respects Dynamic Type; verify layouts don't clip at the two largest accessibility sizes (cards should allow text to wrap, not truncate, where possible).
- Contrast: `text.secondary` on `bg.card` meets WCAG AA at both appearances (verify: `#8E8E93` on white ≈ 4.6:1; `#98989D` on `#1C1C1E` ≈ 4.5:1 — both pass for text ≥ 14pt).
- Every icon badge in the Timeline needs a VoiceOver label that states the category (e.g., "Breakfast" not "bowl icon").
- Reduce Motion: disable the load-in fill animation on progress bars/rings; show final state immediately.
- Reduce Transparency: the FAB's blurred translucent surface needs a solid fallback (`bg.card` at full opacity) when this setting is on.

---

## 9. Dark Mode Rules

- Dark mode is not an inverted palette — it's a separate, deliberately tuned token set (see Section 2). Semantic accent colors shift to their iOS "dark" system-color variants (slightly brighter/more saturated to maintain contrast on black), not the same hex value with the background inverted.
- Elevation in dark mode comes from the `bg.card` vs `bg.primary` fill contrast (`#1C1C1E` on `#000000`), never from shadows — shadows are invisible on black and should not be relied on.
- Both appearances must be designed and reviewed together for every new screen — never ship a screen tested only in light mode.

---

## 10. Do / Don't

**Do**
- Reuse the grouped-inset card pattern for any new summary-style content.
- Keep one accent color per data type, used consistently everywhere that type appears (protein is always blue, everywhere, forever).
- Let whitespace and hairlines do the separating; avoid nesting cards inside cards.

**Don't**
- Don't introduce gradients, glows, or drop-shadow "pop" on any element.
- Don't add a new color to celebrate a milestone (e.g., a gold ring for "goal hit"). Progress is reported, not rewarded.
- Don't reach for a custom font, a bespoke icon set, or a non-system control when a native equivalent exists.
- Don't let a single screen's information density force a new component — extend `Today's Totals`-style grids or `Timeline`-style lists rather than designing a one-off table.

---

## 11. Applying This to New Screens — Checklist

Before shipping any new screen, confirm:

- [ ] Uses only tokens from Section 2 (no ad hoc hex values in code)
- [ ] Uses only the type roles from Section 3
- [ ] Uses the 4pt grid and 14pt card radius from Section 4
- [ ] Reuses an existing component from Section 5 wherever the content matches, before designing a new one
- [ ] Has been checked in both Light and Dark mode
- [ ] Has been checked at the largest two Dynamic Type sizes
- [ ] Contains no gamified reward mechanics (badges, streak flames, confetti, sound stingers)
- [ ] Every icon is SF Symbols and every color is justified by data meaning, not decoration
