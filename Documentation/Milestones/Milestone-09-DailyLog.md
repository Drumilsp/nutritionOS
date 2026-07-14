# Milestone-09-DailyLog.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 09 – Daily Logging

**Status:** Ready for Implementation

**Priority:** Critical

---

# Goal

Implement the complete Daily Logging system.

This milestone connects all previous work:

Food

↓

Meal

↓

Daily Log

↓

Dashboard

↓

Progress

Daily Logging becomes the central workflow of Nutrition OS.

---

# Objectives

Implement:

* Daily Logs
* Logged Foods
* Logged Meals
* Water Logging
* Daily Timeline
* Daily Totals
* Goal Progress
* Smart Suggestions
* Daily Notes
* Snapshot History
* ViewModels
* UseCases

---

# Daily Log Philosophy

A Daily Log represents one calendar day.

A Daily Log is NOT:

* Food
* Meal
* Template
* History Summary

It is the permanent historical record of everything consumed during a single day.

---

# Identity

Exactly one Daily Log exists for each calendar day.

Identity:

Date

Example:

2026-07-14

Changing Foods or Meals never changes the Daily Log identity.

---

# Daily Log Ownership

DailyLog owns:

* Logged Foods
* Logged Meals
* Water Entries
* Daily Notes
* Goal Snapshot

DailyLog does NOT own:

* Food
* Meal

Those remain reusable templates.

---

# Aggregate

DailyLog is the aggregate root.

Structure:

DailyLog

├── LoggedFoods

├── LoggedMeals

├── WaterEntries

├── DailyNotes

└── GoalSnapshot

Nothing inside DailyLog exists independently.

---

# Lazy Creation

Daily Logs should be created only when needed.

Workflow:

Open App

↓

Get Today's Daily Log

↓

Exists?

↓

Yes → Return

↓

No → Create → Return

No midnight scheduler.

No background jobs.

---

# Goal Snapshot

Capture today's goals when the Daily Log is created.

Snapshot:

* Calories Goal
* Protein Goal
* Carbohydrates Goal
* Fat Goal
* Water Goal

Future Settings changes must never modify previous Daily Logs.

---

# Logged Foods

LoggedFood stores immutable snapshots.

Store:

* Food ID
* Food Name
* Quantity
* Serving Unit
* Nutrition Snapshot
* Logged Time
* Meal Period (optional)
* Source

History must never depend on the live Food.

---

# Logged Meals

LoggedMeal stores immutable snapshots.

Store:

* Meal ID
* Meal Name
* Meal Snapshot
* Nutrition Snapshot
* Logged Time
* Meal Period (optional)
* Source

History must never depend on the live Meal template.

---

# Source

Support:

* Manual Food
* Meal Template

Architecture should already support future values:

* AI
* Barcode
* Import

No migration required later.

---

# Snapshot Rules

Snapshots must preserve:

* Name
* Nutrition
* Serving Information
* Quantities
* Timestamp

Editing Food or Meal later must never modify historical Daily Logs.

---

# Water Entries

Store:

* Amount
* Timestamp

Water appears in the timeline.

Dashboard calculates totals from entries.

Never store only a daily total.

---

# Daily Notes

Support optional Daily Notes.

Examples:

* Cheat Day
* Birthday Dinner
* Felt Sick
* Long Run
* Travel Day

Daily Notes belong to the day.

Not Foods.

Not Meals.

---

# Empty Daily Logs

Allowed.

An empty Daily Log still contains:

* Date
* Goal Snapshot

Future:

* HealthKit

---

# Timeline

The Daily Log is a chronological timeline.

Newest entries first.

Supported entries:

* LoggedFood
* LoggedMeal
* WaterEntry

---

# TimelineEntry

Use a presentation model.

TimelineEntry represents:

* LoggedFood
* LoggedMeal
* WaterEntry

Future compatible with:

* AI Entry
* Barcode Entry
* Supplement Entry

SwiftUI renders only TimelineEntry.

---

# Meal Period

Meal Period is optional.

Supported values:

* Breakfast
* Lunch
* Dinner
* Snack
* Other

Meal Period is used only for UI grouping.

The timestamp remains the primary source of truth.

---

# Timeline Display

Each timeline card displays:

Food:

* Name
* Quantity
* Calories
* Protein
* Carbohydrates
* Fat
* Time

Meal:

* Name
* Food Count
* Calories
* Protein
* Carbohydrates
* Fat
* Time

Water:

* Amount
* Time

Exact UI design will be finalized in later UI sessions.

---

# Timeline Actions

Support:

* Edit
* Duplicate
* Delete

Users may edit:

* Quantity
* Time
* Meal Period

Editing affects only the Daily Log snapshot.

Never Food.

Never Meal.

---

# Daily Log Screen

Layout:

Timeline

↓

Today's Totals

↓

Suggested Foods

↓

