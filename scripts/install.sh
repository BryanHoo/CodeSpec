#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/install.sh [--force] [--path <skills-root>]

Installs codespec skills via native skill discovery by symlinking:
  ~/.agents/skills/codespec -> <this-repo>/skills
If --path is provided, also creates:
  <skills-root>/codespec -> <this-repo>/skills

Options:
  --force   Replace existing ~/.agents/skills/codespec if present
  --path    Skills root directory. Creates <skills-root>/codespec symlink.
            Default: ~/.agents/skills
EOF
}

force=0
target_root="${HOME}/.agents/skills"

expand_path() {
  local p="$1"
  if [[ "$p" == "~" ]]; then
    echo "$HOME"
  elif [[ "$p" == "~/"* ]]; then
    echo "$HOME/${p#~/}"
  else
    echo "$p"
  fi
}

while [[ $# -gt 0 ]]; do
  case "${1:-}" in
    --force)
      force=1
      shift
      ;;
    --path)
      if [[ $# -lt 2 ]]; then
        echo "ERROR: Missing value for --path" >&2
        usage >&2
        exit 2
      fi
      target_root="$(expand_path "$2")"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unknown argument: ${1:-}" >&2
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

agents_root="${HOME}/.agents/skills"

mkdir -p "$target_root"
mkdir -p "$agents_root"

target_root="$(cd "$target_root" && pwd)"
agents_root="$(cd "$agents_root" && pwd)"

target_link="${target_root}/codespec"
agents_link="${agents_root}/codespec"

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

install_link() {
  local link_path="$1"
  local desired_target="$2"

  if [[ -e "$link_path" || -L "$link_path" ]]; then
    if [[ -L "$link_path" ]]; then
      local existing_target
      existing_target="$(resolve_symlink_target "$link_path")"
      if [[ "$existing_target" == "$desired_target" ]]; then
        echo "OK: codespec skills already installed at: $link_path"
        return 0
      fi
    fi

    if [[ "$force" -ne 1 ]]; then
      echo "ERROR: Path already exists: $link_path" >&2
      echo "Hint: re-run with --force to replace it." >&2
      exit 1
    fi

    rm -rf "$link_path"
  fi

  ln -s "$skills_dir" "$link_path"
  echo "OK: Installed codespec skills"
  echo "  $link_path -> $skills_dir"
}

desired_target="$(cd "$skills_dir" && pwd)"

install_link "$target_link" "$desired_target"
if [[ "$agents_link" != "$target_link" ]]; then
  install_link "$agents_link" "$desired_target"
fi

echo
echo "Next:"
echo "  - Restart your AI coding assistant (if it only scans skills at startup)"
echo "  - Verify: ls -la \"$target_link\""
if [[ "$agents_link" != "$target_link" ]]; then
  echo "  - Also installed: ls -la \"$agents_link\""
fi
