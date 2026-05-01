# NexOS Implementation Plan

## Phase 1 - Minimal Viable Debloated System

### Objectives

- Produce a stable, reproducible customized Windows image.
- Remove non-essential components without breaking compatibility.
- Preserve full `.exe` runtime compatibility and gaming stack.
- Bundle Java runtime for `.jar` execution.

### Steps

1. **Base OS Selection**
   - Target Windows 11 Pro/Enterprise (latest stable ISO).
   - Keep edition matrix simple in MVP (single base image).
2. **NTLite Profile Creation**
   - Remove consumer apps and ad components.
   - Disable telemetry and data collection features by default.
   - Keep:
     - Windows Update core
     - .NET runtime
     - DirectX and graphics stack
     - Audio stack
     - Core networking
3. **Driver and Runtime Policy**
   - Retain default PnP driver pipeline.
   - Include Java Runtime (Temurin LTS) in installer flow.
4. **Validation Matrix**
   - Boot stability, driver install, audio/network, game launch.
   - Validate common launchers: Steam, EA App, Epic, Battle.net.

### Exit Criteria

- Image installs cleanly.
- Idle resource usage lower than stock baseline.
- Launchers and top test games run normally.

---

## Phase 2 - Performance Optimization Layer

### Objectives

- Improve FPS consistency and reduce frame-time spikes.
- Lower input latency and background scheduling overhead.
- Offer one-click Game Mode and safe rollback.

### Steps

1. **Scripted Tuning Layer**
   - Add scripts to:
     - Disable noisy background services/tasks during gaming
     - Set High Performance power profile
     - Tune timer and multimedia priorities where safe
2. **Game Mode Toggle**
   - `GameMode.ps1 -Enable/-Disable` entrypoint.
   - Store state to support clean restore.
3. **Optional Process Lasso**
   - If installed, apply per-game CPU affinity/priority templates.
4. **Monitoring Hooks**
   - Lightweight counters and on-demand diagnostics.

### Exit Criteria

- One-click enable/disable works reliably.
- No persistent breakage after restore.
- Measurable reduction in background CPU usage.

---

## Phase 3 - UI Overhaul

### Objectives

- Replace stock interaction model with modern shell UX.
- Keep smooth GPU-accelerated animations and low overhead.

### Steps

1. **Shell Strategy**
   - Start as shell companion app (MVP), then optional full shell replacement.
2. **Core Components**
   - Taskbar-like quick launcher
   - Search/launcher palette
   - Workspace and app switcher
   - Acrylic/blur/transparency visuals
3. **Tech Stack**
   - WinUI 3 (primary, native modern Windows stack).
   - Optional Qt shell if multi-platform UI engine is needed.
4. **Performance Constraints**
   - Keep shell idle CPU near 0%.
   - Offload animation to composition/GPU pipeline.

### Exit Criteria

- Shell prototype launches and controls apps.
- Visual layer remains smooth under gaming/background load.

---

## Phase 4 - Advanced Features and Ecosystem

### Objectives

- Deliver high control and extensibility.
- Support community plugins/themes with safe updates.

### Steps

1. **Customization Engine**
   - JSON-driven presets and live reload.
   - Theme packs (colors/icons/animations).
2. **Plugin SDK**
   - Versioned API boundary.
   - Permission manifest for plugin capabilities.
3. **Installer Experience**
   - Lite vs Full installs with feature toggles.
   - Apply optimization profile during install.
4. **GitHub Integration**
   - Themes/plugins registry
   - CLI update channels
   - Release notes and signed artifacts

### Exit Criteria

- End users can install presets and plugins safely.
- Developers can build modules with clear docs and tooling.
