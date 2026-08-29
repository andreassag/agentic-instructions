#!/usr/bin/env bash
# shellcheck disable=SC2016
set -euo pipefail

# PowerShell Test Runner (Pester via pwsh)
echo "🧪 Running PowerShell test suite..."

if ! command -v pwsh >/dev/null 2>&1; then
  echo "⚠️ pwsh (PowerShell Core) is not installed. Install PowerShell 7+ to run tests."
  exit 0
fi

pwsh -NoProfile -NonInteractive -Command '
  if (-not (Get-Module -ListAvailable -Name Pester)) {
    Write-Warning "Pester module not installed. Install with: Install-Module -Name Pester -Scope CurrentUser"
    exit 0
  }
  $pesterConfig = New-PesterConfiguration
  $pesterConfig.Run.PassThru = $true
  $pesterConfig.Output.Verbosity = "Detailed"
  $result = Invoke-Pester -Configuration $pesterConfig
  if ($result.FailedCount -gt 0) {
    Write-Error "❌ Pester tests failed: $($result.FailedCount) test(s) failed."
    exit 1
  } else {
    Write-Host "✓ All Pester tests passed ($($result.PassedCount) passed)."
    exit 0
  }
'
