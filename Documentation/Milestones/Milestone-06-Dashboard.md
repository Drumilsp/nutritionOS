# Milestone-06-Dashboard.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 06 – Dashboard

**Status:** Ready for Implementation

**Priority:** Critical

---

# Goal

Implement the complete Dashboard feature.

The Dashboard is the application's home screen.

Its purpose is to answer one question immediately:

> **"How am I doing today, and what should I do next?"**

The Dashboard is **not** an analytics screen.

It focuses only on today's progress.

---

# Objectives

Implement:

* Dashboard data model
* Dashboard business logic
* Dashboard ViewModel
* Dashboard state management
* Dashboard widgets
* Dashboard refresh strategy

The Dashboard must remain fast, minimal and actionable.

---

# Dashboard Philosophy

The Dashboard is **Mission Control**.

Not a spreadsheet.

Not an analytics page.

Not a history screen.

The Dashboard displays today's status only.

Historical trends belong to the Progress feature.

---

# Information Hierarchy

Display information in this order:

1. Greeting
2. Today's Energy Hero Card
3. Protein
4. Carbohydrates & Fat
5. Water
6. Today's Meals
7. Quick Actions

Nothing else belongs on the Dashboard.

---

# Dashboard Data Model

Implement:

DashboardData

Contains:

* Greeting
* Current Date
* EnergySummary
* MacroSummary
* WaterSummary
* MealSummary
* QuickActions
* LastUpdated

DashboardData should be immutable.

Each refresh creates a completely new DashboardData instance.

Never partially update widgets.

---

# Energy Summary

Contains:

* Today's Target Calories
* Food Calories
* Maintenance Calories
* Remaining Calories
* Resting Calories
* Active Calories
* Energy Balance Target

All calculations occur before the Dashboard receives data.

No business calculations belong in SwiftUI.

---

# Macro Summary

Contains:

Protein

* Current
* Goal
* Remaining

Carbohydrates

* Current
* Goal
* Remaining

Fat

* Current
* Goal
* Remaining

Protein receives the strongest visual emphasis.

---

# Water Summary

Contains:

* Current Water
* Goal
* Remaining

Supports quick addition.

---

# Meal Summary

Contains:

Breakfast

Lunch

Dinner

Snack

Each meal displays:

* completion state
* calories (when logged)

No editing occurs directly on the Dashboard.

---

# Dashboard Widgets

Implement:

## Greeting

Example:

Good Morning, Drumil

---

## Energy Hero Card

Displays:

* Target Calories
* Food Calories
* Calories Burned
* Remaining Calories

Tap:

Open Today's Daily Log.

---

## Protein Card

Displays:

* Current Protein
* Goal
* Remaining

Tap:

Open nutrition details.

---

## Macro Card

Displays:

* Carbohydrates
* Fat

Tap:

Open nutrition details.

---

## Water Card

Displays:

* Current Water
* Goal
* Remaining

Supports:

+250 ml quick add.

Long press:

100 ml

250 ml

500 ml

750 ml

---

## Today's Meals

Displays:

Breakfast

Lunch

Dinner

Snack

Tap:

Open meal details.

---

## Quick Actions

Display:

* Add Food
* Add Meal
* Add Water

Designed for one-tap access.

---

## Goal Reminder

Conditionally displayed.

Examples:

Only 18 g protein remaining.

Goal reminders use deterministic rules.

No AI.

---

# Dashboard Interaction

Dashboard interactions:

Energy Card

↓

Today's Daily Log

Protein

↓

Nutrition Details

Macros

↓

Nutrition Details

Meals

↓

Meal Details

Water

↓

Quick Add

Quick Actions

↓

Relevant logging flow

The Dashboard never becomes a navigation hub.

---

# Dashboard ViewModel

Implement:

DashboardViewModel

Responsibilities:

* Load DashboardData
* Handle refresh
* Expose DashboardState
* Expose DashboardData
* Expose LastUpdated

Do NOT:

* calculate nutrition
* access repositories directly
* contain business logic

---

# Dashboard State

Implement:

DashboardState

Supports:

* Loading
* Loaded
* Empty
* Error

Avoid multiple Boolean flags.

---

# Dashboard Use Case

Implement:

GetDashboardDataUseCase

Responsibilities:

* Load DailyLog
* Load UserProfile
* Load GoalSettings
* Calculate summaries
* Build DashboardData

Return one fully prepared object.

No additional Dashboard Use Cases are required.

---

# Refresh Strategy

Dashboard refreshes when:

* Food logged
* Meal logged
* Food removed
* Meal removed
* Water updated
* Weight updated
* Goal updated
* HealthKit synchronization completes
* Pull to Refresh
* App enters foreground

Refresh always rebuilds DashboardData.

Never partially update widgets.

---

# Performance Strategy

Display cached DashboardData immediately.

Refresh silently in the background.

Target perceived load time:

Less than 200 milliseconds.

Heavy calculations belong inside GetDashboardDataUseCase.

SwiftUI only renders prepared data.

---

# Offline Strategy

Dashboard remains fully usable offline.

Display latest available DashboardData.

If refresh fails:

Display:

"Showing latest available data."

Never replace valid cached data with an empty screen.

---

# HealthKit

Dashboard does not communicate directly with HealthKit.

Dashboard only receives:

* Active Calories
* Last Updated

HealthKit remains an implementation detail.

---

# Dashboard Scope

The Dashboard intentionally does NOT contain:

* Progress graphs
* Weekly summaries
* Monthly summaries
* Weight history
* Analytics
* Food database
* Meal editor
* Settings
* AI features

These belong to future milestones.

---

# Founder Edition Decisions

Approved:

Dashboard = Today

Progress = Journey

Dashboard displays only actionable information.

Protein receives higher visual priority than other macros.

Energy Hero Card is always the primary widget.

Water supports one-tap logging.

Dashboard receives fully prepared DashboardData.

Business logic never exists inside SwiftUI.

---

# Folder Structure

Use the existing project structure.

```text
Features/
└── Dashboard/
    ├── Domain/
    ├── Data/
    ├── UseCases/
    └── Presentation/
```

Create folders only if they do not already exist.

---

# Out of Scope

Do not implement:

* Progress screen
* History
* Charts
* Analytics
* AI
* HealthKit integration
* Widgets
* Live Activities
* Apple Watch
* Notifications

Only prepare Dashboard architecture.

---

# Verification

Before completion:

* Project builds successfully.
* DashboardData compiles.
* DashboardViewModel compiles.
* DashboardState compiles.
* GetDashboardDataUseCase compiles.
* Architecture boundaries remain intact.
* No SwiftUI business logic.
* No direct repository access from ViewModel.

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

Milestone 06 is complete when:

* Dashboard architecture is implemented.
* DashboardData exists.
* DashboardViewModel exists.
* DashboardState exists.
* Dashboard widgets are represented by prepared data.
* GetDashboardDataUseCase exists.
* Refresh strategy is implemented.
* Project builds successfully.
* No future milestone work is introduced.

---

# Success Criteria

After Milestone 06:

Nutrition OS has a fast, production-ready Dashboard that serves as the user's daily mission control.

The Dashboard remains focused on today's progress, while future historical analytics belong exclusively to the Progress feature.

