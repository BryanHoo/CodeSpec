#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/install.sh [--force]

Installs codespec skills via native skill discovery by symlinking:
  ~/.agents/skills/codespec -> <this-repo>/skills

Options:
  --force   Replace existing ~/.agents/skills/codespec if present
EOF
}

force=0
for arg in "${@:-}"; do
  case "$arg" in
    --force) force=1 ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "ERROR: Unknown argument: $arg" >&2
      usage >&2
      exit 2
      ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="${repo_root}/skills"

if [[ ! -d "$skills_dir" ]]; then
  echo "ERROR: skills directory not found: $skills_dir" >&2
  exit 1
fi

target_root="${HOME}/.agents/skills"
target_link="${target_root}/codespec"

mkdir -p "$target_root"

resolve_symlink_target() {
  local link_path="$1"
  local link_target
  link_target="$(readlink "$link_path")"
  if [[ "$link_target" != /* ]]; then
    (cd "$(dirname "$link_path")" && cd "$link_target" && pwd)
  else
    (cd "$link_target" && pwd)
  fi
}

if [[ -e "$target_link" || -L "$target_link" ]]; then
  if [[ -L "$target_link" ]]; then
    existing_target="$(resolve_symlink_target "$target_link")"
    desired_target="$(cd "$skills_dir" && pwd)"
    if [[ "$existing_target" == "$desired_target" ]]; then
      echo "OK: codespec skills already installed at: $target_link"
      exit 0
    fi
  fi

  if [[ "$force" -ne 1 ]]; then
    echo "ERROR: Path already exists: $target_link" >&2
    echo "Hint: re-run with --force to replace it." >&2
    exit 1
  fi

  rm -rf "$target_link"
fi

ln -s "$skills_dir" "$target_link"

echo "OK: Installed codespec skills"
echo "  $target_link -> $skills_dir"
echo
echo "Next:"
echo "  - Restart your AI coding assistant (if it only scans skills at startup)"
echo "  - Verify: ls -la \"$target_link\""
