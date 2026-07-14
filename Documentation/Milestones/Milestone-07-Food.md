# Milestone-07-Food.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 07 – Food Management

**Status:** Ready for Implementation

**Priority:** Critical

---

# Goal

Implement the complete Food Management feature.

Foods are the foundation of Nutrition OS.

Every nutrition-related feature depends on reusable Food templates.

The Food feature should be simple, fast, scalable and completely reusable.

---

# Objectives

Implement:

* Food management
* Food search
* Food CRUD
* Categories
* Favorites
* Recently Used
* Food architecture
* ViewModels
* Search performance

---

# Food Philosophy

A Food is a reusable master template.

A Food is NOT:

* a meal
* a logged food
* a daily log
* a history record

One Food may be reused thousands of times.

Logged history remains immutable through LoggedFood snapshots.

---

# Food Ownership

Food is the single source of nutritional truth.

Relationship:

Food

↓

Meal Template

↓

Logged Meal

↓

Dashboard

↓

Progress

↓

AI

↓

Barcode

Food remains the canonical nutrition model.

---

# Food Types

Support:

## System Foods

Built into the application.

Properties:

* Read only
* Cannot edit
* Cannot delete
* Can favorite

---

## User Foods

Created by users.

Properties:

* Editable
* Duplicatable
* Archivable
* Deletable

---

## Future

Community Foods.

Not Founder Edition.

---

# Categories

Ship Founder Edition with:

* Meat & Poultry
* Seafood
* Eggs
* Dairy
* Grains & Cereals
* Bread & Bakery
* Vegetables
* Fruits
* Nuts & Seeds
* Legumes
* Snacks & Sweets
* Beverages
* Prepared Foods
* Condiments & Sauces
* Supplements
* Other

Each Food belongs to one primary category.

Categories are optional organizational tools.

Search remains primary.

---

# Category Rules

No custom categories.

Categories act as filters.

Category changes never affect:

* nutrition
* logged history
* meals

Hide empty categories during normal browsing.

---

# Search Philosophy

Search-first experience.

Searching should always be faster than browsing.

Keyboard automatically focuses.

---

# Default Search Screen

Before typing:

Display:

* Favorites
* Recently Used
* Browse Categories

Never show an empty screen.

---

# Search Behaviour

Support:

* Case insensitive search
* Partial matching
* Prefix matching

Search ranking:

1. Exact Match
2. Favorites
3. Recently Used
4. Prefix Matches
5. Partial Matches
6. Alphabetical

---

# Search Results

Display:

Food Name

Category

Calories

Protein

Enough information for quick identification.

---

# Empty Search

Display:

"No foods found."

Offer:

Create New Food

directly from search.

---

# Favorites

Users may:

* Favorite
* Unfavorite

directly from:

* Search
* Food Details

Favorites appear before all other results.

Unlimited favorites.

---

# Recently Used

Automatically maintained.

Display immediately after Favorites.

Limit:

25 foods.

Recently Used updates automatically whenever foods are logged.

---

# Food Lifecycle

Workflow:

Create

↓

Use

↓

Edit

↓

Favorite

↓

Archive

↓

Restore

↓

Delete

Deletion should be rare.

Archiving should be the normal workflow.

---

# Create Food

Entry points:

1. Search → Create New Food

2. Foods Screen → Add Food

Both use the same editor.

---

# Required Fields

Require only:

* Food Name
* Serving Quantity
* Serving Unit
* Nutrition Values

Everything else remains optional.

---

# Nutrition Entry

Nutrition is entered per serving.

Example:

Serving

100 g

Calories

Protein

Carbohydrates

Fat

The domain uses the canonical nutrient identifier:

`carbohydrates`

The UI may display:

"Carbs"

---

# Validation

Validate:

* Required name
* Positive serving quantity
* Valid serving unit
* Non-negative nutrition values

Reject invalid input before saving.

---

# Editing

