# Milestone-11-HealthKit.md

**Project:** Nutrition OS (Founder Edition)

**Milestone:** 11 – HealthKit Integration

**Status:** Ready for Implementation

**Priority:** High

---

# Goal

Integrate Apple HealthKit into Nutrition OS while preserving Clean Architecture, offline-first functionality and user privacy.

HealthKit is an optional enhancement.

Nutrition OS must remain fully functional without it.

---

# Objectives

Implement:

* HealthKit Integration
* Permission Management
* Weight Synchronization
* Active Energy Import
* Workout Import
* Nutrition Export
* Water Export
* Health Repository
* Sync Metadata
* Health ViewModels
* Health UseCases

---

# HealthKit Philosophy

HealthKit is an integration.

It is NOT the application's business layer.

Nutrition OS owns:

* Foods
* Meals
* DailyLogs
* Water Entries
* Weight Entries
* Goals
* Dashboard
* Progress

HealthKit owns Apple Health records.

---

# Offline First

Nutrition OS must continue working perfectly without HealthKit.

HealthKit enhances the experience.

It never becomes mandatory.

---

# Source of Truth

Nutrition

Nutrition OS

↓

HealthKit (optional export)

---

Weight

Nutrition OS

↔

HealthKit

Two-way synchronization.

Latest timestamp wins.

---

Active Energy

HealthKit

↓

Nutrition OS

Read only.

---

Workouts

HealthKit

↓

Nutrition OS

Read only.

---

# Ownership

Nutrition OS remains the owner of business data.

Deleting HealthKit data must never delete:

* Foods
* Meals
* DailyLogs
* Weight History

Local history always remains intact.

---

# Permissions

Request permissions only when required.

Never request all permissions on first launch.

Founder Edition supports:

Read

* Weight
* Active Energy
* Workouts

Write

* Nutrition
* Water
* Weight

Each permission must be independently controllable.

---

# Settings

Apple Health receives its own Settings section.

Display:

* Connection Status
* Read Permissions
* Write Permissions
* Last Successful Sync
* Per-data-type Last Sync
* Sync Now
* Disconnect Apple Health

Users always know what is synchronized.

---

# Sync Toggles

Support independent toggles.

Examples:

Reading

* Weight
* Active Energy
* Workouts

Writing

* Nutrition
* Water
* Weight

Never force all-or-nothing synchronization.

---

# Manual Sync

Provide:

Sync Now

Users always retain manual control.

---

# Manual Overrides

Manual logging remains available even when HealthKit is connected.

Manual entries are never disabled.

Latest timestamp wins.

---

# HealthKit Status

Support:

Connected

Disconnected

Permission Denied

Unavailable

Syncing

Error

Always use user-friendly messages.

Never expose Apple API errors.

---

# Weight

Introduce WeightEntry as the historical source of truth.

WeightEntry contains:

* id
* dateTime
* weight
* source

Sources:

* Manual
* HealthKit
* Import (future)

UserProfile.currentWeight is NOT historical data.

Weight history belongs to WeightRepository.

---

# Weight Repository

Responsibilities:

* Save Weight
* Delete Weight
* Latest Weight
* Weight History
* Weight Between Dates

Nothing else.

---

# Nutrition Export

Export:

LoggedFood

↓

HealthKit Dietary Sample

Each logged item exports individually.

Never export Dashboard totals.

---

# Water Export

Export:

WaterEntry

↓

HealthKit Water Sample

Every entry exports independently.

---

# Active Energy

Import only.

Never export.

Never overwrite HealthKit values.

---

# Workouts

Import:

* Workout Type
* Duration
* Active Energy

Treat workouts as contextual information.

Never allow editing.

---

# Mapping

All mapping occurs inside dedicated mappers.

Examples:

HealthKitWeightMapper

HealthKitNutritionMapper

HealthKitWaterMapper

HealthKitWorkoutMapper

No mapping inside repositories.

---

# Canonical Units

Internally store:

Weight

kg

Water

mL

Energy

kcal

Convert external units during mapping.

---

# Timestamps

Always preserve original timestamps.

Never replace with:

* Import Time
* Sync Time

History reflects when events actually occurred.

---

# Sync Metadata

Create dedicated synchronization metadata.

Store:

