# Architecture.md

**Project:** Nutrition OS (Founder Edition)

**Version:** 1.0

**Status:** Approved

**Last Updated:** July 2026

---

# Overview

Nutrition OS is an **offline-first iOS application** built using **SwiftUI** and **SwiftData**.

The project follows a simplified Clean Architecture designed for a solo founder. The architecture prioritizes readability, maintainability, and long-term scalability while avoiding unnecessary complexity.

The primary goal is to build a robust Founder Edition that can later evolve into a broader Athlete OS ecosystem without requiring a complete redesign.

---

# Architecture Principles

The project follows these core principles:

* Offline First
* Feature-Based Architecture
* Clean Architecture
* Dependency Injection
* Composition Root
* Repository Pattern
* Single Responsibility Principle
* Specification-Driven / Milestone-Driven Development

---

# Founder Principle

> **Founder Simplicity First**

When multiple correct solutions exist:

* Prefer the simpler solution.
* Future flexibility is valuable only when it is essentially free.
* Avoid abstractions for hypothetical future requirements.

---

# High-Level Architecture

```text
SwiftUI View
        │
        ▼
ViewModel
        │
        ▼
UseCase
        │
        ▼
Repository
        │
        ▼
Infrastructure
        │
        ▼
SwiftData / HealthKit
```

Dependencies always flow downward.

Higher layers never know implementation details of lower layers.

---

# Feature-Based Organization

Every application feature owns its own code.

```text
Features/

    Dashboard/

    Nutrition/

    History/

    Settings/
```

Each feature contains:

```text
Feature/

    Domain/

    Data/

    Presentation/
```

This keeps related code together and improves long-term maintainability.

---

# Layer Responsibilities

## Presentation

Responsible for:

* SwiftUI Views
* ViewModels
* UI state
* User interaction

Never:

* Perform persistence
* Perform business calculations

---

## Domain

Responsible for:

* Business rules
* UseCases
* Entities
* Domain services

Never:

* Import SwiftUI
* Import SwiftData
* Depend on Infrastructure

---

## Data

Responsible for:

* Repository implementations
* Mapping
* Data coordination

Never:

* Perform UI logic

---

## Infrastructure

Responsible for:

* SwiftData
* HealthKit
* CloudKit
* Logging
* System frameworks

Infrastructure must never contain business logic.

---

# Dependency Injection

The project uses constructor injection.

There are no global singletons.

Long-lived dependencies are created once by:

```text
AppDependencies
```

AppDependencies acts as the application's Composition Root.

---

# Persistence Architecture

Persistence consists of three components:

```text
PersistenceConfiguration

        ↓

ModelContainerFactory

        ↓

PersistenceManager
```

Responsibilities:

### PersistenceConfiguration

Defines persistence configuration.

### ModelContainerFactory

Creates configured SwiftData ModelContainers.

### PersistenceManager

Owns the application's persistence lifetime.

Repositories communicate only with PersistenceManager.

---

# Repository Pattern

Repositories isolate business logic from storage.

Business layers never communicate directly with SwiftData.

```text
UseCase

↓

Repository Protocol

↓

Repository Implementation

↓

PersistenceManager

↓

SwiftData
```

---

# HealthKit

HealthKit is treated as Infrastructure.

Business logic never imports HealthKit directly.

If HealthKit permissions are denied, the application continues functioning using available local data.

---

# CloudKit

CloudKit is intentionally deferred.

Current architecture prepares for CloudKit without implementing synchronization.

CloudKit integration should require changes only inside Infrastructure.

---

# Historical Data

History is immutable.

Food changes must never modify historical logs.

Architecture follows snapshot-based history.

Example:

```text
Food

↓

LoggedFood
```

LoggedFood stores copied nutritional information.

Editing Food later does not affect history.

The same principle applies to Meals.

---

# Error Flow

Errors flow upward.

```text
Infrastructure

↓

Repository

↓

UseCase

↓

ViewModel

↓

View
```

Framework-specific errors should be translated into application-specific errors before reaching the UI.

---

# Lifetime

Application Lifetime:

* AppDependencies
* PersistenceManager
* HealthKitManager (future)

Screen Lifetime:

* ViewModels

Temporary Lifetime:

* UseCases

---

# Folder Structure

```text
App/

Core/

Features/

Infrastructure/

Resources/

Documentation/

Tests/
```

The folder hierarchy mirrors the architectural layers.

---

# Architecture Rules

Always:

* Constructor Injection
* Feature-Based Organization
* One Responsibility per Type
* One Primary Type per File
* Explicit Dependencies
* Predictable Folder Placement

Never:

* Global Singletons
* Circular Dependencies
* Business Logic inside Views
* SwiftData inside Views
* HealthKit inside Views
* Hidden Dependencies

---

# Architecture Evolution

Architecture changes are allowed only when:

* A real implementation problem is discovered.
* A product requirement changes.
* A redesign is explicitly approved.

Architecture should never change based solely on hypothetical future needs.

---

# Source of Truth

This document defines the architectural rules of Nutrition OS.

All implementation must conform to this architecture unless an approved architectural decision explicitly replaces it.

