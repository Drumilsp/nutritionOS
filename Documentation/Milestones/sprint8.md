# Sprint 8 — Final Polish & Release

**Sprint:** 8 of 8
**Status:** Approved for Implementation / QA
**Phase:** Final Polish & Release Readiness

---

# 1. Objective

Complete the final release-readiness pass for Nutrition OS Founder Edition.

Sprint 8 focuses on stabilization, manual QA, bug fixing, accessibility, visual polish, regression testing, documentation freeze, and release preparation.

Sprint 8 is not a feature-expansion sprint.

---

# 2. References

Sprint 8 must follow the existing project references:

1. `Documentation/Architecture.md`
2. `Documentation/Design.md`
3. `Documentation/SampleDesign.html` *(Visual Reference Only)*
4. `Documentation/Sprint8.md`

If conflicts occur:

```text
Architecture.md
↓
Design.md
↓
Sprint8.md
↓
SampleDesign.html
```

---

# 3. Sprint Philosophy

Sprint 8 exists to make the app stable, consistent, and release-ready.

```text
Build less.
Verify more.
Fix only what matters.
Protect the architecture.
Prepare the release candidate.
```

---

# 4. Scope

## In Scope

### Consolidated Manual QA

Manual QA must cover:

* Sprint 4 — Food Management
* Sprint 5 — Meal Management
* Sprint 6 — Progress & Analytics
* Sprint 7 — Settings & Data
* Today Screen
* Quick Log
* App navigation
* App launch and relaunch behavior

---

### Bug Fixes

Fix release-blocking or user-visible issues found during QA.

Allowed bug fix categories:

* Crashes
* Broken navigation
* Broken save/delete/archive/restore behavior
* Incorrect nutrition totals
* Incorrect progress calculations
* Broken export/reset behavior
* Invalid empty/loading/error states
* Accessibility blockers
* Dynamic Type layout breakage
* Dark Mode readability issues
* Data persistence failures
* Build errors
* High-priority warnings that indicate real defects

---

### Visual Polish

Verify and fix:

* Light Mode
* Dark Mode
* Dynamic Type
* Card spacing
* List spacing
* Button alignment
* Text clipping
* Chart readability
* Empty states
* Error states
* Destructive action styling
* Settings section consistency
* Navigation title consistency

---

### Accessibility

Verify and fix:

* VoiceOver labels
* Button labels
* Destructive action warnings
* Dynamic Type support
* Large text layouts
* Tap target sizes
* Color contrast
* Focus order where applicable

---

### Release Hardening

Verify:

* App launches successfully
* No major startup crash
* Tab navigation works
* Quick Log works
* Food logging works
* Meal logging works
* Progress reflects logs
* Settings navigation works
* Export works
* Reset works
* App remains usable after reset
* App remains usable after relaunch
* No presentation layer directly accesses repositories

---

### Documentation Freeze

Update documentation to reflect final implementation status:

* Project Specification
* Project Journal
* AI Engineering Journal
* Sprint status table
* Decision log
* Open QA list
* Release notes, if needed

---

# 5. Out of Scope

Sprint 8 must not introduce:

* New major product modules
* New design system
* New architecture
* New persistence model
* Cloud sync
* Account system
* Subscription system
* AI coaching
* Social features
* Complex onboarding redesign
* Broad refactors
* Non-essential feature additions

Small fixes are allowed only when they support release readiness.

---

# 6. Manual QA Checklist

## Global App QA

* App launches successfully
* No crash on first launch
* No crash after relaunch
* Main tab navigation works
* Today tab loads
* Quick Log opens
* Food Library opens
* Meal Library opens
* Progress tab opens
* Settings opens
* Back navigation works
* No broken destinations
* No placeholder screen remains unintentionally

---

## Sprint 4 — Food Management QA

### Food Library

* Settings → Manage Foods opens Food Library
* Food Library loads correctly
* Search works
* Filters work
* Sort menu works
* Food rows display correctly
* Empty state displays correctly
* Loading state displays correctly
* Error state displays correctly if simulated

### Food CRUD

* Create custom food
* Edit custom food
* Duplicate food
* Favorite/unfavorite food
* Archive food
* Undo archive if supported
* Restore archived food
* Delete food
* Deleted food disappears from active list

### System Food Restrictions

* System food cannot be edited directly if prohibited
* System food cannot be deleted if prohibited
* Allowed system-food actions still work if supported
* Duplicate/favorite behavior is correct if supported

### Quick Log Integration

* Quick Log opens
* New Food opens shared Food Editor
* Created food becomes selectable/loggable
* Logged food updates Today correctly

---

## Sprint 5 — Meal Management QA

### Meal Library

* Settings → Manage Meals opens Meal Library
* Meal Library loads correctly
* Search works
* Filters work
* Sort works
* Favorite/unfavorite meal works
* Archive meal works
* Restore meal works
* Delete meal works
* Duplicate meal works

### Meal Editor

* Create meal
* Add foods to meal
* Remove food from meal
* Change serving quantity
* Reorder foods if implemented
* Save meal
* Cancel edit
* Open Meal Details
* Nutrition totals recalculate correctly

### Meal Logging

* Quick Log opens Meals flow
* Existing meal can be selected
* Meal logs successfully
* Today updates correctly
* Historical logged meal remains stable after meal template edit

---

## Sprint 6 — Progress & Analytics QA

### Progress Tab