* Local ID
* External HealthKit ID
* Last Sync Time
* Sync Direction
* Sync Status

Keep HealthKit metadata outside domain models.

---

# Duplicate Prevention

Every synchronized record stores a stable external identifier.

Future synchronization updates existing records.

Never create duplicates.

---

# Deletion Rules

Deleting HealthKit records:

Does NOT delete local data.

Deleting local entries:

Attempts to remove corresponding HealthKit entries where supported.

Failure to delete remotely must never restore deleted local data.

---

# Architecture

HealthKit belongs inside Infrastructure.

Architecture:

SwiftUI

↓

ViewModels

↓

UseCases

↓

Repository Protocols

↓

HealthRepository

↓

HealthKitService

↓

Apple HealthKit

---

# HealthRepository

Responsibilities:

* Permissions
* Import
* Export
* Synchronization

Business rules remain inside UseCases.

HealthRepository acts as an adapter.

Not an orchestrator.

---

# HealthKitService

Responsibilities:

* HKHealthStore
* Authorization
* Queries
* Save
* Delete

Thin wrapper around Apple APIs.

---

# UseCases

Implement:

* RequestHealthPermissionsUseCase
* SyncHealthDataUseCase
* ExportNutritionUseCase
* ExportWaterUseCase
* ImportWeightUseCase
* ImportActiveEnergyUseCase
* ImportWorkoutsUseCase
* DisconnectHealthUseCase

Each UseCase owns one responsibility.

Never chain UseCases together.

---

# ViewModels

Implement:

HealthSettingsViewModel

Responsibilities:

* Connection Status
* Permissions
* Sync
* Disconnect

HealthSyncViewModel

Responsibilities:

* Manual Sync
* Sync Status
* Last Sync

One responsibility per ViewModel.

---

# States

Implement:

HealthState

* Loading
* Connected
* Disconnected
* Syncing
* PermissionDenied
* Error

SyncState

* Idle
* Syncing
* Success
* Error

Avoid Boolean state flags.

---

# Performance

Use incremental synchronization.

Workflow:

Last Successful Sync

↓

Fetch newer HealthKit records

↓

Merge

↓

Update Sync Metadata

Never repeatedly import all HealthKit data.

---

# Battery

Avoid continuous polling.

Supported sync moments:

* Manual Sync
* App Launch
* App Active
* Relevant local changes

No continuous background synchronization.

---

# Privacy

Everything remains on-device.

Founder Edition includes:

* No cloud sync
* No analytics upload
* No external health servers

Only Apple Health and the local database participate.

---

# Error Handling

Return domain-friendly errors.

Examples:

HealthPermissionDenied

HealthUnavailable

HealthNoData

Never expose Apple framework error codes.

---

# Testing

Mock HealthRepository.

Never depend on live HealthKit.

Cover:

* Permission flow
* Successful sync
* Failed sync
* Permission denied
* No data
* Duplicate prevention
* Incremental synchronization

No UI tests.

---

# Future Compatibility

Architecture already supports:

* Apple Watch
* Widgets
* AI Insights
* Cloud Sync
* Google Fit
* Garmin
* Fitbit

without redesign.

---

# Out of Scope

Do NOT implement:

* Sleep
* Heart Rate
* Blood Pressure
* ECG
* VO₂ Max
* Medication
* Continuous background sync
* Real-time observers
* Cloud synchronization
* AI coaching
* Health diagnostics screen

These belong to future milestones.

---

# Build

Run one successful build.

Stop after the successful build.

---

# Safety Rules

Never:

* redesign approved architecture
* expose HealthKit types above Infrastructure
* duplicate business logic
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

Milestone 11 is complete when:

* HealthKit permissions work.
* Weight synchronization works.
* Active Energy import works.
* Workout import works.
* Nutrition export works.
* Water export works.
* Sync metadata works.
* Incremental synchronization works.
* HealthRepository follows Clean Architecture.
* Project builds successfully.

---

# Success Criteria

After Milestone 11, Nutrition OS integrates seamlessly with Apple Health while remaining fully functional offline. Users can selectively synchronize weight, nutrition, water, workouts, and active energy through a transparent, privacy-focused integration that preserves Clean Architecture, keeps Nutrition OS as the owner of its business data, and isolates all Apple-specific code within the infrastructure layer.

