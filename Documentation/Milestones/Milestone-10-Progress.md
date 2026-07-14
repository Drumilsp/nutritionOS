# Milestone-10-Progress.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 10 – Progress & Analytics

**Status:** Ready for Implementation

**Priority:** High

---

# Goal

Implement the complete Progress & Analytics system.

This milestone transforms historical nutrition data into meaningful trends and insights.

Progress completes the feedback loop:

Food

↓

Meal

↓

Daily Log

↓

Dashboard

↓

Progress

---

# Objectives

Implement:

* Progress Overview
* Historical Trends
* Weekly Summaries
* Monthly Summaries
* Weight Tracking
* Goal Adherence
* Charts
* Consistency Score
* Today's Impact
* Weekly Net Energy Balance
* Estimated Fat Loss
* History Navigation
* ViewModels
* UseCases

---

# Progress Philosophy

Progress answers:

"How have I been doing over time?"

Dashboard answers:

"How am I doing today?"

Progress is analytical.

Dashboard is operational.

---

# Ownership

Progress owns:

* Historical summaries
* Trends
* Analytics
* Charts
* Goal adherence
* Weight history
* Consistency Score

Progress does NOT own:

* Food
* Meal
* DailyLog
* Goals

It reads existing data only.

---

# Read Only

Progress never edits:

* Foods
* Meals
* Daily Logs

Editing belongs to Daily Logging.

Progress is read-only.

---

# Source of Truth

Progress reads:

DailyLogs

↓

Goal Snapshots

↓

Weight History

Dashboard is never used as a source.

DailyLog remains historical truth.

---

# Time Ranges

Founder Edition supports:

* 7 Days
* 30 Days
* 90 Days
* All Time

Default:

7 Days

No custom date range.

---

# Metrics

Track:

* Calories
* Protein
* Carbohydrates
* Fat
* Water

Body Metric:

* Weight

Future compatible with:

* Body Fat %
* Muscle Mass
* Waist
* Progress Photos

---

# Goal Adherence

Every nutrition metric displays:

* Average
* Goal
* Goal Hit Rate

Example:

Protein

165 g/day

Goal

180 g/day

Goal Hit

6 / 7 Days

Always compare using Goal Snapshots stored inside DailyLogs.

Never today's goals.

---

# Weekly Summary

Display:

* Average Calories
* Average Protein
* Average Carbohydrates
* Average Fat
* Average Water
* Weight Change
* Weekly Net Energy Balance
* Estimated Fat Loss

Weekly Net Energy Balance is a total.

Other nutrition metrics remain averages.

---

# Monthly Summary

Display:

* Monthly averages
* Goal adherence
* Weight trend
* Best day
* Lowest day

No AI commentary.

---

# Weekly Net Energy Balance

Calculate:

Calories Consumed

*

Calories Burned

=

Weekly Net Energy Balance

HealthKit later improves activity estimates.

Current implementation remains offline.

---

# Estimated Fat Loss

Display:

≈ Estimated Fat Loss

Derived from:

7700 kcal

≈

1 kg body fat

Always display as an estimate.

Never present as exact.

---

# Consistency Score

Implement a deterministic Consistency Score.

Score:

0–100

Based on:

* Goal adherence
* Logging consistency
* Protein consistency
* Water consistency

No AI.

No gamification.

---

# Today's Impact

Display:

Today's contribution toward:

* Weekly averages
* Weekly Net Energy Balance
* Consistency Score

Bridge Dashboard and Progress.

Never duplicate Dashboard functionality.

---

# Trends

Support:

* Nutrition trends
* Water trends
* Weight trends

Compare every period against the previous one.

Example:

Protein

↑ +12 g/day

Calories

↓ -180 kcal/day

Water

→ No Change

---

# Charts

Use:

* Line Charts
* Simple Bar Charts

Avoid:

* Pie Charts
* 3D Charts
* Gauges

Charts should communicate trends clearly.

---

# Summary Cards

Display:

* Calories
* Protein
* Carbohydrates
* Fat
* Water
* Weight
* Weekly Net Energy Balance
* Estimated Fat Loss

Each card shows:

* Current value
* Goal (where applicable)
* Goal hit rate
* Trend arrow

---

# Goal Adherence Chart

Simple daily bars.

Example:

Mon ✅

Tue ❌

Wed ✅

Thu ✅

Fri ❌

Sat ✅

Sun ✅

