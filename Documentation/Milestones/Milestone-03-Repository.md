# Milestone-03-Repository.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 03 – Repository Layer

**Status:** Ready for Implementation

**Priority:** Critical

---

# Goal

Implement the Repository Layer that connects the Domain to the Persistence layer while preserving Clean Architecture boundaries.

Repositories are responsible only for data access.

They must not contain business logic.

---

# Objectives

Implement a repository architecture that:

* Works with Domain models only.
* Hides SwiftData completely.
* Supports asynchronous operations.
* Uses dedicated mappers.
* Maintains immutable history.
* Follows the approved architecture.

---

# Scope

Implement the following repositories.

## FoodRepository

Responsibilities:

* Save Food
* Get Food by ID
* Get All Foods
* Search Foods
* Get Favorite Foods
* Get Foods by Category
* Update Food
* Archive Food
* Restore Food

Rules:

* Return Domain models only.
* Never expose SwiftData models.
* Support async/await.
* No permanent delete.

---

## MealRepository

Responsibilities:

* Save Meal
* Get Meal by ID
* Get All Meals
* Search Meals
* Get Favorite Meals
* Update Meal
* Archive Meal
* Restore Meal

Rules:

* Manage only Meal templates.
* Do not log meals.
* Do not calculate nutrition.
* Return Domain models only.

---

## DailyLogRepository

Responsibilities:

* Get Today's Log
* Get Log by Date
* Get Logs within a Date Range
* Save DailyLog
* Add LoggedFood
* Update LoggedFood
* Remove LoggedFood
* Add LoggedMeal
* Update LoggedMeal
* Remove LoggedMeal
* Update Water Intake
* Mark Day Complete
* Check if a DailyLog exists for a given date

Rules:

* Automatically create today's DailyLog if it does not exist.
* Maintain exactly one DailyLog per calendar day.
* Manage only DailyLog persistence.
* Return Domain models only.

---

# Repository Rules

Every repository must:

* Return Domain models.
* Hide persistence implementation.
* Use async/await.
* Throw RepositoryError on failure.
* Contain no business logic.
* Contain no UI logic.
* Contain no calculations.

Repositories are responsible only for persistence operations.

---

# Mapping Strategy

Repositories must never expose SwiftData entities.

Implement dedicated stateless mappers.

Required mappers:

* FoodMapper
* MealMapper
* DailyLogMapper

Responsibilities:

* Domain → Persistence
* Persistence → Domain

Rules:

* Stateless.
* No caching.
* No business logic.
* No persistence logic.

---

# Repository Error Handling

Implement a shared RepositoryError.

Initial cases:

* notFound
* alreadyExists
* persistenceFailure
* validationFailed
* unknown

Rules:

* Repositories throw errors.
* Do not silently fail.
* No retry logic.
* No print() debugging.

---

# Transactions

Repository operations affecting multiple related objects must be transactional.

Rule:

Either:

Everything succeeds

or

Nothing changes.

Partial persistence is not acceptable.

---

# Dependency Rules

Repositories:

* depend on Persistence.
* depend on Domain.

Repositories must NOT depend on:

* SwiftUI
* ViewModels
* UseCases
* HealthKit
* CloudKit

Repositories must never communicate directly with other repositories.

Future coordination belongs to the UseCase layer.

---

# Folder Structure

Implement the following structure.

```text
Infrastructure/
└── Persistence/
    ├── Entities/
    ├── Mappers/
    │   ├── FoodMapper.swift
    │   ├── MealMapper.swift
    │   └── DailyLogMapper.swift
    └── Repositories/

Features/
└── Nutrition/
    ├── Domain/
    ├── Data/
    │   └── Repositories/
    └── Presentation/
```

Adjust only if required by the existing project structure while preserving the architectural intent.

---

# Founder Edition Decisions

The following decisions are approved.

## One Repository Per Aggregate

Implement:

* FoodRepository
* MealRepository
* DailyLogRepository

Do not implement a combined NutritionRepository.

---

## Async/Await

All repository APIs must use async/await.

Even if current persistence is local.

---

## Domain Isolation

Repositories return only Domain models.

SwiftData remains completely hidden.

---

## Immutable History

Repositories must preserve the snapshot architecture established in Milestone 02.

Editing:

Food

↓

Affects future logs only.

Editing:

Meal

↓

Affects future logs only.

Historical logs must never change.

---

# Out of Scope

Do not implement:

* UseCases
* ViewModels
* SwiftUI Views
* Dashboard
* HealthKit
* CloudKit
* Analytics
* Goal calculations
* Nutrition calculations
* Search ranking algorithms
* Repository caching
* Sync engine

Those belong to future milestones.

---

# Verification

Before completion:

* Project builds successfully.
* Repository layer compiles.
* Architecture boundaries remain intact.
* No SwiftUI imports.
* No business logic introduced.
* No unnecessary warnings added.

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

Do not begin Milestone 04.

---

# Definition of Done

Milestone 03 is complete when:

* All repositories are implemented.
* Repository interfaces follow the approved architecture.
* Stateless mappers are implemented.
* RepositoryError exists.
* Transaction strategy is implemented where applicable.
* Project builds successfully.
* No future milestone work is implemented.

---

# Success Criteria

After Milestone 03:

* The Domain is fully connected to the Persistence layer through repositories.
* SwiftData remains isolated behind repository and mapper boundaries.
* Future UseCases can interact with repositories without knowing anything about persistence.
* The Repository Layer is production-ready and consistent with the project's Clean Architecture.

