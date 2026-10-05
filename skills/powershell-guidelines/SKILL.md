---
name: powershell-guidelines
description: PowerShell technical guidelines, strict error handling ($ErrorActionPreference = 'Stop'), CmdletBinding, and module architecture.
when_to_use: "When working with files matching: *.ps1,**/*.ps1,*.psm1,**/*.psm1,*.psd1,**/*.psd1"
trigger: glob
globs: "*.ps1,**/*.ps1,*.psm1,**/*.psm1,*.psd1,**/*.psd1"
version: 1.0.0
---

# PowerShell Technical Guidelines

## Safety, Strict Modes & Error Discipline
1. Begin script files and modules with `Set-StrictMode -Version Latest` and `$ErrorActionPreference = 'Stop'` to fail fast on unset variables and runtime errors.
2. In PowerShell 7.4+, enable `$PSNativeCommandUseErrorActionPreference = $true` so non-zero native CLI exit codes throw terminating errors.
3. Catch specific exception types with `try { ... } catch [System.IO.IOException] { ... } catch { ... }` instead of bare catch-all blocks.
4. Clean up disposable resources with `try { ... } finally { ... }` or by invoking `.Dispose()` on objects implementing `IDisposable`.
5. Never execute unverified code strings with `Invoke-Expression` (`iex`); use script blocks `& $scriptBlock` or splatting with `& $cmd @params`.

## Cmdlet & Advanced Function Best Practices
6. Always decorate custom functions with `[CmdletBinding()]` to support common parameters (`-Verbose`, `-Debug`, `-ErrorAction`, `-WhatIf`, `-Confirm`).
7. Declare typed parameters in explicit `param(...)` blocks with validation attributes (`[Parameter(Mandatory, ValueFromPipeline)]`, `[ValidateNotNullOrEmpty()]`, `[ValidateSet(...)]`).
8. Implement pipeline-aware functions with explicit `begin {}`, `process {}`, and `end {}` blocks; execute per-item logic inside `process {}`.
9. Specify `[OutputType([TypeName])]` on all public/exported functions to document expected return types.
10. Adhere to the standard `Verb-Noun` naming convention using approved PowerShell verbs (`Get-Verb`); use `PascalCase` for cmdlets, parameters, and public properties.

## Pipeline, Objects & Output Idioms
11. Output structured objects via `[PSCustomObject]@{ ... }` or typed classes to the pipeline — never emit formatted plain text for downstream consumption.
12. Use the standard information streams correctly:
    - Pipeline / Data output: `Write-Output` or implicit expression return
    - Diagnostic logging: `Write-Verbose` and `Write-Debug`
    - Alerts & Errors: `Write-Warning` and `Write-Error`
    - Never use `Write-Host` for programmatic function return values.
13. Leverage parameter splatting (`$params = @{ Path = $p; Force = $true }; Remove-Item @params`) to keep function calls readable and avoid long wrapped lines.

## Module Architecture & Manifests
14. Structure reusable modules into root module files (`.psm1`) paired with valid manifests (`.psd1`) generated via `New-ModuleManifest`.
15. Explicitly declare `FunctionsToExport`, `CmdletsToExport`, and `AliasesToExport` in the manifest; avoid exporting wildcards (`*`).
16. Organize non-trivial modules into `Public/` (exported functions) and `Private/` (internal helpers) directories, dot-sourcing them in the `.psm1`.

## Code Style, Linting & Testing
17. Format code following PowerShell Community standards (4 spaces indentation, opening braces on the same line (OTBS), full cmdlet names instead of aliases in scripts).
18. Lint code with `PSScriptAnalyzer` (`Invoke-ScriptAnalyzer -Path . -Recurse -Severity Warning,Error`); CI must enforce zero analyzer errors.
19. Write automated unit and integration tests using `Pester` (v5+ syntax with `Describe`, `Context`, `It`, and `Should` assertions).
20. Target cross-platform PowerShell 7+ Core compatibility; use `Join-Path` or `[System.IO.Path]::Combine` for path manipulation rather than hardcoded backslashes or slashes.