Suggested Meals

↓

Quick Actions

* Log Food
* Log Meal
* Add Water

No separate Remaining section.

Today's Totals already communicate progress toward goals.

---

# Today's Totals

Display:

Calories

Current / Goal

Protein

Current / Goal

Carbohydrates

Current / Goal

Fat

Current / Goal

Water

Current / Goal

Example:

Protein

145 / 180 g

---

# Smart Suggestions

Small suggestion section.

Show:

Suggested Foods

Top 3

Suggested Meals

Top 3

Suggestions are generated from remaining nutritional goals.

No AI required.

Future AI may improve suggestions.

---

# Logging Workflow

Food:

Search

↓

Select

↓

Quantity

↓

Save

Meal:

Search

↓

Select

↓

Save

Water:

Amount

↓

Save

Maximum simplicity.

---

# Validation

Require:

* Valid Daily Log
* Positive quantities
* Valid serving units
* Valid timestamps

Reuse the existing validation infrastructure.

---

# Architecture

Continue using:

Features

└── Nutrition

├── Domain

├── Data

├── UseCases

└── Presentation

```
└── DailyLog
```

No new top-level feature.

---

# ViewModels

Implement:

DailyLogViewModel

Responsibilities:

* Timeline
* Totals
* Suggestions
* Refresh

---

LoggedEntryViewModel

Responsibilities:

* Edit
* Duplicate
* Delete

---

LogFoodViewModel

Responsibilities:

* Search Food
* Quantity
* Save

---

LogMealViewModel

Responsibilities:

* Search Meal
* Save

One responsibility per ViewModel.

---

# States

Implement:

DailyLogState

* Loading
* Loaded
* Empty
* Error

LogFoodState

* Searching
* Editing
* Saving
* Saved
* ValidationError
* Error

LogMealState

* Searching
* Editing
* Saving
* Saved
* ValidationError
* Error

LoggedEntryState

* Viewing
* Editing
* Deleted
* Error

Avoid Boolean state flags.

---

# UseCases

Implement:

* GetDailyLogUseCase
* CreateDailyLogIfNeededUseCase
* LogFoodUseCase
* LogMealUseCase
* LogWaterUseCase
* UpdateLoggedEntryUseCase
* DeleteLoggedEntryUseCase
* DuplicateLoggedEntryUseCase
* UpdateDailyNotesUseCase
* GetSuggestionsUseCase

Each UseCase owns one responsibility.

Do not chain UseCases together.

---

# Repository

Extend the existing DailyLogRepository.

Responsibilities:

* Get Daily Log
* Create if Needed
* Save Entries
* Delete Entries
* Daily Totals
* Suggestions

Return Domain models only.

Never expose SwiftData entities.

---

# Performance

Daily totals are calculated.

Never persisted.

Timeline uses TimelineEntry.

Only today's Daily Log loads automatically.

Older days load on demand.

Use lazy SwiftUI rendering.

No pagination.

No virtualization.

No background jobs.

---

# Offline First

Daily Logging must work completely offline.

Everything required exists locally.

No internet dependency.

---

# Future Compatibility

Architecture already supports:

* AI Natural Logging
* Barcode Logging
* Voice Logging
* Smart Suggestions
* Meal Scaling
* Cloud Sync
* Widgets
* Apple Watch

No redesign should be required.

---

# Out of Scope

Do NOT implement:

* AI
* Barcode
* Voice Logging
* Meal Planning
* Future Logging
* Cloud Sync
* Pagination
* Timeline Virtualization
* Daily Insights
* Wearables
* Widgets

These belong to future milestones.

---

# Testing

Add focused unit tests covering:

* Daily Log creation
* Snapshot correctness
* Logged Food
* Logged Meal
* Water Entries
* Totals
* Suggestions
* Timeline ordering
* ViewModels
* Validation

No UI tests.

---

# Build

Run one successful project build.

Stop after the successful build.

---

# Safety Rules

Never:

* redesign approved architecture
* expose SwiftData entities
* duplicate nutrition values
* duplicate search logic
* modify unrelated milestones
* implement future milestones

If architectural conflicts appear:

STOP.

Report them.

---

# Deliverables

When implementation is complete provide:

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

Milestone 09 is complete when:

* Daily Logs work.
* Logged Foods work.
* Logged Meals work.
* Water Logging works.
* Immutable snapshots work.
* Timeline works.
* Daily Totals work.
* Suggestions work.
* Daily Notes work.
* ViewModels follow Clean Architecture.
* Project builds successfully.

---

# Success Criteria

After Milestone 09, Nutrition OS supports a complete offline daily nutrition workflow where users can log Foods, Meals, and Water, review their day through a chronological timeline, monitor progress toward nutritional goals, receive goal-aware suggestions, and preserve an immutable history—all while maintaining Clean Architecture and keeping Food as the single source of nutritional truth.

