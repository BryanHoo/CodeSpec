---
name: codespec-writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:**
- `openspec/changes/<change-name>/tasks.md` (so plan + progress stay with the change)

**With OpenSpec (way 2) required rules:**
- Use `- [ ]` checkboxes for trackable progress (OpenSpec tracks `tasks.md`)
- Derive tasks from `openspec/changes/<change-name>/specs/**/spec.md` scenarios
- Each scenario MUST expand to 5 TDD steps: RED → VERIFY_RED → GREEN → VERIFY_GREEN → REFACTOR

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## OpenSpec Planning Steps (required)

0. Ensure OpenSpec bootstrap is complete:
   - Run `openspec --version`
   - Run `openspec schema validate codespec-workflow`
   - If either fails: **REQUIRED SUB-SKILL:** use `codespec-init`, then re-run the checks
1. Resolve `<change-name>`:
   - If the user provided a change name, use it.
   - Otherwise, run `openspec list --json` and:
     - If exactly one active change exists, use it
     - If multiple exist, ask which change to plan for
     - If no active changes exist, stop and go back to `codespec-brainstorming` to create a change + planning artifacts
2. Confirm prerequisites are ready:
   - Run `openspec status --change <change-name> --json`
   - Expected: `specs` is `done`, `design` is `done`, and `tasks` is `ready` (or already `done`)
   - If `tasks` is `blocked` (or `specs`/`design` are not `done`), DO NOT write a plan yet:
     - Switch back to `codespec-brainstorming`
     - Complete the missing artifacts in `openspec/changes/<change-name>/` (typically `proposal.md`, `specs/**/spec.md`, `design.md`)
     - Re-run `openspec status --change <change-name>` until `tasks` becomes `ready`
3. Scaffold `tasks.md` skeleton (no manual copy/paste):
   - Run `openspec instructions tasks --change <change-name> --json`
   - If `openspec/changes/<change-name>/tasks.md` is missing or empty, write the returned `template` to that file
4. Fill `tasks.md` as a detailed implementation plan:
   - For each `#### Scenario:` in `openspec/changes/<change-name>/specs/**/spec.md`, add 5 checkbox steps:
     - `[TDD][RED]` write failing test
     - `[TDD][VERIFY_RED]` run and confirm correct failure
     - `[TDD][GREEN]` minimal production code
     - `[TDD][VERIFY_GREEN]` run and confirm pass
     - `[TDD][REFACTOR]` refactor (keep green)
   - Every VERIFY step MUST include `Run:` and `Expected:` lines with exact commands and expected output.

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `openspec/changes/<change-name>/tasks.md`. Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use codespec-subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session in worktree
- **REQUIRED SUB-SKILL:** New session uses codespec-executing-plans
