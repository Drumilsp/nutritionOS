# Nutrition OS — Founder Edition
# Backend Alignment — Today Screen
## Implementation Specification

**Status:** ✅ Approved  
**Phase:** Backend Alignment  
**Objective:** Align the existing backend contracts with the approved Today UI without changing the architecture.

---

# Overview

During Sprint 3 implementation several gaps were discovered between the approved UI and the existing backend.

This is **not** a new feature sprint.

This is **not** an architecture sprint.

This sprint only exposes missing functionality already implied by the approved Founder Edition design.

No UI redesign.

No navigation changes.

No Design System changes.

---

# Goal

Make the backend fully support the approved Today experience.

---

# Scope

## 1. Suggestions

Current limitation

- Suggestions are score ranked only.

Required

Expose suggestions grouped by

Foods

- Recently Used
- Frequently Used
- Favorites

Meals

- Recently Used
- Favorites

The UI should never perform grouping or ranking.

Business logic owns suggestion ordering.

---

## 2. Meal Logging

Current limitation

Meal logging only supports logging a meal directly.

Required

Support serving multiplier.

Examples

- 0.5×

- 1×

- 1.5×

- 2×

Multiplier must be handled inside the existing logging flow.

No UI calculations.

---

## 3. Water Logging

Current limitation

No presentation ViewModel exists.

Required

Expose

LogWaterViewModel

Reuse existing Water logging business logic.

Do not duplicate logic.

---

## 4. Timeline Editing

Current limitation

Logged entries cannot be edited through the presentation layer.

Required

Expose editing through existing architecture.

The Today screen must never manipulate repositories directly.

---

## 5. Timeline Deletion

Current limitation

Deletion is not exposed.

Required

Expose

Delete Logged Entry

through presentation.

Undo support should be possible.

---

## 6. Presentation Models

Ensure Today presentation models expose everything required by the UI.

Examples

- Serving multiplier
- Entry identifier
- Editable state
- Deletable state
- Source
- Last Updated

Presentation models should eliminate UI workarounds.

---

# Out of Scope

Do NOT implement

- New UI
- New navigation
- New Design System
- Progress
- Food Library
- Meal Library
- Settings
- HealthKit UI

No feature expansion.

---

# Architecture Rules

Maintain

Repository

↓

UseCases

↓

ViewModels

↓

Presentation Models

↓

SwiftUI

Views must never communicate directly with repositories.

---

# Acceptance Criteria

Complete when

✅ Suggestion grouping exposed

✅ Meal serving multiplier supported

✅ Water logging ViewModel available

✅ Timeline editing exposed

✅ Timeline deletion exposed

✅ Undo capability supported

✅ Presentation models complete

✅ Existing architecture preserved

✅ No duplicated business logic

✅ Build succeeds

✅ No new compiler errors

✅ No new Swift concurrency warnings

---

# Deliverables

Provide

1. Files created.
2. Files modified.
3. Summary.
4. Architectural decisions.
5. Build result.
6. Remaining TODOs.
7. Acceptance checklist.

---

# Definition of Done

Sprint 3 is considered complete when the existing Today UI can consume the backend without any workarounds or duplicated logic.
