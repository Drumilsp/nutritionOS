# Nutrition OS — Milestone 01 Implementation

Before doing anything, complete this **Pre-Flight Checklist** and show the results.

## Pre-Flight Checklist (Mandatory)

1. Print the current working directory.
2. Run `git rev-parse --show-toplevel`.
3. Verify both paths point to the Nutrition OS project root.
4. If either path is incorrect:

   * Stop immediately.
   * Report the issue.
   * Do not modify any files.
   * Do not execute any commands.

Print:

```
Current Working Directory:
<path>

Git Repository Root:
<path>

Status:
Verified / Halted
```

---

## Files to Read

Before implementation, read:

* Documentation/AI/CodexOnboarding.md
* Documentation/Architecture/Architecture.md
* Documentation/Architecture/EngineeringStandards.md
* Documentation/Architecture/FounderEdition.md
* Documentation/Architecture/GitWorkflow.md
* Documentation/Milestones/Milestone-01-Persistence.md

Do not continue until you understand the milestone.

---

# Objective

Complete **Milestone 01 – Persistence Foundation**.

`PersistenceConfiguration` has already been implemented.

Complete the remaining work required by the milestone.

---

# Scope

Implement only the remaining components required for Milestone 01.

Examples include:

* ModelContainerFactory
* PersistenceManager
* AppDependencies

Update related tests if necessary.

Wire the persistence infrastructure together.

Do **not** implement anything from Milestone 02 or later.

---

# Engineering Rules

You may:

* Read related project files.
* Modify related implementation files.
* Add documentation comments.
* Update or create unit tests.
* Build the project once implementation is complete.

You may NOT:

* Change the approved architecture.
* Rename architectural components.
* Refactor unrelated modules.
* Add third-party libraries.
* Implement future milestones.
* Modify files outside the Nutrition OS project.

---

# Git & Filesystem Safety Rules (Mandatory)

You must **never**:

* run `git init`
* run `git add`
* run `git add -A`
* run `git add .`
* create commits
* amend commits
* push
* pull
* merge
* rebase
* delete repositories
* execute destructive filesystem commands
* modify anything outside the Nutrition OS project directory

Do not access my Home directory except to verify the current working directory.

Never recursively scan or index my Home directory.

If you believe a Git operation is required, stop and ask me instead.

---

# Build Verification

After implementation:

1. Perform one project build.
2. If the build succeeds, stop.
3. If simulator execution fails, report the failure.
4. Do not spend time repeatedly debugging simulator issues.

---

# Deliverables

When complete, provide:

1. Summary
2. Files created
3. Files modified
4. Architecture compliance
5. Assumptions made
6. Questions for CTO review
7. Build result

Then stop.

Do not begin Milestone 02.

Wait for review before continuing.