* Progress tab opens
* Daily summary loads
* Weekly summary loads
* Monthly summary loads
* Goal section loads
* Consistency section loads
* Trend charts load
* Weight section loads
* History section loads

### Time Ranges

* Today range works
* Week range works
* Month range works
* Year range works
* Custom range works
* Charts update with selected range
* Summaries update with selected range

### Fiber Behavior

* Fiber intake appears in summaries/charts
* No fiber goal is shown
* No fiber remaining value is shown
* No fiber completion percentage is shown

### History Search

* Searching a logged food name returns matching days
* Searching a logged meal name returns matching days
* Searching optional notes works if notes exist
* Searching random text shows empty state

---

## Sprint 7 — Settings & Data QA

### Settings Home

* Settings opens correctly
* Nutrition section appears
* Management section appears
* Data section appears
* App section appears

### Nutrition Goals

* Protein goal is editable
* Carbohydrate goal is editable
* Fat goal is editable
* Water goal is editable
* Calories are not editable
* Fiber is not editable
* Saved values persist after closing/reopening
* Invalid values show validation errors

### Unit Settings

* Supported unit settings appear
* Unsupported unit settings do not appear
* Saving supported unit preferences works
* Preferences persist after closing/reopening

### Display Preferences

* Supported display preferences appear
* Unsupported preferences do not appear
* Saving supported preferences works
* Preferences persist after closing/reopening

### Data Export

* Export screen opens
* Export text appears
* Export is read-only
* Export includes existing local records
* Export does not mutate data

### Reset Local Data

* Reset screen opens
* Reset requires confirmation
* Cancel keeps data intact
* Confirm reset clears supported local data
* App returns to safe default state
* App does not crash after reset
* App does not crash after relaunch

### About

* App name appears
* Version appears if available
* Build number appears if available
* Debug/environment info appears only if supported

---

# 7. Accessibility QA

Run across Today, Quick Log, Foods, Meals, Progress, and Settings:

* VoiceOver reads screen titles
* VoiceOver reads buttons clearly
* Destructive actions have clear labels
* Form fields have accessible labels
* Charts have accessible summaries where practical
* Tap targets are usable
* Large text does not clip important content
* Dynamic Type layouts remain usable
* Dark Mode contrast is acceptable
* Light Mode contrast is acceptable

---

# 8. Regression QA

Verify that Sprint 8 fixes do not break:

* Today Screen
* Quick Log
* Food Management
* Meal Management
* Progress & Analytics
* Settings & Data
* Local persistence
* Export
* Reset
* App navigation
* App relaunch

---

# 9. Architecture Verification

Before closing Sprint 8, verify:

* No SwiftUI view accesses repositories directly
* No presentation type bypasses UseCases
* Architecture remains:

```text
Repository
↓
UseCases
↓
ViewModel
↓
ScreenState
↓
SwiftUI
```

* No new architecture pattern was introduced
* No new persistence model was introduced without approval
* Existing dependency injection remains intact

---

# 10. Build Verification

Sprint 8 requires:

* `xcodebuild` succeeds
* `git diff --check` passes for implementation changes
* Known warnings are reviewed
* New warnings are classified as:

  * blocker
  * acceptable
  * pre-existing
* No release-blocking warnings remain unresolved

---

# 11. Bug Fixing Rules

During Sprint 8, fixes must be minimal and targeted.

Allowed:

* Fix crashes
* Fix broken flows
* Fix incorrect calculations
* Fix accessibility blockers
* Fix visual bugs
* Fix persistence bugs
* Fix validation bugs
* Fix navigation bugs

Not allowed without approval:

* Broad refactors
* Architecture rewrites
* New modules
* New design patterns
* New persistence models
* New product features
* Plugin-assisted mass rewrites

---

# 12. Release Candidate Criteria

The app may be considered a release candidate when:

* App builds successfully
* Core flows work
* No major crashes remain
* Manual QA for Sprints 4–7 is complete
* Today and Quick Log are stable
* Food and Meal CRUD work
* Progress analytics display correctly
* Settings export/reset work safely
* Accessibility blockers are resolved
* Documentation is updated
* Sprint 8 is documented
* Known issues are listed clearly

---

# 13. Optional Post-Sprint Cleanup Review

After Sprint 8 implementation and QA are complete, an optional controlled cleanup review may be performed.

Rules:

* Review only
* No broad refactors
* No architecture changes
* No UI redesign
* No mass rewrites
* Suggestions must be approved before edits

This may be used for tools/plugins such as Ponytail or similar cleanup assistants only after release-readiness work is complete.

---

# 14. Acceptance Criteria

Sprint 8 is complete when:

* Consolidated manual QA is completed
* Critical bugs are fixed
* Visual polish pass is completed
* Accessibility pass is completed
* Regression QA is completed
* Architecture verification passes
* Build verification passes
* Documentation is updated
* Release candidate status is reached or remaining issues are explicitly documented

---

# 15. Definition of Done

Sprint 8 is complete when:

* The app is stable enough to be considered release-ready
* Sprints 4–7 manual QA debt is resolved or explicitly documented
* No release-blocking issues remain
* Architecture remains intact
* Design system remains intact
* Documentation reflects final status
* Session 025 is documented
* Project is ready for final release candidate review

---

# 16. Sprint Status

**Status:** Approved for Final Polish & Release Readiness

Sprint 8 should proceed as a QA, stabilization, and release-readiness sprint.

No new product, design, persistence, or architectural decisions should be introduced unless a release blocker requires explicit clarification.

