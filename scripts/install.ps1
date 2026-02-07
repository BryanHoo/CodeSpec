param(
  [switch]$Force
)

$ErrorActionPreference = "Stop"

function Usage {
@"
Usage:
  powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 [-Force]

Installs codespec skills via native skill discovery by creating a junction:
  $HOME\.agents\skills\codespec -> <this-repo>\skills

Options:
  -Force   Replace existing $HOME\.agents\skills\codespec if present
"@
}

if ($args.Count -gt 0) {
  Write-Error "Unknown arguments: $args`n`n$(Usage)"
  exit 2
}

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$SkillsDir = Join-Path $RepoRoot "skills"

if (!(Test-Path -Path $SkillsDir -PathType Container)) {
  Write-Error "skills directory not found: $SkillsDir"
  exit 1
}

$TargetRoot = Join-Path $HOME ".agents\skills"
$TargetLink = Join-Path $TargetRoot "codespec"

New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null

if (Test-Path -LiteralPath $TargetLink) {
  if (-not $Force) {
    Write-Error "Path already exists: $TargetLink`nHint: re-run with -Force to replace it."
    exit 1
  }
  Remove-Item -LiteralPath $TargetLink -Recurse -Force
}

# Use junction to avoid requiring admin / Developer Mode.
$cmd = "mklink /J `"$TargetLink`" `"$SkillsDir`""
$result = cmd /c $cmd
if ($LASTEXITCODE -ne 0) {
  Write-Error "Failed to create junction:`n$result"
  exit $LASTEXITCODE
}

Write-Host "OK: Installed codespec skills"
Write-Host "  $TargetLink -> $SkillsDir"
Write-Host ""
Write-Host "Next:"
Write-Host "  - Restart your AI coding assistant (if it only scans skills at startup)"
Write-Host "  - Verify: dir `"$TargetLink`""
