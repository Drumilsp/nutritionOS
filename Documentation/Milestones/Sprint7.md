# Sprint 7 — Settings & Data

**Sprint:** 7 of 8
**Status:** Approved for Implementation
**Phase:** Implementation

---

# 1. Objective

Implement the Settings & Data module for Nutrition OS Founder Edition.

Sprint 7 gives users practical control over app preferences, nutrition goals, units, data export/reset, and app information while preserving the existing architecture and design system.

This sprint does not introduce account management, cloud sync, subscriptions, or a new persistence model.

---

# 2. References

Implementation must follow these documents in order:

1. Documentation/Architecture.md
2. Documentation/Design.md
3. Documentation/SampleDesign.html *(Visual Reference Only)*
4. Documentation/Sprint7.md

If conflicts occur:

Architecture.md
↓
Design.md
↓
Sprint7.md
↓
SampleDesign.html

---

# 3. Scope

## In Scope

### Settings Home

Provide a complete native Settings screen that organizes user-facing configuration and management areas.

Settings should include access to:

* Profile / Preferences
* Nutrition Goals
* Unit Settings
* Nutrition Display Preferences
* Manage Foods
* Manage Meals
* Data Export
* Reset Local Data
* About / App Info

---

### Goal Settings

Allow users to view and edit supported nutrition goals.

Supported goals:

* Calories
* Protein
* Carbohydrates
* Fat

Fiber goal must not be added unless it already exists in the app’s current `GoalSettings` model.

---

### Unit Settings

Allow users to manage supported unit preferences.

Supported unit areas:

* Weight units
* Height units, if already supported
* Serving quantity units, if already supported

Do not introduce unsupported unit systems.

---

### Nutrition Display Preferences

Allow users to manage simple nutrition display preferences only if they are supported by the existing app model.

Possible supported preferences:

* Default dashboard range
* Macro display visibility
* Summary display preference

Do not add complex personalization.

---

### Existing Management Links

Settings must continue to expose:

* Manage Foods
* Manage Meals

These should route to the existing Food and Meal Management screens implemented in earlier sprints.

---

### Data Management

Provide user-facing controls for:

* Export app data
* Reset local app data
* View basic data/privacy information

Reset actions must require confirmation.

---

### About / App Info

Display basic app information:

* App name
* App version
* Build number, if available
* Environment/debug information, if already supported
* Basic legal/privacy placeholder if already present

---

# 4. Out of Scope

Sprint 7 must not implement:

* Cloud sync
* Account login
* Account deletion
* Subscription management
* Payments
* Social features
* AI coaching settings
* Complex privacy dashboard
* Backup service
* Data import, unless already supported
* New persistence model, unless implementation is blocked and explicit approval is given
* New design system
* New navigation architecture

---

# 5. Functional Requirements

## Settings Home

Users shall be able to open Settings and navigate to supported settings sections.

The Settings Home should be organized using the existing design system and native iOS settings conventions.

Required sections:

* Nutrition
* Management
* Data
* App

---

## Nutrition Goals

Users shall be able to:

* View current goals
* Edit supported goals
* Save changes
* Cancel changes
* See validation errors for invalid goal values

Supported editable goals:

* Calories
* Protein
* Carbohydrates
* Fat

Fiber should be shown only as intake/analytics elsewhere unless a real fiber goal exists in the current domain model.

---

## Unit Settings

Users shall be able to view and edit supported unit preferences.

Do not add a unit preference unless the existing app model supports storing and applying it.

---

## Nutrition Display Preferences

Users may adjust simple supported display preferences.

Display preferences must not create inconsistent nutrition calculations.

---

## Manage Foods

Settings shall link to the existing Food Library flow.

Expected flow:

Settings
→ Manage Foods
→ Food Library

No new Food Management implementation should be created.

---

## Manage Meals

Settings shall link to the existing Meal Library flow.

Expected flow:

Settings
→ Manage Meals
→ Meal Library

No new Meal Management implementation should be created.

---

## Data Export

Users shall be able to export app data using existing data sources.

Export may include available local data such as:

* Foods
* Meals
* Logs
* Goals
* Body metrics
* Progress-related history

