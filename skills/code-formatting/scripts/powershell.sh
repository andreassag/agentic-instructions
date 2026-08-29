#!/usr/bin/env bash
# shellcheck disable=SC2016
set -euo pipefail

# PowerShell Formatter (PSScriptAnalyzer via pwsh)
echo "✨ Formatting PowerShell scripts..."

if command -v pwsh >/dev/null 2>&1; then
  pwsh -NoProfile -NonInteractive -Command '
    if (Get-Module -ListAvailable -Name PSScriptAnalyzer) {
      Get-ChildItem -Path . -Include *.ps1,*.psm1,*.psd1 -Recurse -File | Where-Object { $_.FullName -notmatch "(\.git|node_modules)" } | ForEach-Object {
        Invoke-Formatter -ScriptDefinition (Get-Content -Raw -Path $_.FullName) | Set-Content -Path $_.FullName
      }
      Write-Host "✓ Formatted PowerShell files."
    } else {
      Write-Warning "PSScriptAnalyzer module not installed. Install with: Install-Module -Name PSScriptAnalyzer -Scope CurrentUser"
    }
  '
else
  echo "⚠️ pwsh (PowerShell Core) not installed. Install PowerShell 7+ to format scripts."
fi
