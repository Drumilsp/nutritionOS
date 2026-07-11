# Milestone-02-Domain.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 02 – Nutrition Domain

**Status:** Ready for Implementation

**Priority:** Critical

---

# Goal

Design and implement the complete Nutrition Domain for Founder Edition.

This milestone defines the core data model that every future feature depends upon.

After completion, the project will have a stable, scalable, and immutable domain model ready for repositories and business logic.

---

# Objectives

Implement all approved domain models.

The models must:

* compile successfully
* support immutable history
* support future expansion
* follow the approved architecture
* remain independent of business logic

---

# Scope

Implement the following domain models.

## Food

Represents a reusable food template.

Implement:

* id
* name
* category (optional)
* referenceQuantity
* referenceUnit
* nutritionProfile
* notes (optional)
* isFavorite
* isArchived
* createdAt
* updatedAt

Rules:

* One Food has exactly one reference serving.
* Foods are editable.
* Editing a Food affects future logs only.

Examples:

* Chicken Breast (100 g)
* Egg (1 Egg)
* Milk (100 ml)
* Chapati (1 Chapati)

Foods with different serving sizes (Small, Medium, Large) are represented as separate Food objects in Founder Edition.

---

## NutritionProfile

Represents the nutritional information of a Food.

Contains:

* NutrientValue[]

Do not use fixed nutrition properties inside NutritionProfile.

The design must support future nutrients without requiring architectural redesign.

---

## NutrientValue

Represents one nutrient.

Implement:

* id
* nutrientType
* value
* unit

Founder Edition UI will initially expose only:

* Calories
* Protein
* Fat
* Fibre

The model must support future nutrients.

---

## Meal

Represents a reusable meal template.

Implement:

* id
* name
* mealItems[]
* notes (optional)
* isFavorite
* isArchived
* createdAt
* updatedAt

Rules:

Meals contain references to Foods.

Meals do not contain nutrition snapshots.

Meals have no Breakfast/Lunch/Dinner category.

Meal timing belongs to DailyLog.

---

## MealItem

Represents one ingredient inside a Meal.

Implement:

* id
* foodReference
* quantity

Rules:

MealItem stores only:

* reference to Food
* multiplier of the Food's reference serving

Do not duplicate units.

Examples:

Food:

Chicken

Reference:

100 g

MealItem:

Quantity = 2

Means:

200 g

---

## LoggedFood

Represents one food actually consumed.

Implement:

* id
* foodName
* category
* referenceQuantity
* referenceUnit
* loggedQuantity
* nutritionProfileSnapshot
* mealSlot
* createdAt
* notes (optional)

Rules:

LoggedFood is immutable history.

Do not depend on current Food values.

Store snapshots.

Editing Food must never modify LoggedFood.

---

## LoggedMeal

Represents one meal actually consumed.

Implement:

* id
* mealName
* loggedFoods[]
* mealSlot
* createdAt
* notes (optional)

Rules:

LoggedMeal owns LoggedFood snapshots.

Editing a Meal must never modify LoggedMeal.

Users may edit today's LoggedMeal without affecting the original Meal template.

---

## DailyLog

Represents one calendar day.

Implement:

* id
* date
* loggedFoods[]
* loggedMeals[]
* waterIntake
* calorieGoalSnapshot
* proteinGoalSnapshot
* fatGoalSnapshot
* fibreGoalSnapshot
* maintenanceCaloriesSnapshot
* activeCalories (optional)
* restingCalories (optional)
* notes (optional)
* isCompleted
* createdAt
* updatedAt

Rules:

Exactly one DailyLog exists per calendar day.

DailyLog owns the day's logged data.

Historical goal values must remain immutable.

---

# Meal Slot

Implement an enum representing:

* Breakfast
* Lunch
* Dinner
* Snack

MealSlot belongs only to LoggedFood and LoggedMeal.

Meal templates must not store meal timing.

---

# Architecture Requirements

Follow:

* Architecture.md
* EngineeringStandards.md
* FounderEdition.md
* GitWorkflow.md
* CodexOnboarding.md

Use:

* Constructor Injection where applicable
* Clean Architecture
* Feature-Based Architecture

---

# Founder Edition Decisions

The following decisions are approved and must be respected.

## Reference Serving

Each Food has exactly one reference serving.

Examples:

* 100 g
* 100 ml
* 1 Egg
* 1 Chapati

Multiple serving profiles are intentionally deferred.

---

## Nutrition

Nutrition is stored using:

NutritionProfile

↓

NutrientValue[]

The UI exposes only Founder Edition nutrients.

The architecture supports future nutrients.

---

## Immutable History

Food

↓

LoggedFood (Snapshot)

Meal

↓

LoggedMeal (Snapshot)

History must never change after logging.

---

## Editing Rules

Editing Food

↓

Future logs only

Editing Meal

↓

Future logs only

Editing LoggedFood

↓

Current DailyLog only

Editing LoggedMeal

↓

Current DailyLog only

---

# Out of Scope

Do not implement:

* Repositories
* UseCases
* Dashboard
* HealthKit
* CloudKit
* Settings
* SwiftUI Views
* ViewModels
* Business calculations
* AI features
* Barcode scanning
* Online food database

Those belong to future milestones.

---

# Verification

Before completion:

* Project builds successfully.
* Models compile.
* Relationships compile.
* No architecture violations.
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

Do not begin Milestone 03.

---

# Definition of Done

Milestone 02 is complete when:

* All approved domain models are implemented.
* Relationships compile successfully.
* Snapshot architecture is respected.
* Immutable history is guaranteed.
* Project builds successfully.
* No future milestones are implemented.

---

# Success Criteria

After Milestone 02:

* The complete Nutrition Domain exists.
* Every future feature can build upon these models.
* The data model requires no architectural redesign for Founder Edition.
* Historical integrity is guaranteed by design.

