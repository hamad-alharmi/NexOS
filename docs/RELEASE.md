# NexOS Release Process

## 1. Pre-release validation

- Run `.\scripts\qa\Smoke-Test.ps1`
- Build `NexShell` with `.\scripts\build\Build-NexOS.ps1 -Clean`
- Validate Game Mode enable/disable on a staging machine
- Validate `.jar` launch post Java install

## 2. Produce artifacts

- Sync version metadata:
  - `.\tools\nexctl.ps1 -Command sync-version -Arg X.Y.Z`
- `.\scripts\build\Release-NexOS.ps1`
- Verify generated checksum in `dist\*.sha256`

## 3. Build installer

- Compile `installer\NexOSInstaller.iss` with Inno Setup 6
- Test install, preset apply, shell launch, uninstall restore

## 4. Publish

- Tag release version in git matching `VERSION` as `vX.Y.Z`
- Upload:
  - zip artifact
  - sha256 file
  - installer exe
- Publish release notes with known issues and rollback steps

## 5. GitHub Actions release automation

- Pushing tag `vX.Y.Z` runs `.github/workflows/release.yml`.
- The workflow runs smoke tests, builds, packages, and creates a GitHub Release with generated notes and attached artifacts.
