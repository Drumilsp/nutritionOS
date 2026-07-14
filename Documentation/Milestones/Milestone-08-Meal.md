# Milestone-08-Meal.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 08 – Meal Management

**Status:** Ready for Implementation

**Priority:** Critical

---

# Goal

Implement the complete Meal Management feature.

Meals are reusable templates built from Foods.

Meals exist to reduce logging time while maintaining nutritional consistency.

Food remains the application's single source of nutritional truth.

---

# Objectives

Implement:

* Meal Management
* Meal Search
* Meal CRUD
* Meal Templates
* Favorites
* Recently Used
* Meal Notes
* ViewModels
* UseCases
* Meal Composition

---

# Meal Philosophy

A Meal is a reusable template.

A Meal is NOT:

* Food
* LoggedMeal
* DailyLog
* History

A Meal combines Foods into reusable templates.

One Meal may be logged thousands of times.

Historical logs remain immutable through snapshots.

---

# Meal Ownership

Meal owns:

* Meal metadata
* MealItems
* Display order
* Notes

Meal does NOT own nutrition.

Food remains the nutritional source.

Relationship:

Food

↓

Meal

↓

Daily Log

↓

Dashboard

↓

Progress

↓

AI

↓

Barcode

---

# Meal Types

Founder Edition supports:

## User Meals

* Editable
* Duplicatable
* Archivable
* Deletable

Future only:

* System Meals
* Community Meals
* Restaurant Meals
* AI Meals

---

# Meal Identity

Every Meal has a stable identifier.

Changing:

* Name
* Foods
* Quantities
* Notes

does not change the Meal identity.

---

# Meal Composition

Meals contain MealItems.

Each MealItem stores:

* Food Reference
* Quantity
* Serving Unit

MealItems never own nutrition.

Food owns nutrition.

---

# Nutrition Calculation

Meal nutrition is never persisted.

Always calculate:

Meal

↓

MealItems

↓

Foods

↓

Calculated Totals

Never duplicate nutrition values.

---

# Meal Items

Support:

* Add Food
* Remove Food
* Reorder Food
* Change Quantity

Display order must be preserved.

Duplicate foods are allowed.

Meals containing zero Foods are invalid.

No maximum number of MealItems.

---

# Meal Notes

Meals support optional notes.

Examples:

* Extra spicy
* Mom's recipe
* Use low-fat milk
* Leg day meal

Notes belong to the Meal template.

They are not part of Daily Logs.

---

# Search Philosophy

Search-first experience.

Searching should always be faster than browsing.

Keyboard auto-focuses.

---

# Search Behaviour

Support:

* Case insensitive
* Prefix matching
* Partial matching

Ranking:

1. Exact Match
2. Favorites
3. Recently Used
4. Prefix Match
5. Partial Match
6. Alphabetical

---

# Default Search Screen

Display:

* Favorite Meals
* Recently Used
* All Meals

Never show an empty screen.

---

# Meal Categories

Founder Edition intentionally has:

NO Meal Categories.

Meals are reusable templates.

Breakfast/Lunch/Dinner belongs to Daily Logs.

Not Meals.

---

# Meal Cards

Display:

* Meal Name
* Number of Foods
* Total Calories
* Favorite Status

Compact and easily identifiable.

---

# Empty Search

Display:

"No meals found."

Offer:

Create New Meal

---

# Favorites

Support:

* Favorite
* Unfavorite

Favorites appear before all other search results.

Unlimited favorites.

---

# Recently Used

Automatically updated whenever Meals are logged.

Persist:

lastUsedAt

Maximum:

20 Meals.

---

# Meal Lifecycle

Workflow:

Create

↓

Use

↓

Favorite

↓

Edit

↓

Archive

↓

Restore

↓

Delete

Deletion should remain rare.

Archiving should be the preferred workflow.

---

# Create Meal

Entry points:

1. Search → Create New Meal

2. Meals Screen → Add Meal

Both use the same Meal Editor.

---

# Required Fields

Require only:

* Meal Name
* At least one Food

Everything else remains optional.

---

# Meal Builder

Workflow:

Meal Name

↓

Add Food

↓

Select Food

↓

Choose Quantity

↓

Repeat

Reuse existing Food Search.

Never duplicate Food search functionality.

---

# Editing

Users may:

