# Sprint 5 — Meal Management

**Sprint:** 5 of 8  
**Status:** Approved for Implementation  
**Phase:** Implementation

---

# 1. Objective

Implement a complete Meal Management system that allows users to create, organize, maintain, and quickly log reusable meals while preserving the existing Nutrition OS architecture and design system.

This sprint introduces reusable meals as first-class entities without changing the application's architecture or visual language.

---

# 2. References

The following documents are the single source of truth and **must be read before implementation**.

1. Documentation/Architecture.md
2. Documentation/Design.md
3. Documentation/SampleDesign.html *(Visual Reference Only)*
4. Documentation/Sprint5.md

If any conflict exists:

Architecture.md
↓
Design.md
↓
Sprint5.md
↓
SampleDesign.html

---

# 3. Scope

## In Scope

### Meal Library

- Browse saved meals
- Search meals
- Filter meals
- Sort meals
- Favorite meals
- Archive meals
- Restore meals

### Meal Management

- Create meal
- Edit meal
- Duplicate meal
- Delete meal
- View meal details

### Meal Composition

- Add foods
- Remove foods
- Reorder foods
- Modify serving quantities
- Automatic nutrition recalculation

### Logging

- Log an entire meal from Quick Log
- Reuse existing logging flow

### Navigation

Settings
→ Manage Meals
→ Meal Library

Quick Log
→ Meals
→ Log Meal

---

## Out of Scope

- Meal planning calendar
- AI meal generation
- Smart recommendations
- Grocery lists
- Recipe instructions
- Cooking mode
- Meal photos
- Sharing
- Import / Export
- Nutrition coaching
- Cloud collaboration

---

# 4. Functional Requirements

## Meal Library

Users shall be able to:

- View all meals
- Search meals
- Favorite meals
- Archive meals
- Restore archived meals
- Duplicate meals
- Delete meals
- Open Meal Details
- Create new meals

---

## Meal Details

Display:

- Meal name
- Foods
- Serving quantities
- Total calories
- Total protein
- Total carbohydrates
- Total fat
- Fiber
- Meal notes (if available)

Provide actions:

- Edit
- Duplicate
- Favorite
- Archive
- Delete
- Log Meal

---

## Meal Editor

Support:

- Create
- Edit

Users can:

- Change meal name
- Add foods
- Remove foods
- Reorder foods
- Edit serving quantity
- Save
- Cancel

Validation must prevent invalid meals from being saved.

---

## Quick Log Integration

Users can:

Quick Log

↓

Meals

↓

Search Meal

↓

Select Meal

↓

Log Meal

The existing Quick Log architecture shall be reused.

---

## Settings Integration

Settings

↓

Manage Meals

↓

Meal Library

Existing navigation must be reused.

---

# 5. Business Rules

## Meal Definition

A meal is a reusable collection of foods with predefined serving quantities.

---

## Nutrition

Meal nutrition is calculated from the current foods contained within the meal.

Totals include:

- Calories
- Protein
- Carbohydrates
- Fat
- Fiber

---

## Historical Integrity

Editing a meal affects only future logs.

Historical logs remain unchanged.

Deleting a meal does not modify historical entries.

---

## Foods

Meals reference existing foods.

System foods remain read-only.

Archived foods follow existing Food Management rules.

---

## Validation

Meals must:

- Have a name
- Contain at least one food
- Have valid serving quantities

Invalid meals cannot be saved.

---

# 6. Search, Filters & Sorting

## Search

Search by:

- Meal name

---

## Filters

Support:

- All Meals
- Favorites
- Archived

---

## Sorting

Support:

- Name
- Recently Used
- Recently Updated
- Created Date

---

# 7. Required Use Cases

Implementation shall provide use cases for:

- GetMeals
- SearchMeals
- CreateMeal
- UpdateMeal
- DeleteMeal
- DuplicateMeal
- ArchiveMeal
- RestoreMeal
- FavoriteMeal
- LogMeal

Reuse existing repository implementations where applicable.

Do not duplicate business logic.

---

# 8. Architecture Constraints

Implementation shall reuse the existing architecture.

Repository

↓

UseCases

↓

MealViewModel

↓

MealLibraryScreenState

↓

SwiftUI

Requirements:

- No direct repository access from presentation.
- SwiftUI renders ScreenState only.
- Business logic belongs in UseCases.
- Existing dependency injection remains.
- Existing navigation remains.

No architectural redesign is permitted.

---

# 9. Design Constraints

All UI shall follow:

- Documentation/Design.md
- Documentation/SampleDesign.html

Do not introduce:

- New visual language
- New spacing rules
- New typography
- New colors
- New interaction patterns

Reuse existing Food Management patterns whenever appropriate.

---

# 10. Acceptance Criteria

Sprint 5 is complete when:

- Meal Library implemented
- Meal Details implemented
- Meal Editor implemented
- CRUD implemented
- Search implemented
- Filters implemented
- Sorting implemented
- Favorites implemented
- Archive / Restore implemented
- Quick Log integration implemented
- Settings integration implemented
- Existing architecture preserved
- Existing design language preserved
- Successful project build
- No presentation layer accesses repositories directly

---

# 11. Definition of Done

The sprint is complete when:

- Implementation satisfies all functional requirements.
- Code follows Architecture.md.
- UI follows Design.md.
- Build succeeds.
- Existing functionality is not regressed.
- Documentation is updated.
- Sprint is verified and approved.

---

# 12. Sprint Status

**Status:** Approved for Implementation

After approval, implementation shall proceed without introducing new product, design, or architectural decisions unless blocked by an issue requiring explicit clarification.

Sprint 5 becomes frozen after successful implementation, verification, and documentation.
