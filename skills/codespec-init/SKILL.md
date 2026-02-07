---
name: codespec-init
description: Use when starting a codespec workflow in a repo and OpenSpec may not be installed, initialized, or have the codespec-workflow schema available
---

# codespec-init (OpenSpec bootstrap)

## Goal

Make the current repo ready for the codespec + OpenSpec workflow:
- OpenSpec CLI is installed (`openspec --version` works)
- `openspec/` structure exists (via `openspec init --tools none`)
- codespec schema + templates exist in this repo (`openspec/schemas/codespec-workflow/`)
- `openspec/config.yaml` exists and points to `codespec-workflow`
- `openspec schema validate codespec-workflow` passes

**Announce at start:** "I'm using the codespec-init skill to bootstrap OpenSpec for this repo."

## Process (idempotent)

1. Ensure OpenSpec CLI is installed
   - Run: `openspec --version`
   - If `openspec` is not found, ask the user if they want to install it globally:
     - Recommended (npm): `npm install -g @fission-ai/openspec@latest`
     - Prereq: Node.js 20.19.0+ (`node --version`)

2. Ensure OpenSpec is initialized in this repo
   - If `openspec/` does not exist, run: `openspec init --tools none`

3. Ensure the codespec workflow schema + templates exist in this repo (no prompting)
   - If `openspec/schemas/codespec-workflow/schema.yaml` does not exist, copy from the installed codespec skills:
     - If the source path below does not exist, stop and reinstall the codespec skills (see `INSTALL.md` in the codespec repo).
     - macOS/Linux (bash/zsh):
       - `mkdir -p openspec/schemas`
       - `cp -R ~/.agents/skills/codespec/codespec-init/assets/openspec/schemas/codespec-workflow openspec/schemas/`
     - Windows (PowerShell):
       - `New-Item -ItemType Directory -Force -Path openspec\\schemas | Out-Null`
       - `Copy-Item -Recurse -Force "$HOME\\.agents\\skills\\codespec\\codespec-init\\assets\\openspec\\schemas\\codespec-workflow" "openspec\\schemas\\"`
   - If `openspec/config.yaml` does not exist, copy it:
     - macOS/Linux (bash/zsh): `cp ~/.agents/skills/codespec/codespec-init/assets/openspec/config.yaml openspec/config.yaml`
     - Windows (PowerShell): `Copy-Item -Force "$HOME\\.agents\\skills\\codespec\\codespec-init\\assets\\openspec\\config.yaml" "openspec\\config.yaml"`

4. Validate
   - Run: `openspec schema validate codespec-workflow`
   - If it fails: stop and fix before continuing any other codespec skill