* Rename Meal
* Add Foods
* Remove Foods
* Reorder Foods
* Change Quantities
* Favorite
* Edit Notes

Editing affects future usage only.

Historical logs remain unchanged.

---

# Duplicate Meal

Support one-tap duplication.

Default name:

"<Meal Name> Copy"

Useful for:

* Bulking
* Cutting
* Meal variations

---

# Archive

Archive instead of deleting.

Archived Meals:

* remain stored
* disappear from normal search
* may be restored

---

# Delete

Require confirmation.

Recommended flow:

Delete

↓

Archive Instead?

↓

Permanent Delete

Delete should always require confirmation.

---

# Undo

Support Undo after:

* Favorite
* Archive
* Delete

---

# Architecture

Continue using the Nutrition bounded context.

Structure:

Features

└── Nutrition

├── Domain

├── Data

├── UseCases

└── Presentation

```
└── Meal
```

No new top-level Meal feature.

---

# ViewModels

Implement:

MealListViewModel

Responsibilities:

* Search
* Favorites
* Recently Used

---

MealDetailViewModel

Responsibilities:

* Display
* Favorite
* Archive
* Duplicate
* Delete

---

MealEditorViewModel

Responsibilities:

* Create
* Edit
* Add Food
* Remove Food
* Reorder
* Change Quantity
* Validate
* Save

Each ViewModel owns one responsibility.

---

# States

Implement:

MealListState

* Loading
* Loaded
* Empty
* Error

MealDetailState

* Loading
* Loaded
* Archived
* Deleted
* Error

MealEditorState

* Editing
* Saving
* Saved
* ValidationError
* Error

Avoid multiple Boolean flags.

---

# UseCases

Implement:

* GetMealsUseCase
* SearchMealsUseCase
* GetMealDetailUseCase
* CreateMealUseCase
* UpdateMealUseCase
* ArchiveMealUseCase
* RestoreMealUseCase
* DeleteMealUseCase
* FavoriteMealUseCase
* DuplicateMealUseCase

One responsibility per UseCase.

Do not allow UseCases to call each other.

---

# Repository

Continue extending MealRepository.

Repository owns:

* CRUD
* Search
* Favorites
* Recently Used

Return Domain models only.

Never expose SwiftData entities.

---

# Performance

Meal remains the aggregate root.

MealItems never exist independently.

Search belongs inside repositories.

Use lazy rendering.

Do not load unnecessary data.

Persist:

lastUsedAt

for Recently Used.

---

# Future Compatibility

Architecture should support without redesign:

* AI Meal Creation
* Barcode-created Foods
* Cloud Sync
* Meal Sharing
* Import / Export
* Meal Scaling

---

# Out of Scope

Do NOT implement:

* Meal Categories
* Meal Images
* Barcode
* AI
* Voice
* Community Meals
* Restaurant Meals
* Cloud Sync
* Pagination
* Meal Versioning
* Collections
* Smart Suggestions

These belong to future milestones.

---

# Testing

Add focused unit tests covering:

* Meal CRUD
* Search
* Validation
* Favorites
* Recently Used
* Archive
* Duplicate
* Meal calculations
* ViewModels

No UI tests.

---

# Build

Run one successful build.

Stop after the successful build.

---

# Safety Rules

Never:

* modify unrelated milestones
* redesign approved architecture
* duplicate Food search
* duplicate nutrition values
* expose SwiftData entities
* implement future milestones

If architectural conflicts appear:

STOP.

Report them.

---

# Deliverables

When complete provide:

1. Summary
2. Files Created
3. Files Modified
4. Architecture Compliance
5. Assumptions Made
6. Questions for CTO Review
7. Build Result

Then stop.

Wait for CTO review.

---

# Definition of Done

Milestone 08 is complete when:

* Meal CRUD works.
* Meal Search works.
* Favorites work.
* Recently Used works.
* Meal Notes work.
* Meal Builder works.
* Food references work correctly.
* Nutrition is calculated from Foods.
* ViewModels follow approved architecture.
* Project builds successfully.

---

# Success Criteria

After Milestone 08, Nutrition OS provides a production-ready reusable Meal Management system that allows users to build, maintain, and reuse meal templates efficiently while preserving Food as the single source of nutritional truth and maintaining Clean Architecture and offline-first principles.

