# Nutrition OS – Founder Edition
# Sprint 1 — Design System
## Implementation Specification

**Status:** ✅ Approved  
**Sprint:** 1 – Design System  
**Objective:** Build the reusable UI foundation that every screen in Nutrition OS will use.

---

# Overview

Sprint 1 is **not** about building screens.

No Today screen.

No Progress screen.

No Food Management.

No Meal Management.

No Settings.

The objective is to create a reusable Design System that every future screen will use.

Think of this as building the UI foundation for the entire application.

---

# Sprint Goals

Implement:

- Design Tokens
- Reusable Components
- View Modifiers
- Formatters
- Haptic Manager
- SwiftUI Preview Catalog

Every future sprint must build on top of this Design System.

---

# Folder Structure

```text
Presentation/
└── DesignSystem/
    ├── Tokens/
    │   ├── AppColors.swift
    │   ├── AppSpacing.swift
    │   ├── AppTypography.swift
    │   ├── AppRadius.swift
    │   ├── AppShadow.swift
    │   ├── AppAnimation.swift
    │   └── AppIcons.swift
    │
    ├── Components/
    │   ├── AppCard.swift
    │   ├── PrimaryButton.swift
    │   ├── SecondaryButton.swift
    │   ├── DestructiveButton.swift
    │   ├── MetricRow.swift
    │   ├── MacroProgressBar.swift
    │   ├── StatusBadge.swift
    │   ├── EmptyStateView.swift
    │   ├── LoadingSkeleton.swift
    │   ├── FloatingActionButton.swift
    │   └── NutritionTextField.swift
    │
    ├── Modifiers/
    │   ├── CardStyle.swift
    │   ├── SectionStyle.swift
    │   ├── KeyboardAware.swift
    │   └── LoadingOverlay.swift
    │
    ├── Formatters/
    │   ├── NutritionFormatter.swift
    │   ├── WeightFormatter.swift
    │   ├── WaterFormatter.swift
    │   └── RelativeDateFormatter.swift
    │
    ├── Haptics/
    │   └── HapticManager.swift
    │
    └── Preview/
        └── DesignSystemPreview.swift
```

---

# Design Philosophy

The Design System must follow these principles.

- Function over Decoration.
- Native iOS experience.
- Calm interface.
- Data-first hierarchy.
- Accessibility by default.
- Offline-first.
- Consistency over creativity.
- Reuse before duplication.

---

# Color System

Use semantic colors only.

Primary Accent

- System Accent Color

Semantic Colors

- Accent → Primary interactions
- Green → Success
- Orange → Warning
- Red → Error / Destructive
- Gray → Secondary information

Macro Colors

- Calories → Primary text
- Protein → Blue
- Carbohydrates → Orange
- Fat → Yellow
- Water → Cyan

Rules

- Never use color only to communicate meaning.
- Use system background colors.
- Support both Dark and Light Mode.

---

# Typography

Use only SF Pro (System Font).

Supported styles

- LargeTitle
- Title2
- Headline
- Title3
- Body
- Subheadline
- Caption

Rules

- Dynamic Type supported.
- Left aligned.
- Values emphasized over units.
- Labels above form fields.
- No custom fonts.
- No custom font sizes unless absolutely necessary.

---

# Layout System

Spacing Scale

- 4
- 8
- 12
- 16
- 24
- 32

Standard Layout

Screen Padding

16 pt

Card Spacing

16 pt

Section Spacing

24 pt

Component Spacing

8 pt

Rules

- Respect Safe Areas.
- Use whitespace instead of dividers whenever possible.

---

# Components

Implement reusable components.

AppCard

Responsibilities

- Standard container
- Rounded corners
- Padding
- Optional header
- System background

---

PrimaryButton

Filled Accent Button

---

SecondaryButton

Tinted Accent Button

---

DestructiveButton

Red Button

---

MetricRow

Reusable metric row.

Examples

- Calories
- Protein
- Water
- Weight

---

MacroProgressBar

Displays

- Label
- Current
- Goal
- Progress

---

StatusBadge

Examples

- Connected
- Archived
- Favorite
- Needs Permission

---

EmptyStateView

Contains

- SF Symbol
- Title
- Description
- Optional Action

---

LoadingSkeleton

Reusable placeholder.

Must respect Reduce Motion.

---

FloatingActionButton

Only one use case.

Quick Log.

---

NutritionTextField

Reusable input component.

Supports

- Validation
- Keyboard Types
- Labels
- Error Message

---

# View Modifiers

Implement

CardStyle

SectionStyle

KeyboardAware

LoadingOverlay

Modifiers should encapsulate repeated styling.

---

# Formatters

Create presentation formatters.

NutritionFormatter

WeightFormatter

WaterFormatter

RelativeDateFormatter

Views must never manually build display strings.

---

# Animation

Centralize animations.

AppAnimation

Provide

- fast
- standard
- slow
- none

Rules

- Native transitions
- Minimal animations
- Respect Reduce Motion
- No decorative motion

---

# Haptics

Create

HapticManager

Provide

- success()
- warning()
- error()

Do not instantiate UIKit feedback generators throughout the app.

---

# Icons

Centralize SF Symbols.

AppIcons

Examples

- food
- meal
- water
- weight
- progress
- settings
- search
- favorite
- delete

Never hardcode SF Symbol names.

---

# SwiftUI Previews

Every reusable component must provide previews.

Preview requirements

- Light Mode
- Dark Mode
- Dynamic Type (Large)
- Disabled State (if applicable)

Create a Preview Catalog screen containing every reusable component.

---

# Accessibility

Every component must support

- Dynamic Type
- VoiceOver
- Reduce Motion
- Dark Mode
- Light Mode
- Minimum 44×44 touch targets

Accessibility is mandatory.

---

# Dependencies

Design System may only depend on

- SwiftUI
- Foundation

Do NOT import

- SwiftData
- HealthKit
- Domain
- Repository
- UseCases

The Design System must remain completely independent.

---

# Coding Standards

- Small reusable views.
- No duplicated styling.
- No business logic.
- No networking.
- No persistence.
- Use design tokens everywhere.
- Prefer composition over inheritance.

---

# Acceptance Criteria

Sprint 1 is complete when:

- ✅ DesignSystem folder created.
- ✅ Tokens implemented.
- ✅ Components implemented.
- ✅ Modifiers implemented.
- ✅ Formatters implemented.
- ✅ Haptic Manager implemented.
- ✅ Preview Catalog created.
- ✅ All reusable components have previews.
- ✅ Dark Mode verified.
- ✅ Light Mode verified.
- ✅ Dynamic Type verified.
- ✅ Accessibility verified.
- ✅ Project builds successfully.
- ✅ No compiler errors.
- ✅ No new Swift Concurrency warnings.

---

# Out of Scope

Do NOT build

- Today Screen
- Progress Screen
- Food Management UI
- Meal Management UI
- Settings UI
- HealthKit UI
- Navigation

Those belong to later sprints.

---

# Deliverable

A complete, reusable Design System that serves as the UI foundation for every screen in Nutrition OS Founder Edition.

This Design System will be used in Sprint 2 (Navigation) and all subsequent UI implementation sprints.
