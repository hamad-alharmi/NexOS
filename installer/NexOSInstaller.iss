; NexOS Installer (Inno Setup)

[Setup]
AppName=NexOS Environment
AppVersion=0.1.0
DefaultDirName={autopf}\NexOS
DefaultGroupName=NexOS
OutputBaseFilename=NexOS-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64
UninstallDisplayIcon={app}\ui\NexShell\NexShellPrototype.exe

[Types]
Name: "lite"; Description: "Lite Install"
Name: "full"; Description: "Full Install"

[Components]
Name: "core"; Description: "Core performance scripts and presets"; Types: lite full; Flags: fixed
Name: "shell"; Description: "NexShell prototype UI"; Types: full
Name: "tools"; Description: "CLI tools"; Types: lite full
Name: "jre"; Description: "Temurin JRE bundle (.jar support)"; Types: full

[Files]
Source: "..\scripts\*"; DestDir: "{app}\scripts"; Flags: recursesubdirs
Source: "..\configs\*"; DestDir: "{app}\configs"; Flags: recursesubdirs
Source: "..\tools\*"; DestDir: "{app}\tools"; Flags: recursesubdirs
Source: "..\themes\*"; DestDir: "{app}\themes"; Flags: recursesubdirs
Source: "..\registry\*"; DestDir: "{app}\registry"; Flags: recursesubdirs
Source: "..\sdk\*"; DestDir: "{app}\sdk"; Flags: recursesubdirs
Source: "..\artifacts\publish\NexShell\*"; DestDir: "{app}\ui\NexShell"; Flags: recursesubdirs; Components: shell

[Icons]
Name: "{group}\NexShell"; Filename: "{app}\ui\NexShell\NexShellPrototype.exe"; Components: shell
Name: "{group}\NexOS CLI"; Filename: "powershell.exe"; Parameters: "-NoExit -ExecutionPolicy Bypass -File ""{app}\tools\nexctl.ps1"" -Command optimize"; Components: tools
Name: "{group}\Uninstall NexOS"; Filename: "{uninstallexe}"

[Run]
Filename: "powershell.exe"; \
Parameters: "-ExecutionPolicy Bypass -File ""{app}\scripts\install\Install-NexOS.ps1"" -InstallRoot ""{app}"" -Preset GamingMode"; \
StatusMsg: "Applying NexOS profile and performance layer..."; \
Flags: runhidden

[UninstallRun]
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\scripts\install\Uninstall-NexOS.ps1"" -InstallRoot ""{app}"""; Flags: runhidden
