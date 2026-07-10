# FounderEdition.md

**Project:** Nutrition OS – Founder Edition

**Version:** 1.0

**Status:** Approved

**Last Updated:** July 2026

---

# Purpose

Founder Edition is the first production version of Nutrition OS.

Its goal is **not** to build the perfect nutrition application.

Its goal is to build a reliable, fast, maintainable foundation that the Founder uses every day.

Every feature included in Founder Edition must provide real value.

Everything else is intentionally postponed.

---

# Product Vision

Nutrition OS helps users understand and improve their nutrition through simple daily tracking.

Founder Edition focuses on:

* Accurate nutrition tracking
* Daily calorie management
* Protein and macro tracking
* Water tracking
* Historical logging
* HealthKit integration

The application is designed for long-term consistency rather than feature quantity.

---

# Product Principles

The Founder Edition follows five principles.

## 1. Simplicity First

If a feature makes the application more complicated than valuable, it should not be included.

Simple solutions are preferred over complex ones.

---

## 2. Offline First

The application must work without an internet connection.

All important functionality should remain available offline.

Cloud synchronization is a future enhancement, not a requirement.

---

## 3. Fast Daily Logging

Logging food should require as few interactions as possible.

The application should reduce friction, not increase it.

---

## 4. Data Integrity

Historical data must remain correct forever.

Editing a Food or Meal must never modify previous logs.

History is immutable.

---

## 5. Foundation Before Features

The architecture should be solid before advanced functionality is added.

A smaller, reliable application is preferred over a larger, unstable one.

---

# Founder Edition Scope

## Included

### Dashboard

* Daily summary
* Calories consumed
* Calories burned
* Estimated maintenance calories
* Remaining calories
* Protein progress
* Fat progress
* Fibre progress
* Water progress

---

### Nutrition

Manual Food management

* Create Food
* Edit Food
* Delete Food
* Search Foods

No online food database.

---

### Meals

Manual Meal management

* Create Meal
* Edit Meal
* Delete Meal
* Meals consist of existing Foods.

---

### Daily Logging

* Log Foods
* Log Meals
* Edit today's log
* Remove today's entries
* Historical logs remain immutable.

---

### Water Tracking

* Manual water logging
* Daily progress
* Goal tracking

---

### History

View previous days.

Historical values are snapshots.

Editing current Foods or Meals must never modify historical entries.

---

### Settings

User preferences

* Weight
* Height
* Age
* Gender
* Goal
* Deficit range
* Protein goal
* Fat goal
* Fibre goal
* Water goal

Future micronutrient goals should be supported without redesign.

---

### HealthKit

Read only:

* Height
* Weight
* Active Energy
* Resting Energy (when available)

HealthKit remains optional.

The application continues functioning if permissions are denied.

---

# Not Included

Founder Edition intentionally excludes:

* User accounts
* Authentication
* Social features
* Barcode scanning
* AI meal recognition
* Image recognition
* Online food databases
* Apple Watch app
* Widgets
* Live Activities
* Siri integration
* CloudKit synchronization
* Multi-device conflict resolution
* Subscription system
* Premium features
* Analytics platform
* Notifications (unless explicitly added later)

These are future milestones.

---

# Daily Workflow

Typical Founder usage:

1. Open Dashboard.
2. Review calorie and macro progress.
3. Log Foods or Meals.
4. Update water intake.
5. Close application.

The application should feel lightweight and fast.

---

# Nutrition Goals

Founder Edition initially tracks:

* Calories
* Protein
* Fat
* Fibre
* Water

The data model should allow future nutrients such as vitamins and minerals without major redesign.

---

# Maintenance Calories

Daily maintenance calories are calculated using:

* User profile
* HealthKit data (when available)
* Daily activity

HealthKit supplements calculations but is not required.

---

# Data Ownership

The Founder owns all Foods.

There is **no preloaded food database**.

Every Food is manually created.

Meals are built from existing Foods.

This ensures complete control over nutritional accuracy.

---

# History Model

Current data:

```text id="u0t1pk"
Food
Meal
```

Historical data:

```text id="lgj8om"
LoggedFood
LoggedMeal
DailyLog
```

Historical objects are snapshots.

They never change after logging.

---

# Performance Goals

Founder Edition should:

* Launch quickly.
* Scroll smoothly.
* Log foods rapidly.
* Minimize unnecessary calculations.
* Avoid blocking the main thread.

Correctness is more important than premature optimization.

---

# Design Philosophy

The interface should be:

* Clean
* Minimal
* Functional
* Native to iOS

Avoid unnecessary animations or visual complexity.

The application should feel like a professional Apple application.

---

# Future Vision

Founder Edition is the foundation for a larger ecosystem.

Possible future expansion:

* Athlete OS
* Running
* Recovery
* Sleep
* Training
* Biometrics
* Advanced nutrition analytics

These future ideas must never complicate Founder Edition unless the flexibility comes at almost no additional cost.

---

# Success Criteria

Founder Edition is successful when:

* Daily nutrition logging is fast.
* Dashboard is accurate.
* Historical data is trustworthy.
* HealthKit integrates reliably.
* The application is stable.
* The Founder enjoys using it every day.

Feature count is **not** a measure of success.

User experience and reliability are.

---

# Out of Scope Rule

When implementing new functionality, always ask:

> "Does this directly improve the Founder Edition experience today?"

If the answer is **no**, the feature should be deferred to a future milestone.

---

# Source of Truth

This document defines the product scope for Nutrition OS Founder Edition.

Every implementation decision should support this vision and remain within the approved scope unless the Founder explicitly expands it.

