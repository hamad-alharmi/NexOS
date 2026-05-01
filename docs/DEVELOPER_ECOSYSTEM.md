# Developer Ecosystem

## Extension Points

- `plugins/` runtime modules (future API).
- `configs/presets/` user-tunable JSON profiles.
- `themes/` style packs for shell visuals.

## Plugin Contract (Draft)

Each plugin ships:

- `manifest.json`
  - id, version, author
  - required permissions (process-list, service-control, overlay)
  - min `nexos` API version
- `plugin.dll` or executable entrypoint
- optional settings schema

## CLI Surface (Draft)

- `nexctl preset <name>`
- `nexctl gamemode Enable|Disable`
- `nexctl optimize`
- `nexctl restore`
- `nexctl diag`

## Documentation Deliverables

- SDK guide for plugin lifecycle.
- Theming guide (tokens, color system, icon slots).
- Security model and permission prompts.
- Compatibility list for tested games and anti-cheat systems.