No complicated visualizations.

---

# Weight

Display:

Current

↓

Weekly Average

↓

Monthly Average

↓

Trend

Use recorded measurements only.

Never interpolate missing data.

---

# History

Provide historical list.

Selecting a day opens:

Daily Log

No duplicated information.

---

# Empty State

If insufficient history exists:

Show:

"Keep logging consistently.

Progress will appear after a few days."

Never show empty charts.

---

# Insights

Founder Edition supports deterministic insights.

Examples:

* Protein increased by 12 g/day.
* Water consistency improved.
* Calories remained within target on 6 days.

No AI.

No predictions.

---

# Navigation

Progress

↓

History

↓

Daily Log

Read-only navigation.

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
└── Progress
```

No new top-level feature.

---

# ProgressSnapshot

Introduce a lightweight presentation model.

ProgressSnapshot contains:

* Summary Cards
* Charts
* Weekly Summary
* Monthly Summary
* Consistency Score
* Today's Impact
* Weekly Net Energy Balance
* Estimated Fat Loss

Generated on demand.

Never persisted.

---

# ViewModels

Implement:

ProgressViewModel

Responsibilities:

* Summary
* Charts
* Time Range
* Consistency Score
* Today's Impact

---

HistoryViewModel

Responsibilities:

* Daily History
* Filtering
* Navigation

---

WeightHistoryViewModel

Responsibilities:

* Weight Trends
* Weight History
* Weight Averages

Each ViewModel owns one responsibility.

---

# States

Implement:

ProgressState

* Loading
* Loaded
* Empty
* Error

HistoryState

* Loading
* Loaded
* Empty
* Error

WeightHistoryState

* Loading
* Loaded
* Empty
* Error

Avoid Boolean state flags.

---

# UseCases

Implement:

* GetProgressSummaryUseCase
* GetNutritionTrendsUseCase
* GetGoalAdherenceUseCase
* GetConsistencyScoreUseCase
* GetWeightHistoryUseCase
* GetWeeklySummaryUseCase
* GetMonthlySummaryUseCase
* GetHistoryUseCase
* GetTodayImpactUseCase

Each UseCase owns one responsibility.

Do not chain UseCases together.

---

# Repository

Do NOT create a ProgressRepository.

Reuse existing repositories.

Read from:

* DailyLogRepository
* SettingsRepository
* Weight repository (or existing storage)

Repositories return Domain models only.

---

# Calculations

Calculate:

* Averages
* Weekly summaries
* Monthly summaries
* Goal adherence
* Consistency Score
* Weekly Net Energy Balance
* Estimated Fat Loss
* Today's Impact

Never persist derived analytics.

---

# Performance

Load only the selected time range.

Do not load all history.

Prepare chart datasets inside UseCases.

SwiftUI renders prepared data only.

No chart calculations inside Views.

---

# Offline First

Everything works completely offline.

No internet required.

---

# Future Compatibility

Architecture already supports:

* HealthKit
* AI Insights
* Cloud Sync
* Widgets
* Apple Watch
* Advanced Analytics

No redesign required.

---

# Out of Scope

Do NOT implement:

* AI Coaching
* Predictions
* Community Comparisons
* Gamification
* Badges
* XP
* Levels
* Export
* Custom Date Ranges
* Persistent Caching
* Pagination
* Background Aggregation
* Trend Confidence

These belong to future milestones.

---

# Testing

Add focused unit tests covering:

* Weekly Summary
* Monthly Summary
* Goal Adherence
* Trends
* Charts
* Consistency Score
* Today's Impact
* Weekly Net Energy Balance
* Estimated Fat Loss
* ViewModels

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
* duplicate business calculations
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

Milestone 10 is complete when:

* Progress Overview works.
* Historical Trends work.
* Weekly Summary works.
* Monthly Summary works.
* Weight History works.
* Charts work.
* Goal Adherence works.
* Consistency Score works.
* Today's Impact works.
* Weekly Net Energy Balance works.
* Estimated Fat Loss works.
* History navigation works.
* ViewModels follow Clean Architecture.
* Project builds successfully.

---

# Success Criteria

After Milestone 10, Nutrition OS provides a complete offline analytics experience where users can understand long-term nutrition trends, evaluate goal adherence, monitor weight changes, review historical data, and receive deterministic insights—all while maintaining Clean Architecture, offline-first functionality, and using Daily Logs as the single source of historical truth.

