# Nutrition OS — Founder Edition
# Sprint 3 — Today Screen
## Implementation Specification

**Status:** ✅ Approved  
**Sprint:** 3 – Today Screen  
**Objective:** Replace the Today placeholder with the complete Founder Edition Today experience by integrating the existing backend, business logic, and Design System.

---

# Overview

Sprint 3 is the first feature implementation sprint.

No new architecture should be created.

No new business logic should be written.

Sprint 3 integrates the existing repositories, use cases, view models, and Design System into a complete Today experience.

---

# Sprint Goals

Implement

- Daily Summary
- Timeline
- Today's Totals
- Energy Distribution
- Suggested Foods
- Suggested Meals
- Quick Log
- Loading States
- Empty States
- Error States
- Toast Feedback

---

# Screen Structure

The Today screen should follow this order.

```text
Today

↓

Daily Summary Card

↓

Timeline

↓

Today's Totals

↓

Energy Distribution

↓

Suggested Foods

↓

Suggested Meals

↓

Bottom Safe Area
```

The Floating Action Button remains fixed above the safe area.

Everything else scrolls as a single page.

---

# Daily Summary

Purpose

Provide a glanceable overview of today's nutrition.

Display

- Date
- Calories Consumed / Goal
- Remaining Calories
- Protein Progress
- Energy Balance

Do NOT display

- Water
- Weight
- HealthKit Status

Requirements

- Informational only
- No tap action
- Uses existing Dashboard data
- Uses existing ViewModel
- Uses existing UseCases

---

# Timeline

Chronological order

Newest first

Supported entries

- Food
- Meal
- Water

Display

Food

- Name
- Quantity
- Calories
- Protein
- Carbs
- Fat

Meal

- Meal Name
- Food Count
- Calories
- Protein
- Carbs
- Fat

Water

- Amount

Actions

- Swipe Left → Delete
- Swipe Right → Edit
- Tap → Edit Sheet

No grouped meals.

No breakfast/lunch/dinner sections.

No weight entries.

---

# Today's Totals

Display

- Calories
- Protein
- Carbs
- Fat
- Water

Uses aggregated values from existing business logic.

No calculations inside SwiftUI.

---

# Energy Distribution

Add a dedicated subsection below Today's Totals.

Purpose

Show how today's calories are distributed between macronutrients.

Display

- Protein %
- Carbohydrates %
- Fat %

Formula

Protein Calories = Protein × 4

Carbohydrate Calories = Carbohydrates × 4

Fat Calories = Fat × 9

Percentage

Macro Calories / Total Calories

Requirements

- Uses existing nutrition totals
- No duplicated calculations
- Presentation only

---

# Suggested Foods

Display

Priority

1. Recently Used
2. Frequently Used
3. Favorites

Maximum

8 items

Selecting a food

↓

Quantity Sheet

↓

Log

↓

Refresh Today

---

# Suggested Meals

Display

Priority

1. Recently Used
2. Favorites

Maximum

5 items

Selecting a meal

↓

Serving Multiplier

↓

Log

↓

Refresh Today

---

# Quick Log

Opened from

Floating Action Button

Layout

Search

↓

Suggested Foods

↓

Suggested Meals

↓

New Food

↓

New Meal

Search

- Autofocus
- Instant filtering
- Foods first
- Meals second

New Food

↓

Editor

↓

Save

↓

Automatically selected

↓

Quantity

↓

Log

Same flow for Meals.

---

# Loading States

Every section supports

- Loading
- Content
- Empty
- Error

Use LoadingSkeleton.

Navigation and FAB remain interactive.

---

# Empty States

Daily Summary

Always visible

Timeline

Nothing logged today.

Today's Totals

Display zero values.

Energy Distribution

Display

0%

0%

0%

Suggestions

Provide

- New Food
- New Meal

---

# Error Handling

Display user-friendly errors.

Retry where appropriate.

No technical messages.

Validation

Inline only.

---

# Toasts

Use toast notifications.

Examples

- Food Logged
- Meal Logged
- Water Logged
- Entry Deleted
- Entry Updated

Undo supported after deletion.

---

# Architecture

Follow existing architecture.

Repository

↓

UseCases

↓

TodayViewModel

↓

TodayScreenState

↓

SwiftUI Views

Views must never communicate directly with repositories.

---

# View Structure

Create reusable views.

Recommended

TodayView

- DailySummaryCardView
- TimelineSectionView
- TodayTotalsSectionView
- EnergyDistributionView
- SuggestedFoodsSectionView
- SuggestedMealsSectionView
- QuickLogSheetView

Avoid large SwiftUI files.

---

# Existing UseCases

Reuse

- Get Dashboard Data
- Get Daily Log
- Log Food
- Log Meal
- Log Water
- Delete Entry
- Update Entry
- Suggested Foods
- Suggested Meals

No duplicate business logic.

---

# Existing Navigation

Reuse Sprint 2 navigation.

Use centralized routing only.

No local navigation implementation.

---

# Accessibility

Support

- Dynamic Type
- VoiceOver
- Dark Mode
- Light Mode
- Reduce Motion
- 44pt touch targets

---

# Dependencies

May depend on

- SwiftUI
- Foundation
- Design System
- Existing Presentation Layer
- Existing ViewModels

Do NOT introduce

- New repositories
- New UseCases
- SwiftData logic
- HealthKit logic

---

# Acceptance Criteria

Sprint complete when

✅ Daily Summary implemented

✅ Timeline implemented

✅ Today's Totals implemented

✅ Energy Distribution implemented

✅ Suggested Foods implemented

✅ Suggested Meals implemented

✅ Quick Log implemented

✅ Loading State

✅ Empty State

✅ Error State

✅ Toasts

✅ Undo Delete

✅ Existing UseCases reused

✅ Existing ViewModels reused

✅ Existing Navigation reused

✅ Design System used

✅ Successful build

✅ No compiler errors

✅ No new Swift concurrency warnings

---

# Out of Scope

Do NOT implement

- Progress
- Food Library
- Meal Library
- Settings
- HealthKit UI
- Barcode Scanner
- AI Logging
- Widgets

---

# Deliverables

Provide

1. Files created
2. Files modified
3. Summary
4. Architecture decisions
5. Build result
6. Remaining TODOs
7. Acceptance checklist

---

# Definition of Done

Sprint 3 is complete only when the Today tab is fully functional using the existing backend architecture without introducing any new business logic.
