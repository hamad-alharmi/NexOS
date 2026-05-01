# NexOS Plugin API (v0.1 Draft)

## Manifest

Each plugin must provide `manifest.json`:

```json
{
  "id": "vendor.plugin-id",
  "name": "Human Name",
  "version": "0.1.0",
  "entry": "PluginAssembly.dll",
  "minApiVersion": "0.1.0",
  "permissions": ["process-read", "overlay"]
}
```

## Permissions

- `process-read`: read process list and stats
- `service-control`: start/stop approved services
- `overlay`: render in-game overlay widgets
- `shell-widget`: add desktop/taskbar widgets

## Lifecycle

1. Host loads manifest.
2. Host validates API version and permission grants.
3. Plugin entrypoint starts.
4. Plugin receives config and event bus.

## Security

- Plugins run opt-in only.
- Permission prompts are explicit.
- Unsigned plugins are blocked by default in stable channel.
