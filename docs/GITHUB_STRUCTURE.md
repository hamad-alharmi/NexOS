# GitHub Repository Structure

## Recommended Repositories

1. `nexos-core`
   - Base scripts, presets, installer definitions, docs.
2. `nexos-shell`
   - Shell UI code and related modules.
3. `nexos-plugins`
   - Official plugin pack examples.
4. `nexos-themes`
   - Theme packs, icons, animation profiles.
5. `nexos-cli`
   - `nexctl` and diagnostics tooling.

## Branch Strategy

- `main` - stable release branch.
- `develop` - integration branch.
- `feature/*` - short-lived feature branches.
- `release/*` - release prep and hardening.

## CI/CD

- Build and sign shell artifacts.
- Lint and test PowerShell scripts.
- Package installer artifact per tag.
- Publish release notes and checksums.

## Distribution Model

- Signed release assets on GitHub Releases.
- Optional in-app updater checks against GitHub API.
- Theme/plugin manifests versioned and checksummed.