Users may edit:

* Name
* Serving
* Nutrition
* Category
* Favorite
* Notes

Editing affects future usage only.

Historical logs remain unchanged.

---

# System Foods

System Foods are read only.

Users cannot edit them.

If modification is required:

Offer:

Duplicate

↓

Edit Copy

This preserves built-in data integrity.

---

# Duplicate

Support one-tap duplication.

Default name:

"<Food Name> Copy"

Useful for:

* Different brands
* Homemade variations
* Cooked vs Raw

---

# Archive

Archive instead of deleting.

Archived foods:

* remain in database
* disappear from normal search
* may be restored

---

# Delete

Allow permanent deletion only after confirmation.

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

* Archive
* Delete
* Favorite

---

# Architecture

Feature structure:

Features

└── Food

├── Domain

├── Data

├── UseCases

└── Presentation

Maintain Clean Architecture.

---

# ViewModels

Implement:

FoodListViewModel

Responsibilities:

* Search
* Categories
* Favorites
* Recently Used

---

FoodDetailViewModel

Responsibilities:

* Display Food
* Favorite
* Archive
* Duplicate
* Delete

---

FoodEditorViewModel

Responsibilities:

* Create
* Edit
* Validate
* Save

Each ViewModel has one responsibility.

---

# States

Implement:

FoodListState

* Loading
* Loaded
* Empty
* Error

FoodDetailState

* Loading
* Loaded
* Archived
* Deleted
* Error

FoodEditorState

* Editing
* Saving
* Saved
* ValidationError
* Error

Avoid Boolean flags.

---

# UseCases

Implement:

* GetFoodsUseCase
* SearchFoodsUseCase
* GetFoodDetailUseCase
* CreateFoodUseCase
* UpdateFoodUseCase
* ArchiveFoodUseCase
* RestoreFoodUseCase
* DeleteFoodUseCase
* FavoriteFoodUseCase
* DuplicateFoodUseCase

One responsibility per UseCase.

Use constructor dependency injection.

Depend only on repository protocols.

---

# Repository

Continue using the existing FoodRepository.

Searching belongs inside the repository.

Do not perform searching inside SwiftUI or ViewModels.

---

# Refresh

After any modification:

Repository

↓

Reload Food List

Do not manually mutate list items.

---

# Performance

Do not load the full database into SwiftUI.

Repositories perform searching and filtering.

Use lazy UI rendering.

Pagination is NOT required for Founder Edition.

Architecture should scale to thousands of foods.

---

# Future Compatibility

Architecture should support without redesign:

* Barcode Scanning
* AI Natural Language Logging
* Community Foods
* Restaurant Foods
* Import / Export
* Cloud Synchronization

All future sources produce the same canonical Food model.

---

# Out of Scope

Do NOT implement:

* Barcode scanning
* AI logging
* Community database
* Cloud sync
* Voice search
* Custom categories
* Tags
* Collections
* Food merge

These belong to future milestones.

---

# Testing

Add focused unit tests for:

* Food creation
* Search
* Validation
* Favorite
* Archive
* Duplicate
* Delete
* ViewModels

No UI tests.

---

# Build

Run one successful build.

Stop after a successful build.

---

# Safety Rules

Never:

* modify unrelated features
* redesign approved architecture
* implement future milestones
* bypass repositories
* place business logic inside SwiftUI

If architectural conflicts appear:

Stop.

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

Milestone 07 is complete when:

* Food Management is fully implemented.
* Search works.
* CRUD works.
* Favorites work.
* Recently Used works.
* Categories work.
* ViewModels follow approved architecture.
* UseCases follow approved architecture.
* Project builds successfully.

---

# Success Criteria

After Milestone 07:

Nutrition OS has a production-ready Food Management system that acts as the single source of nutritional truth for Meals, Daily Logs, Dashboard, Progress, and all future AI and barcode features while maintaining Clean Architecture and offline-first principles.

