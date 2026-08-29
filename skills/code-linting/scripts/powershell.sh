#!/usr/bin/env bash
# shellcheck disable=SC2016
set -euo pipefail

# PowerShell Linter (PSScriptAnalyzer via pwsh)
echo "🔍 Linting PowerShell scripts with PSScriptAnalyzer..."

if ! command -v pwsh >/dev/null 2>&1; then
  echo "⚠️ pwsh (PowerShell Core) is not installed. Install PowerShell 7+ to run linter."
  exit 0
fi

pwsh -NoProfile -NonInteractive -Command '
  if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Warning "PSScriptAnalyzer module not installed. Install with: Install-Module -Name PSScriptAnalyzer -Scope CurrentUser"
    exit 0
  }
  $results = Invoke-ScriptAnalyzer -Path . -Recurse -Severity Warning,Error | Where-Object { $_.ScriptPath -notmatch "(\.git|node_modules)" }
  if ($results) {
    $results | Format-Table -AutoSize
    Write-Error "❌ PSScriptAnalyzer reported $($results.Count) issue(s)."
    exit 1
  } else {
    Write-Host "✓ All PowerShell scripts passed PSScriptAnalyzer."
    exit 0
  }
'
