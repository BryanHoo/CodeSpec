---
name: codespec-brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Preflight (OpenSpec required):**
- Run `openspec --version`
- Run `openspec schema validate codespec-workflow`
- If either fails: **REQUIRED SUB-SKILL:** use `codespec-init`, then re-run the checks

**Understanding the idea:**
- Check out the current project state first (files, docs, recent commits)
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the design:**
- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## After the Design

**Documentation:**
- OpenSpec (required):
  0. Ensure OpenSpec bootstrap is complete:
     - Run `openspec --version`
     - Run `openspec schema validate codespec-workflow`
     - If either fails: **REQUIRED SUB-SKILL:** use `codespec-init`, then re-run the checks
  1. Resolve an OpenSpec change name (kebab-case). If the user didn't provide one, propose one and confirm.
  2. Create (or reuse) the change:
     - Ensure schema exists: `openspec schema validate codespec-workflow`
     - `openspec new change <change-name> --schema codespec-workflow`
  3. Scaffold missing artifacts using OpenSpec CLI instructions (do not invent structure):
     - Prefer `--json` and use the returned `changeDir` + `outputPath` + `template` to create the file skeleton.
     - `openspec instructions proposal --change <change-name> --json` → create `openspec/changes/<change-name>/proposal.md` from `template` if missing
     - `openspec instructions specs --change <change-name> --json` → use `template` as the starting point for each capability spec at `openspec/changes/<change-name>/specs/<capability>/spec.md`
     - `openspec instructions design --change <change-name> --json` → create `openspec/changes/<change-name>/design.md` from `template` if missing
     - `openspec instructions tasks --change <change-name> --json` → create `openspec/changes/<change-name>/tasks.md` from `template` if missing (leave detailed plan content for codespec-writing-plans)
  4. Write the validated content:
     - Requirements intent + capability contract → `openspec/changes/<change-name>/proposal.md`
     - Delta requirements + `#### Scenario:` acceptance cases → `openspec/changes/<change-name>/specs/**/spec.md`
     - Technical design decisions → `openspec/changes/<change-name>/design.md`
- Use elements-of-style:writing-clearly-and-concisely skill if available
- Commit the design document to git

**Implementation (if continuing):**
- **MUST** Ask: "Ready to set up for implementation?"
- Use codespec-using-git-worktrees to create isolated workspace
- Use codespec-writing-plans to create the detailed implementation plan in `openspec/changes/<change-name>/tasks.md` (OpenSpec required)

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