The exact export format should use the simplest maintainable format supported by the existing project.

Do not introduce cloud export.

---

## Reset Local Data

Users shall be able to reset local app data.

Reset must:

* Require explicit confirmation
* Clearly communicate destructive behavior
* Avoid accidental activation
* Use existing repository/use-case architecture

If selective reset is not already supported, implement a single full local reset rather than inventing a complex reset system.

---

## About / App Info

Users shall be able to view basic app metadata.

This screen is informational only.

---

# 6. Business Rules

## Existing Architecture

Settings must follow the existing architecture:

Repository
↓
UseCases
↓
SettingsViewModel
↓
SettingsScreenState
↓
SwiftUI

Presentation must not access repositories directly.

---

## Goals

Goal settings must reflect real stored goal fields.

Do not fabricate unsupported goals.

In particular:

* Do not add fiber goal progress unless `GoalSettings` supports it.
* Do not treat missing goals as zero goals.

---

## Data Export

Exported data should reflect existing stored data.

Do not generate artificial records.

Do not modify user data during export.

---

## Reset

Reset is destructive.

Reset must require confirmation.

After reset, the app should return to a safe default state.

---

## Preferences

Preferences should be stored only through existing supported mechanisms.

Do not create a new settings persistence model unless explicitly approved due to an implementation blocker.

---

# 7. Required Use Cases

Implementation shall provide or reuse use cases for:

* GetSettingsSummary
* GetGoalSettings
* UpdateGoalSettings
* GetUnitSettings
* UpdateUnitSettings
* GetDisplayPreferences
* UpdateDisplayPreferences
* ExportAppData
* ResetLocalData
* GetAppInfo

Reuse existing repositories, services, validators, and models whenever possible.

Do not duplicate business logic.

---

# 8. Navigation Integration

Reuse the existing navigation architecture.

Required flows:

Settings
→ Nutrition Goals

Settings
→ Unit Settings

Settings
→ Nutrition Display Preferences

Settings
→ Manage Foods
→ Food Library

Settings
→ Manage Meals
→ Meal Library

Settings
→ Data Export

Settings
→ Reset Local Data

Settings
→ About

Do not introduce a new navigation system.

---

# 9. Architecture Constraints

Implementation must preserve:

Repository
↓
UseCases
↓
SettingsViewModel
↓
SettingsScreenState
↓
SwiftUI

Requirements:

* No repository access from SwiftUI.
* No repository access from presentation views.
* Business logic belongs in UseCases.
* Existing dependency injection remains.
* Existing navigation remains.
* Existing repositories and services should be reused.
* No new persistence model unless explicitly approved.

---

# 10. Design Constraints

All Settings & Data screens shall follow:

* Documentation/Design.md
* Documentation/SampleDesign.html

Do not introduce:

* New visual language
* New colors
* New typography
* New spacing systems
* New interaction patterns

Settings should use native iOS settings/list patterns consistent with the existing app design.

---

# 11. Acceptance Criteria

Sprint 7 is complete when:

* Settings Home is implemented
* Nutrition Goals screen is implemented
* Unit Settings screen is implemented where supported
* Nutrition Display Preferences screen is implemented where supported
* Manage Foods link works
* Manage Meals link works
* Data Export works
* Reset Local Data works with confirmation
* About / App Info is implemented
* Existing architecture is preserved
* Existing design language is preserved
* Build succeeds
* No Settings presentation layer accesses repositories directly

---

# 12. Definition of Done

Sprint 7 is complete when:

* All functional requirements are implemented.
* Code follows Architecture.md.
* UI follows Design.md.
* Existing Food, Meal, Today, and Progress flows are not regressed.
* Build succeeds.
* Documentation is updated.
* Sprint is verified and approved.

---

# 13. Sprint Status

**Status:** Approved for Implementation

Implementation shall proceed using:

* Documentation/Architecture.md
* Documentation/Design.md
* Documentation/SampleDesign.html
* Documentation/Sprint7.md

No new product, design, persistence, or architectural decisions shall be introduced during implementation unless blocked by an issue requiring explicit clarification.

Sprint 7 will be frozen after implementation, verification, documentation, and approval.

