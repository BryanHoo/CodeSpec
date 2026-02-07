param(
  [switch]$Force,
  [string]$Path
)

$ErrorActionPreference = "Stop"

function Usage {
@"
Usage:
  powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 [-Force] [-Path <skills-root>]

Installs codespec skills via native skill discovery by creating a junction:
  $HOME\.agents\skills\codespec -> <this-repo>\skills
If -Path is provided, also creates:
  <skills-root>\codespec -> <this-repo>\skills

Options:
  -Force   Replace existing junction(s) if present
  -Path    Skills root directory. Creates <skills-root>\codespec junction.
           Default: $HOME\.agents\skills
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

$AgentsRoot = Join-Path $HOME ".agents\skills"

if ([string]::IsNullOrWhiteSpace($Path)) {
  $TargetRoot = $AgentsRoot
} else {
  $TargetRoot = $Path
}

New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null
New-Item -ItemType Directory -Force -Path $AgentsRoot | Out-Null

$TargetRoot = (Resolve-Path -Path $TargetRoot).Path
$AgentsRoot = (Resolve-Path -Path $AgentsRoot).Path

$TargetLink = Join-Path $TargetRoot "codespec"
$AgentsLink = Join-Path $AgentsRoot "codespec"

function Install-Junction([string]$LinkPath, [string]$TargetPath) {
  if (Test-Path -LiteralPath $LinkPath) {
    if (-not $Force) {
      Write-Error "Path already exists: $LinkPath`nHint: re-run with -Force to replace it."
      exit 1
    }
    Remove-Item -LiteralPath $LinkPath -Recurse -Force
  }

  # Use junction to avoid requiring admin / Developer Mode.
  $cmd = "mklink /J `"$LinkPath`" `"$TargetPath`""
  $result = cmd /c $cmd
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create junction:`n$result"
    exit $LASTEXITCODE
  }

  Write-Host "OK: Installed codespec skills"
  Write-Host "  $LinkPath -> $TargetPath"
}

Install-Junction -LinkPath $TargetLink -TargetPath $SkillsDir
if ($AgentsLink -ne $TargetLink) {
  Install-Junction -LinkPath $AgentsLink -TargetPath $SkillsDir
}

Write-Host ""
Write-Host "Next:"
Write-Host "  - Restart your AI coding assistant (if it only scans skills at startup)"
Write-Host "  - Verify: dir `"$TargetLink`""
if ($AgentsLink -ne $TargetLink) {
  Write-Host "  - Also installed: dir `"$AgentsLink`""
}
