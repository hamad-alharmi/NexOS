# NexOS Architecture

## 1) Base Layer (Windows Distribution)

- Built from official Microsoft Windows image.
- Customized via NTLite profiles and unattended setup scripts.
- No kernel modifications; all compatibility remains native.

## 2) Performance Layer

- PowerShell automation package for runtime tuning.
- Profile-based toggles:
  - `Gaming`
  - `Minimal`
  - `Aesthetic`
- Optional third-party integrations:
  - Process Lasso
  - RTSS for OSD/overlay

## 3) UX Layer

- `NexShell` companion app first, full shell replacement optional.
- WinUI-based launcher/taskbar with acrylic effects.
- Plugin host for widgets and quick actions.

## 4) Control Layer

- Central config and preset manager.
- Service/task manager with explicit user consent model.
- Process transparency panel listing active background modules.

## 5) Installer and Update Layer

- Feature-selective installer (Lite/Full/custom).
- Applies preset at install completion.
- Update channel model:
  - `stable`
  - `preview`

## 6) Developer Layer

- CLI (`nexctl`) for:
  - profile apply
  - service toggle
  - diagnostics
- GitHub-based theme and plugin distribution.

## Data Flow

1. User selects preset or toggles feature.
2. Config engine validates policy and permissions.
3. Performance/UI modules apply changes.
4. Monitoring module records resource impact for transparency.
