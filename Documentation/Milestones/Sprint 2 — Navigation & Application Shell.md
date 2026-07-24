# Nutrition OS — Founder Edition
# Sprint 2 — Navigation & Application Shell
## Implementation Specification

**Status:** ✅ Approved  
**Sprint:** 2 – Navigation & Application Shell  
**Objective:** Build the navigation infrastructure and application shell that every future feature screen will use.

---

# Overview

Sprint 2 is **not** about implementing features.

Do NOT implement:

- Dashboard
- Timeline
- Food Management
- Meal Management
- Progress Analytics
- Settings Features
- HealthKit UI

Sprint 2 exists solely to establish the application's navigation architecture.

By the end of this sprint, Nutrition OS should launch into a polished application shell with working navigation between the three primary tabs.

---

# Sprint Goals

Implement:

- Root Application Shell
- NavigationStack
- TabView
- NavigationPath
- Sheet Routing
- Floating Action Button
- Placeholder Screens

No business logic should be added.

---

# Navigation Philosophy

Navigation should reflect the user's daily workflow.

Final Founder Edition navigation:

```text
Today

Progress

Settings
```

This navigation is now considered stable and should not change during Founder Edition.

---

# Root Application Structure

Implement a root container responsible for:

- Application shell
- NavigationStack
- TabView
- Sheet presentation
- Navigation state

The root should remain lightweight.

It should not contain feature logic.

---

# NavigationStack

Implement a single root NavigationStack.

Requirements

- Native iOS navigation
- Future support for deep linking
- NavigationPath support
- Feature independent
- Easily extensible

No custom navigation controllers.

---

# TabView

Implement the final tab bar.

Tabs

- Today
- Progress
- Settings

Requirements

- Native TabView
- SF Symbols
- Native tab animations
- Uses Design System

---

# Placeholder Screens

Create placeholder screens for

Today

Progress

Settings

Requirements

- Large navigation titles
- Use Design System
- EmptyStateView
- AppCard
- Proper spacing
- Accessible

These screens exist only to verify navigation.

No feature implementation.

---

# Floating Action Button

Implement a single Floating Action Button.

Rules

Visible only on

Today

Purpose

Quick Log

Requirements

- Uses Design System component
- Floating above safe area
- Native animation
- Accessible
- Hidden on other tabs

---

# Sheet Routing

Prepare reusable routing for

- Quick Log
- Create Food
- Create Meal

Only routing.

Placeholder sheets only.

No feature implementation.

---

# Navigation Routing

Create centralized navigation infrastructure.

Future destinations should be easy to add.

Possible architecture

- AppRouter
- NavigationDestination
- SheetDestination

The implementation choice is flexible as long as routing remains centralized and feature independent.

---

# Deep Link Preparation

Prepare the architecture for future navigation to

- Food
- Meal
- Daily Log
- Progress
- Settings

No deep links need to function during this sprint.

Only the routing structure should support future expansion.

---

# Design Requirements

All UI must use the Design System.

Use

- AppCard
- EmptyStateView
- PrimaryButton
- Typography
- Colors
- Spacing
- Icons

Do not duplicate styling.

---

# Accessibility

Navigation must support

- Dynamic Type
- VoiceOver
- Dark Mode
- Light Mode
- Minimum 44pt touch targets

The Floating Action Button must be fully accessible.

---

# Dependencies

Navigation layer may depend on

- SwiftUI
- Foundation
- DesignSystem

Do not introduce

- Repository calls
- UseCases
- SwiftData queries
- HealthKit
- Business logic

Navigation should remain purely presentation infrastructure.

---

# Coding Standards

- Keep navigation modular.
- Prefer composition.
- Keep routing centralized.
- Keep placeholder screens lightweight.
- No duplicated navigation code.
- No feature logic.
- Follow existing project architecture.

---

# Acceptance Criteria

Sprint 2 is complete when

- ✅ Root application shell implemented
- ✅ NavigationStack implemented
- ✅ TabView implemented
- ✅ Today tab implemented
- ✅ Progress tab implemented
- ✅ Settings tab implemented
- ✅ Floating Action Button implemented
- ✅ Sheet routing implemented
- ✅ Placeholder screens implemented
- ✅ Uses Design System throughout
- ✅ Successful build
- ✅ No compiler errors
- ✅ No new Swift Concurrency warnings

---

# Out of Scope

Do NOT implement

- Dashboard
- Timeline
- Food Library
- Meal Library
- Progress Charts
- Weight History
- Settings Features
- HealthKit UI
- Analytics
- Logging functionality

These belong to future sprints.

---

# Deliverables

At completion provide

1. Summary of files created.
2. Summary of files modified.
3. Navigation architecture overview.
4. Routing architecture overview.
5. Assumptions made.
6. Build result.
7. Remaining TODOs.
8. Acceptance criteria verification.

---

# Definition of Done

Sprint 2 is considered complete only when:

- The application launches into a fully functional navigation shell.
- Users can switch between Today, Progress, and Settings.
- The Floating Action Button behaves correctly.
- Placeholder sheets open through centralized routing.
- The Design System is consistently applied.
- The architecture is ready for Sprint 3 without modification.

---

# Next Sprint

Sprint 3 — Today Screen

Sprint 3 will replace the Today placeholder with the real implementation.

It will introduce:

- Dashboard
- Timeline
- Today's Totals
- Suggestions
- Quick Log integration

The navigation architecture created in Sprint 2 should require **no changes** during Sprint 3.
