# NexOS Distribution

NexOS is a **full distributable Windows customization project** focused on performance, modern UX, privacy, and extensibility.

## What ships

- Native Windows base customization model (no custom kernel).
- Full `.exe` compatibility through stock Windows runtime model.
- `.jar` support via bundled Java runtime installer path.
- Performance layer:
  - idle optimizer
  - reversible Game Mode
  - diagnostics exporter
  - lightweight in-game overlay app (`NexOverlay`)
- UI layer:
  - WinUI `NexShell` app (publishable)
  - `NexOS-OneClick.exe` single-exe workflow controller
- Distribution layer:
  - build/package/release scripts
  - Inno Setup installer project
  - checksummed zip artifacts
  - CI workflow for automated packaging
  - optional obfuscation pipeline (`Confuser.CLI`)

## Build a distributable

1. Build and validate:
   - `.\scripts\build\Build-NexOS.ps1 -Clean`
2. Package release zip + checksum:
   - `.\scripts\build\Package-NexOS.ps1`
3. Full release pipeline in one command:
   - `.\scripts\build\Release-NexOS.ps1`
4. Sync project + installer version before tagging:
   - `.\tools\nexctl.ps1 -Command sync-version -Arg 0.1.1`
5. Optional obfuscation pass:
   - `.\tools\nexctl.ps1 -Command obfuscate`

Output:
- `dist\NexOS-<version>-win64.zip`
- `dist\NexOS-<version>-win64.sha256`

Inside package:
- `NexOS-OneClick.exe` (easy entrypoint)
- `ui\NexShell\NexShellPrototype.exe`
- `ui\NexOverlay\NexOverlay.exe`

## Install / Uninstall

- Install:
  - `.\scripts\install\Install-NexOS.ps1 -Preset GamingMode`
- Uninstall:
  - `.\scripts\install\Uninstall-NexOS.ps1`

## CLI

Use `tools\nexctl.ps1`:

- Apply preset: `-Command preset -Arg GamingMode`
- Toggle game mode: `-Command gamemode -Arg Enable`
- Optimize idle: `-Command optimize`
- Restore defaults: `-Command restore`
- Launch overlay (after build): `-Command overlay`
- Launch one-click UI (after build): `-Command oneclick`
- Obfuscate binaries (optional): `-Command obfuscate`

## Project structure

- `scripts/build/` - distributable build/package/release
- `scripts/install/` - install/uninstall/runtime provisioning
- `scripts/performance/` - optimization and game mode
- `scripts/ops/` - diagnostics and operations
- `scripts/qa/` - smoke tests
- `configs/presets/` - preset engine
- `ui/NexShellPrototype/` - WinUI shell app
- `installer/` - Inno Setup installer project
- `registry/` - plugin/theme registry indexes
- `themes/` - shipped themes
- `sdk/` - extension API contract
- `.github/workflows/` - CI pipeline

## Safety

- Run as Administrator where required.
- Validate in VM before bare-metal use.
- Keep restore point/system image for rollback.

## GitHub Releases

- Create tag in format `vX.Y.Z` (example: `v0.1.0`).
- Tag push triggers `.github/workflows/release.yml`.
- Workflow publishes `dist/*.zip` and `dist/*.sha256` as GitHub Release assets.
