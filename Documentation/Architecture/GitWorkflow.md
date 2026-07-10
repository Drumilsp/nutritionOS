# GitWorkflow.md

**Project:** Nutrition OS (Founder Edition)

**Version:** 1.0

**Status:** Approved

**Last Updated:** July 2026

---

# Purpose

This document defines the official Git workflow for Nutrition OS.

The goals are:

* Maintain a clean Git history.
* Keep commits meaningful.
* Prevent accidental data loss.
* Clearly separate implementation from version control.

Git is owned by the Founder.

AI assistants do **not** manage the repository.

---

# Branch Strategy

Founder Edition uses a simple workflow.

Primary branch:

```text id="lw74lk"
main
```

Development is performed directly on `main` during Founder Edition.

Feature branches may be introduced later if the project grows or multiple contributors are involved.

---

# Repository Ownership

Only the Founder performs Git operations.

AI assistants must never:

* initialize repositories
* create commits
* amend commits
* rewrite history
* merge branches
* push to remote
* delete branches
* execute destructive Git commands

AI is responsible only for source code.

---

# Working Directory Rule

Before any implementation begins:

Verify:

```text id="u9d0i7"
pwd
```

Verify Git root:

```text id="p1t8fd"
git rev-parse --show-toplevel
```

Implementation must only occur inside the Nutrition OS project directory.

If verification fails:

Stop immediately.

Never continue outside the project root.

---

# Commit Philosophy

Each commit should represent one meaningful engineering milestone.

Good commits answer:

"What changed?"

Poor commits answer:

"What happened today?"

---

# Commit Frequency

Recommended:

One commit per completed milestone or logical unit of work.

Examples:

* Persistence Foundation
* Nutrition Domain
* Repository Layer
* Dashboard
* HealthKit Integration

Avoid committing after every tiny change.

Avoid combining multiple unrelated features into one commit.

---

# Commit Message Format

Use concise, descriptive messages.

Examples:

```text id="8trv3x"
feat: implement persistence foundation

feat: add nutrition domain models

feat: implement food repository

feat: add dashboard calculations

fix: correct maintenance calorie calculation

refactor: simplify dependency injection

docs: update architecture documentation

test: add persistence unit tests
```

Avoid messages like:

```text id="zxy1f7"
update

changes

working

done

misc
```

---

# Recommended Workflow

1. Implement milestone.
2. Build project.
3. Test functionality.
4. Review code.
5. Commit.
6. Push.

Never commit code that has not been built.

---

# Build Verification

Before every commit:

Run:

```bash id="jvwdyi"
⌘ + B
```

The project should compile successfully.

Compiler warnings should be reviewed.

Errors must be resolved before committing.

---

# Testing Before Commit

Minimum requirement:

* Project builds successfully.

When applicable:

* Unit tests pass.
* Manual testing completed.
* Simulator launches successfully.

Do not spend excessive time debugging simulator issues during implementation.

---

# Reviewing Changes

Before committing:

Review:

```bash id="8z11bn"
git diff
```

Confirm:

* No unrelated files changed.
* No accidental formatting changes.
* No debug code remains.
* No temporary TODOs forgotten.

---

# Files That Should Never Be Committed

Do not commit:

* DerivedData
* Temporary files
* Build artifacts
* Personal configuration files
* Secrets
* API keys
* Local environment files

Ensure `.gitignore` is maintained appropriately.

---

# Pull Before Push

If working across multiple machines:

```bash id="h83m2g"
git pull
```

Resolve conflicts before implementing additional work.

---

# Rollback Strategy

If a milestone introduces problems:

Use Git to revert to the last stable commit.

Avoid making large numbers of uncommitted changes.

Small, focused commits make rollback easy.

---

# Milestone Completion Checklist

Before every commit:

* Architecture respected
* Scope respected
* Project builds
* Tests completed (where applicable)
* Code reviewed
* Documentation updated (if required)
* No unrelated changes

Only then commit.

---

# AI Workflow

## Founder

Owns:

* Git
* Commits
* Pushes
* Repository management

---

## Codex

Responsible for:

* Reading code
* Writing code
* Modifying related files
* Updating tests
* Building the project

Codex must **never** perform Git operations unless explicitly instructed.

---

## CTO (ChatGPT)

Responsible for:

* Architecture
* Code reviews
* Technical decisions
* Engineering guidance

---

# Incident Rule

If unexpected filesystem or Git behavior occurs:

Stop implementation immediately.

Investigate before continuing.

Never assume repository state is correct.

Document the incident and update the engineering workflow if necessary.

---

# Source of Truth

This document defines the official Git workflow for Nutrition OS.

All contributors and AI assistants should follow this workflow to ensure a clean, reliable, and maintainable project history.

