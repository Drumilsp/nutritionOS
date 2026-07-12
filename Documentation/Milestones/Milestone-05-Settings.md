# Milestone-05-Settings.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 05 – Settings & User Profile

**Status:** Ready for Implementation

**Priority:** Critical

---

# Goal

Implement the complete Settings module for Nutrition OS.

This milestone establishes the application's configuration foundation by introducing:

* User Profile
* Goal Settings
* App Preferences
* Settings Repository
* Settings Use Cases
* HealthKit preparation
* App Configuration

This milestone becomes the single source of truth for all user configuration.

---

# Objectives

Implement:

* User profile management
* Nutrition goal management
* App preferences
* HealthKit configuration preparation
* Settings business logic

The implementation must follow Clean Architecture.

---

# Scope

Implement only the approved Settings architecture.

---

# Settings Models

Implement three separate Domain models.

## UserProfile

Represents the user.

Contains only identity information.

Fields:

* id
* optional name
* dateOfBirth
* biologicalSex
* height (stored internally in centimeters)
* currentWeight (stored internally in kilograms)
* targetWeight (stored internally in kilograms)
* createdAt
* updatedAt

Rules:

Do not include:

* nutrition goals
* preferences
* HealthKit permissions
* activity level
* app settings

---

## GoalSettings

Represents what the user wants to achieve.

Fields:

* Goal Type

  * Lose Fat
  * Maintain Weight
  * Build Muscle

* Energy Balance Target

  * deficit
  * maintain
  * surplus

* Goal Calculation Mode

  * Automatic
  * Manual

* Activity Level

  * Used only when HealthKit Active Calories are unavailable

* Daily Protein Goal

* Daily Carbohydrate Goal

* Daily Fat Goal

* Daily Water Goal

* Goal Calculation Version

Rules:

Nutrition OS calculates daily calorie targets from:

Today's Maintenance Calories

*

Energy Balance Target

The application should no longer think in terms of a fixed daily calorie goal.

---

## AppPreferences

Represents how the application behaves.

Fields:

* Weight Unit

* Height Unit

* Volume Unit

* Energy Unit

* Theme

  * System
  * Light
  * Dark

* Meal Reminder Enabled

* Water Reminder Enabled

* Daily Reminder Enabled

* Start Of Week

* Preferred Home Tab

* Last Used Meal Slot

* Haptics Enabled

* Has Completed Onboarding

Rules:

Internal storage always uses SI units.

Only the UI performs conversions.

---

# Settings Repository

Implement one repository.

SettingsRepository

Responsibilities:

* Load UserProfile

* Save UserProfile

* Load GoalSettings

* Save GoalSettings

* Load AppPreferences

* Save AppPreferences

Reason:

These models belong to the same feature and should be managed together.

Do not create separate repositories.

---

# HealthKit Strategy

HealthKit remains optional.

Nutrition OS must work perfectly without HealthKit.

Approved Founder Edition support:

Import:

* Weight
* Active Calories

Future:

* Steps
* Workouts
* Sleep

Future Export:

* Nutrition Data

Nutrition OS remains the source of truth.

HealthKit never replaces local persistence.

---

# Energy Balance Philosophy

Approved architecture:

Resting Calories

*

Active Calories

=

Today's Maintenance Calories

Today's Target Calories

=

Today's Maintenance Calories

*

Energy Balance Target

Examples:

Maintenance

2500 kcal

Deficit

-400 kcal

↓

Today's Target

2100 kcal

HealthKit Active Calories are preferred.

Manual Active Calories are the fallback.

---

# Settings Use Cases

Implement:

* GetUserProfileUseCase

* UpdateUserProfileUseCase

* GetGoalSettingsUseCase

* UpdateGoalSettingsUseCase

* RecalculateNutritionGoalsUseCase

* GetAppPreferencesUseCase

* UpdateAppPreferencesUseCase

* CompleteOnboardingUseCase

* ImportHealthKitProfileUseCase

Responsibilities:

* Coordinate SettingsRepository
* Validate settings
* Trigger nutrition recalculation when appropriate

Rules:

One Use Case = One Business Action

---

# Validation

Implement:

UserProfileValidator

GoalSettingsValidator

AppPreferencesValidator

Validation must return:

ValidationResult

Never Bool.

Support multiple ValidationErrors.

Normalize safe text input where appropriate.

---

# Goal Calculation

Automatic Mode:

Calculate today's target from:

Maintenance Calories

*

Energy Balance Target

Manual Mode:

Use user-defined nutrition targets.

When:

* weight changes
* activity level changes
* HealthKit state changes

the application should recommend recalculating nutrition goals.

Do not silently overwrite user settings.

---

# Units

Store internally:

Height

↓

Centimeters

Weight

↓

Kilograms

Volume

↓

Milliliters

Energy

↓

Kilocalories

Only presentation converts units.

---

# App Configuration

Implement AppConfiguration.

Contains:

* App Version
* Schema Version
* Database Version
* Edition
* Environment
* Feature Flags
* Default Values
* HealthKit Configuration
* Debug Logging

This is developer configuration.

Not user-editable.

---

# Folder Structure

```text
Features/
└── Settings/
    ├── Domain/
    ├── Data/
    ├── UseCases/
    └── Presentation/
```

Adjust only if required by the existing architecture.

---

# Founder Edition Decisions

Approved:

User identity, goals and preferences remain separate.

UserProfile

↓

GoalSettings

↓

AppPreferences

SettingsRepository owns all three.

HealthKit is optional.

Energy Balance replaces fixed calorie goals.

HealthKit Active Calories are preferred.

Manual Active Calories remain available.

Nutrition OS always owns nutrition data.

---

# Out of Scope

Do not implement:

* SwiftUI Views
* ViewModels
* Dashboard
* Food UI
* Meal UI
* Cloud Sync
* AI
* Notifications implementation
* HealthKit implementation
* Apple Watch
* Widgets

Only prepare the architecture.

---

# Verification

Before completion:

* Project builds successfully.
* Settings models compile.
* Repository compiles.
* Use Cases compile.
* Validators compile.
* Architecture boundaries remain intact.

One successful build is sufficient.

---

# Deliverables

Provide:

1. Summary
2. Files Created
3. Files Modified
4. Architecture Compliance
5. Assumptions Made
6. Questions for CTO Review
7. Build Result

Then stop.

Do not begin the next milestone.

---

# Definition of Done

Milestone 05 is complete when:

* UserProfile exists.
* GoalSettings exists.
* AppPreferences exists.
* SettingsRepository exists.
* All approved Settings Use Cases exist.
* Validation exists.
* AppConfiguration exists.
* Project builds successfully.
* No future milestone work is introduced.

---

# Success Criteria

After Milestone 05:

Nutrition OS has a complete user configuration system.

The application understands:

* who the user is,
* what the user wants to achieve,
* how the application should behave,

while remaining fully aligned with Clean Architecture and the Founder Edition philosophy.

