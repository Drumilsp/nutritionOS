# EngineeringStandards.md

**Project:** Nutrition OS (Founder Edition)

**Version:** 1.0

**Status:** Approved

**Last Updated:** July 2026

---

# Purpose

This document defines the engineering standards for Nutrition OS.

Its purpose is to ensure that every file in the project follows the same coding style, architecture, and quality expectations regardless of who implements it.

These standards apply to:

* Founder
* Codex
* Future contributors

---

# Engineering Philosophy

Our priorities are:

1. Correctness
2. Readability
3. Maintainability
4. Testability
5. Performance

Performance optimizations should only be introduced after measurement.

Never sacrifice readability for premature optimization.

---

# Founder Principle

> **Founder Simplicity First**

When two solutions are equally correct:

* Choose the simpler one.
* Avoid unnecessary abstractions.
* Build only what the Founder Edition needs.
* Keep future flexibility only when it is essentially free.

---

# General Coding Rules

Always:

* Write readable code.
* Prefer explicit code over clever code.
* Keep responsibilities small.
* Use descriptive names.
* Keep implementations predictable.
* Document important architectural components.

Never:

* Hide important behavior.
* Write unnecessary abstractions.
* Duplicate business logic.
* Mix multiple responsibilities in one type.

---

# File Organization

Every file should contain one primary type.

Example:

```text
FoodRepository.swift

Contains:

FoodRepository
```

Avoid multiple unrelated classes in the same file.

---

# File Size Guidelines

These are guidelines, not hard limits.

| Component      | Recommended Maximum |
| -------------- | ------------------: |
| View           |           250 lines |
| ViewModel      |           250 lines |
| Repository     |           300 lines |
| Service        |           300 lines |
| Manager        |           250 lines |
| Entity / Model |           150 lines |

If a file grows significantly larger, evaluate whether responsibilities should be split.

---

# Naming Conventions

## Managers

Managers own long-lived infrastructure.

Examples:

* PersistenceManager
* HealthKitManager

---

## Services

Services contain reusable business logic.

Examples:

* NutritionCalculationService
* ValidationService

---

## Repositories

Repositories manage data access.

Examples:

* FoodRepository
* MealRepository

---

## UseCases

UseCases represent business actions.

Examples:

* AddFoodUseCase
* LogMealUseCase
* CalculateDashboardSummaryUseCase

---

## ViewModels

ViewModels manage UI state.

Examples:

* DashboardViewModel
* FoodListViewModel

---

# Dependency Injection

Constructor Injection is the default.

Never use global singletons.

Dependencies should be explicit.

Bad:

```swift
let manager = PersistenceManager.shared
```

Good:

```swift
init(persistenceManager: PersistenceManager)
```

---

# Access Control

Use the most restrictive access level possible.

Default preference:

* private
* fileprivate
* internal
* public

Do not expose implementation details unnecessarily.

---

# Documentation

Infrastructure components should begin with documentation comments.

Example:

```swift
/// Manages the application's SwiftData persistence layer.
```

Public APIs should always be documented.

Complex business logic should include brief comments explaining **why**, not **what**.

---

# MARK Usage

Organize files consistently.

Preferred order:

```swift
// MARK: - Properties

// MARK: - Initializer

// MARK: - Public Methods

// MARK: - Private Methods
```

---

# Error Handling

Errors should flow upward through the architecture.

Never expose framework-specific errors directly to the UI.

Convert them into meaningful application errors where appropriate.

Never silently ignore failures.

---

# Swift Conventions

Prefer:

* let over var
* value types when appropriate
* explicit naming
* modern Swift APIs
* async/await

Avoid:

* force unwrap (`!`)
* force try (`try!`)
* unnecessary optionals
* unnecessary inheritance

---

# Concurrency

Use Swift Concurrency.

Prefer:

* async/await
* Task
* actors (when appropriate)

Avoid callback-based APIs unless required by Apple frameworks.

---

# Testing

Every significant feature should be testable.

Repositories, services, and business logic should be written to allow unit testing.

Views should remain lightweight.

---

# Build Verification

Before completing any milestone:

* Build the project.
* Fix compiler warnings where practical.
* Ensure new code compiles successfully.

Do not spend excessive time debugging simulator issues.

A successful build is the primary verification step.

---

# Git Workflow

The Founder owns Git.

AI assistants must never:

* initialize repositories
* commit code
* push changes
* rewrite Git history

Git operations remain a human responsibility.

---

# Working Directory Rule

Before performing implementation work:

* Verify the current working directory.
* Verify the project root.
* Never modify files outside the Nutrition OS repository.

If verification fails:

Stop immediately.

---

# Scope Discipline

Implement only the assigned milestone.

Do not:

* refactor unrelated code
* redesign architecture
* implement future milestones

Stay within scope.

---

# Code Reviews

Every milestone follows:

Implementation

↓

Founder Build

↓

CTO Review

↓

Founder Testing

↓

Git Commit

No milestone is considered complete until reviewed.

---

# Definition of Done

A task is complete when:

* Code builds successfully.
* Architecture rules are respected.
* Coding standards are followed.
* Scope is respected.
* Documentation comments are added where required.
* No unnecessary code was introduced.

---

# Continuous Improvement

Engineering standards may evolve based on real implementation experience.

Standards should not change because of hypothetical future requirements.

Every new rule should solve a real problem encountered during development.

---

# Source of Truth

This document defines the engineering standards for Nutrition OS.

All implementation should follow these standards unless an approved engineering decision explicitly replaces them.

