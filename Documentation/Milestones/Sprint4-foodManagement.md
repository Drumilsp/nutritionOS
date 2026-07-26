# Sprint 4 — Food Management

**Status:** 🟢 Design Complete | ⏳ Implementation Pending

---

# Overview

Sprint 4 introduces complete Food Management for Nutrition OS Founder Edition.

This sprint defines how users browse, search, create, edit, organize, and manage foods while fully reusing the existing architecture established in previous sprints.

Sprint 4 is an **integration sprint**, not an architecture sprint.

No architectural changes are introduced.

---

# Objectives

Implement a complete Food Management experience that:

- Reuses the existing backend.
- Follows the Nutrition OS Design System.
- Integrates with Sprint 2 Navigation.
- Integrates with Sprint 3 Today & Quick Log.
- Maintains a single source of truth.
- Preserves architectural consistency.

---

# Deliverables

## D1 — Food Library Information Architecture

- Food Library
- Categories
- Favorites
- Archived Foods
- Search
- Filters
- Sorting

Status: ✅ Complete

---

## D2 — Food List & Search

- Search Bar
- Filter Bar
- Food List
- Food Row
- Empty State
- Loading State
- Error State

Status: ✅ Complete

---

## D3 — Food Details & Editor

- Food Details
- Food Editor
- Nutrition Information
- Serving Sizes
- Metadata
- Validation

Status: ✅ Complete

---

## D4 — Food CRUD & Management

Operations:

- Create Food
- Update Food
- Archive Food
- Restore Food
- Delete Food
- Duplicate Food
- Toggle Favorite

Status: ✅ Complete

---

## D5 — UI States & Interaction

Implemented UI behavior:

- Loading
- Empty
- Error
- Toasts
- Undo
- Swipe Actions
- Confirmation Dialogs

Status: ✅ Complete

---

## D6 — Integration & Acceptance Criteria

### Philosophy

The UI owns presentation only.

It must never:

- Perform nutrition calculations.
- Validate business rules independently.
- Access repositories directly.
- Modify persistence.

Business logic remains inside existing UseCases.

---

### Architecture

```
Repository
    ↓
UseCases
    ↓
FoodViewModel
    ↓
FoodLibraryScreenState
    ↓
SwiftUI Views
```

The UI renders state.

The ViewModel coordinates actions.

---

### Existing Backend

Reuse existing implementations:

- Get Foods
- Search Foods
- Create Food
- Update Food
- Archive Food
- Restore Food
- Delete Food
- Duplicate Food
- Toggle Favorite

No duplicate implementations.

---

### View Structure

```
ManageFoodsView

├── FoodSearchBar
├── FoodFilterBar
├── FoodListView
│   └── FoodRowView
├── EmptyFoodLibraryView
├── FoodDetailsView
├── FoodEditorView
└── ArchiveConfirmationView
```

Every section should be independently previewable.

---

### Navigation

Reuse Sprint 2 Navigation.

```
Settings
    ↓
Manage Foods
    ↓
Food Details
    ↓
Food Editor
```

Quick Log must reuse the exact same Food Editor.

There must be only one Food Editor implementation.

---

### Refresh Strategy

Automatically refresh after:

- Create
- Update
- Archive
- Restore
- Delete
- Duplicate
- Favorite

Search results update immediately.

---

### State Flow

```
FoodViewModel
    ↓
FoodLibraryScreenState
    ↓
Food List
    ↓
Food Details
    ↓
Food Editor
```

Child views never load their own data.

---

### Validation

Continue using existing validators.

SwiftUI displays validation only.

Validation logic must never be duplicated.

---

### System Foods

Respect backend permissions.

System Foods:

- Read Only
- Duplicate Allowed
- Favorite Allowed

User Foods:

- Full CRUD

No UI workarounds.

---

### Performance

Only load:

- Food Library
- Selected Food
- Search Results

Do not preload unrelated data.

---

### Accessibility

Verify:

- Search
- Filters
- Food Rows
- Food Editor
- Swipe Actions
- Toasts
- Undo

Support:

- VoiceOver
- Dynamic Type
- Light Mode
- Dark Mode

---

### Testing

Verify:

- Empty Library
- Large Library
- Search
- Favorites
- Archived Filter
- Create
- Update
- Archive
- Restore
- Delete
- Duplicate
- System Foods
- User Foods

No regression to Sprint 2 Navigation or Sprint 3 Quick Log.

---

# Acceptance Criteria

## Food Library

- ✅ Search
- ✅ Filters
- ✅ Food List
- ✅ Food Details

## CRUD

- ✅ Create
- ✅ Update
- ✅ Archive
- ✅ Restore
- ✅ Delete
- ✅ Duplicate
- ✅ Favorite

## UI

- ✅ Loading
- ✅ Empty
- ✅ Error
- ✅ Toasts
- ✅ Undo

## Architecture

- ✅ Existing ViewModels reused
- ✅ Existing UseCases reused
- ✅ Existing Validators reused
- ✅ Existing Navigation reused
- ✅ Existing Design System reused

## Quality

- ✅ Light Mode verified
- ✅ Dark Mode verified
- ✅ Dynamic Type verified
- ✅ VoiceOver verified
- ✅ Successful Build
- ✅ No Compiler Errors
- ✅ No Swift Concurrency Warnings

---

# Shared Food Editor

FoodEditor is a shared presentation feature.

```
          FoodEditor
          /        \
         /          \
Manage Foods     Quick Log
```

Both flows reuse:

- Same UI
- Same ViewModel
- Same Validation
- Same Save Logic

Only the completion behavior differs.

Manage Foods:

Return to Food Library.

Quick Log:

Automatically select the newly created food and continue logging.

---

# Out of Scope

Do not implement:

- Meal Management
- Progress
- Settings Features
- HealthKit UI
- Barcode Scanner
- AI Logging

---

# Sprint Status

**Sprint:** 4 — Food Management

**Product Design:** ✅ Frozen

**Architecture:** ✅ Frozen

**Backend Contract:** ✅ Frozen

**UI Specification:** ✅ Frozen

**Implementation:** ⏳ Pending

---

# Definition of Done

Sprint 4 is complete when:

- Food Library is fully implemented.
- Food Details are implemented.
- Food Editor is implemented.
- CRUD operations work correctly.
- Existing architecture is fully reused.
- Existing backend is fully reused.
- UI matches `Design.md`.
- `SampleDesign.html` is used as the visual reference.
- Accessibility requirements are satisfied.
- All acceptance criteria pass.
- Successful build with no regressions.

---

# Notes

Sprint 4 is officially **design complete**.

No further product, architecture, or UI changes should be introduced during implementation unless a critical bug or usability issue is discovered.

The implementation should strictly follow:

1. `Architecture.md`
2. `Design.md`
3. `SampleDesign.html` (visual reference only)
