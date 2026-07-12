# Milestone-04-UseCases.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 04 – Use Case Layer

**Status:** Ready for Implementation

**Priority:** Critical

---

# Goal

Implement the complete Use Case layer for Nutrition OS.

Use Cases contain the application's business logic and coordinate repositories while keeping the UI and persistence layers independent.

This milestone completes the business logic foundation of the application.

---

# Objectives

Implement Use Cases that:

* Coordinate repositories.
* Validate user input.
* Execute business workflows.
* Return Domain models.
* Contain no UI code.
* Contain no persistence code.

---

# Scope

Implement the approved Use Cases.

---

# Food Use Cases

Implement:

* CreateFoodUseCase
* UpdateFoodUseCase
* ArchiveFoodUseCase
* RestoreFoodUseCase
* SearchFoodsUseCase
* ToggleFavoriteFoodUseCase
* GetFavoriteFoodsUseCase

Responsibilities:

* Coordinate FoodRepository.
* Validate Food.
* Normalize safe user input.
* Return Domain models.

Rules:

* Do not access SwiftData directly.
* Do not communicate with ViewModels.
* Do not perform UI work.

---

# Meal Use Cases

Implement:

* CreateMealUseCase
* UpdateMealUseCase
* ArchiveMealUseCase
* RestoreMealUseCase
* DuplicateMealUseCase
* SearchMealsUseCase
* ToggleFavoriteMealUseCase
* GetFavoriteMealsUseCase
* GetRecentlyUsedMealsUseCase

Responsibilities:

* Coordinate MealRepository.
* Validate Meals.
* Preserve immutable history.
* Duplicate Meal templates.

Rules:

* Logging meals belongs to DailyLog Use Cases.

---

# DailyLog Use Cases

Implement:

* LogFoodUseCase
* QuickLogFoodUseCase
* LogMealUseCase
* RemoveLoggedFoodUseCase
* UpdateLoggedFoodUseCase
* RemoveLoggedMealUseCase
* UpdateLoggedMealUseCase
* UpdateWaterIntakeUseCase
* CompleteDayUseCase
* GetTodayLogUseCase
* GetHistoryUseCase
* GetDashboardSummaryUseCase
* CopyYesterdayUseCase

Responsibilities:

* Coordinate FoodRepository.
* Coordinate MealRepository.
* Coordinate DailyLogRepository.
* Create LoggedFood snapshots.
* Create LoggedMeal snapshots.
* Preserve immutable history.

Rules:

* Repositories must never communicate directly.
* Use Cases coordinate multiple repositories.

---

# Validation

Validation belongs entirely inside the Use Case layer.

Implement dedicated validators.

Required validators:

* FoodValidator
* MealValidator
* DailyLogValidator

Responsibilities:

* Validate input.
* Perform business validation.
* Normalize safe user input.

Examples:

* Trim whitespace.
* Remove duplicate spaces.
* Normalize capitalization where appropriate.

Validators must never silently modify business values such as calories, protein, or quantities.

---

# ValidationResult

Implement a reusable validation result.

ValidationResult represents:

* Success

or

* ValidationError[]

Do not use Bool for validation.

---

# ValidationError

Implement reusable validation errors.

Examples:

* emptyName
* invalidQuantity
* invalidNutrition
* duplicateFood
* mealHasNoItems

The list may expand in future milestones.

---

# Dependency Injection

All Use Cases must use constructor injection.

Dependencies must be provided externally.

Do not create repositories inside Use Cases.

Do not use singletons.

---

# Providers

Introduce injectable providers.

Implement:

* DateProvider
* UUIDProvider

Purpose:

* Improve testability.
* Remove direct dependencies on Date() and UUID().

Providers must be injected.

---

# Coordination Rules

Use Cases:

* may coordinate multiple repositories.
* may use validators.
* may use providers.

Use Cases must NOT:

* communicate with other Use Cases.
* access SwiftData directly.
* perform persistence.
* perform UI work.

---

# Search

Search behavior belongs to the Use Case layer.

Repositories provide data.

Use Cases perform:

* filtering
* normalization
* ranking
* future search enhancements

Repositories should not own search behavior.

---

# Dashboard

GetDashboardSummaryUseCase prepares dashboard-ready business data.

The Dashboard should receive prepared models.

Dashboard calculations must not occur inside SwiftUI.

---

# Repository Interaction

Use Cases communicate only through repository protocols.

Never through SwiftData.

Never through persistence entities.

Always return Domain models.

---

# Folder Structure

Implement the following structure.

```text
Features/
└── Nutrition/
    ├── Domain/
    ├── Data/
    ├── UseCases/
    │   ├── Food/
    │   ├── Meal/
    │   ├── DailyLog/
    │   ├── Validation/
    │   └── Providers/
    └── Presentation/
```

Adjust only if required by the existing project structure while preserving architectural intent.

---

# Founder Edition Decisions

The following decisions are approved.

## One Use Case = One Business Action

Each Use Case has exactly one responsibility.

Examples:

* CreateFood
* LogMeal
* UpdateWaterIntake

Avoid large "manager" classes.

---

## Validation

Validation belongs in Use Cases.

Repositories assume incoming data is already valid.

---

## Immutable History

Editing Food affects future logs only.

Editing Meal affects future logs only.

LoggedFood and LoggedMeal remain immutable snapshots.

---

## Constructor Injection

All dependencies are injected.

No global state.

No singleton repositories.

---

## Search

Search belongs to Use Cases.

Repositories only retrieve data.

---

# Out of Scope

Do not implement:

* ViewModels
* SwiftUI Views
* Dashboard UI
* HealthKit
* CloudKit
* Analytics
* Settings
* Notifications
* AI features
* Networking

Those belong to future milestones.

---

# Verification

Before completion:

* Project builds successfully.
* All Use Cases compile.
* Validators compile.
* Providers compile.
* Architecture boundaries remain intact.
* No SwiftUI imports.
* No direct SwiftData usage.
* No unnecessary warnings introduced.

One successful build is sufficient.

---

# Deliverables

Upon completion provide:

1. Summary
2. Files created
3. Files modified
4. Architecture compliance
5. Assumptions made
6. Questions for CTO review
7. Build result

Then stop.

Do not begin Milestone 05.

---

# Definition of Done

Milestone 04 is complete when:

* All approved Use Cases are implemented.
* Validators are implemented.
* Providers are implemented.
* Constructor injection is used throughout.
* Repositories remain isolated.
* Project builds successfully.
* No future milestone work is introduced.

---

# Success Criteria

After Milestone 04:

* The application has a complete business logic layer.
* Business rules are isolated from persistence and UI.
* Use Cases coordinate repositories cleanly.
* Validation is centralized.
* The project is ready for ViewModels and user-facing features.

