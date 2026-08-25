# Nutri

Nutri is an offline-first iOS nutrition tracker built with SwiftUI and SwiftData. It helps users manage foods and meals, log daily intake, track water and weight, view nutrition progress, and optionally connect with Apple Health.

## Features

- Daily nutrition dashboard with calories, macros, water, and meal summaries
- Food library with search, favorites, archive/restore, duplicate, and edit flows
- Meal library built from reusable food items
- Quick logging for foods, meals, and water
- Progress views for weight, nutrition trends, consistency, and goal adherence
- Settings for goals, units, display preferences, profile data, import/export, and local data reset
- Optional Apple Health integration for supported health data
- JSON import for food and meal library data

## Tech Stack

- Swift
- SwiftUI
- SwiftData
- Charts
- HealthKit
- Observation / Combine
- Swift Testing and XCTest

## Architecture

The project uses a feature-based structure with a lightweight clean architecture style:

```text
App/              App composition and navigation
Core/             Shared validation, errors, and providers
Features/         Dashboard, Nutrition, Progress, Settings, Health
Infrastructure/   SwiftData and HealthKit implementations
Presentation/     Shared design system components and tokens
NutriTests/       Unit and integration-style tests
NutriUITests/     UI test target
```

High-level flow:

```text
SwiftUI View → ViewModel → Use Case → Repository → SwiftData / HealthKit
```

## Requirements

- Xcode 17 or newer
- iOS 17+ app target
- macOS with iOS Simulator support

## Run Locally

Clone the repository and open the Xcode project:

```bash
git clone <repo-url>
cd Nutri
open Nutri.xcodeproj
```

Then select the `Nutri` scheme and run on an iOS simulator or device.

## Build from Terminal

```bash
xcodebuild build \
  -project Nutri.xcodeproj \
  -scheme Nutri \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

Use an available simulator name from your machine if `iPhone 17` is not installed.

## Run Tests

```bash
xcodebuild test \
  -project Nutri.xcodeproj \
  -scheme Nutri \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:NutriTests
```

## Project Highlights

- Offline-first persistence with SwiftData
- HealthKit isolated behind infrastructure/repository boundaries
- Immutable nutrition snapshots for logged foods and meals
- Reusable design system tokens and SwiftUI components
- Tested domain, repository, use-case, persistence, and HealthKit mapping logic


## Notes

This is a portfolio project focused on native iOS architecture, local-first data modeling, and practical nutrition tracking workflows.
