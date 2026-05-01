using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Input;
using System;
using System.Diagnostics;
using System.IO;
using Microsoft.UI.Dispatching;

namespace NexShellPrototype;

public sealed partial class MainWindow : Window
{
    private readonly DispatcherTimer _clockTimer = new();

    public MainWindow()
    {
        this.InitializeComponent();
        InitializeClock();
    }

    private static string RepoRoot =>
        Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", ".."));

    private static void RunPowerShell(string scriptRelativePath, string args)
    {
        var fullScript = Path.Combine(RepoRoot, scriptRelativePath);
        var psi = new ProcessStartInfo
        {
            FileName = "powershell.exe",
            Arguments = $"-ExecutionPolicy Bypass -File \"{fullScript}\" {args}",
            UseShellExecute = false,
            CreateNoWindow = true
        };
        Process.Start(psi);
    }

    private void InitializeClock()
    {
        UpdateClock();
        _clockTimer.Interval = TimeSpan.FromSeconds(1);
        _clockTimer.Tick += (_, _) => UpdateClock();
        _clockTimer.Start();
    }

    private void UpdateClock()
    {
        var now = DateTime.Now;
        ClockText.Text = now.ToString("HH:mm:ss");
        DateText.Text = now.ToString("yyyy-MM-dd");
    }

    private void SetStatus(string text)
    {
        StatusText.Text = $"Status: {text}";
    }

    private void EnableGameMode_Click(object sender, RoutedEventArgs e)
    {
        RunPowerShell(@"scripts\performance\GameMode.ps1", "-Mode Enable");
        SetStatus("Game Mode requested");
    }

    private void DisableGameMode_Click(object sender, RoutedEventArgs e)
    {
        RunPowerShell(@"scripts\performance\GameMode.ps1", "-Mode Disable");
        SetStatus("Game Mode restore requested");
    }

    private void OpenPresets_Click(object sender, RoutedEventArgs e)
    {
        Process.Start(new ProcessStartInfo
        {
            FileName = "explorer.exe",
            Arguments = Path.Combine(RepoRoot, "configs", "presets"),
            UseShellExecute = true
        });
        SetStatus("Opened presets folder");
    }

    private static void LaunchIfExists(string path, string? fallbackUri = null)
    {
        if (File.Exists(path))
        {
            Process.Start(new ProcessStartInfo { FileName = path, UseShellExecute = true });
            return;
        }

        if (!string.IsNullOrWhiteSpace(fallbackUri))
        {
            Process.Start(new ProcessStartInfo { FileName = fallbackUri, UseShellExecute = true });
        }
    }

    private void OpenSteam_Click(object sender, RoutedEventArgs e) =>
        LaunchIfExists(@"C:\Program Files (x86)\Steam\Steam.exe", "steam://open/main");

    private void OpenEpic_Click(object sender, RoutedEventArgs e) =>
        LaunchIfExists(@"C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe");

    private void OpenBattleNet_Click(object sender, RoutedEventArgs e) =>
        LaunchIfExists(@"C:\Program Files (x86)\Battle.net\Battle.net Launcher.exe");

    private void OpenSettings_Click(object sender, RoutedEventArgs e)
    {
        Process.Start(new ProcessStartInfo
        {
            FileName = "ms-settings:",
            UseShellExecute = true
        });
        SetStatus("Opened Windows settings");
    }

    private void OptimizeIdle_Click(object sender, RoutedEventArgs e)
    {
        RunPowerShell(@"scripts\performance\Optimize-Idle.ps1", "");
        SetStatus("Idle optimization requested");
    }

    private void ApplyPreset_Click(object sender, RoutedEventArgs e)
    {
        if (PresetComboBox.SelectedItem is ComboBoxItem item && item.Content is string preset)
        {
            RunPowerShell(@"scripts\install\Apply-NexOSProfile.ps1", $"-Preset {preset}");
            SetStatus($"Preset apply requested: {preset}");
        }
    }

    private void ExportDiagnostics_Click(object sender, RoutedEventArgs e)
    {
        RunPowerShell(@"scripts\ops\Export-Diagnostics.ps1", "");
        SetStatus("Diagnostics export requested");
    }

    private void QuickLaunch_Click(object sender, RoutedEventArgs e) => LaunchFromInput();

    private void QuickLaunchTextBox_KeyDown(object sender, KeyRoutedEventArgs e)
    {
        if (e.Key == Windows.System.VirtualKey.Enter)
        {
            LaunchFromInput();
        }
    }

    private void LaunchFromInput()
    {
        var input = QuickLaunchTextBox.Text?.Trim();
        if (string.IsNullOrWhiteSpace(input))
        {
            SetStatus("Quick launch input is empty");
            return;
        }

        try
        {
            Process.Start(new ProcessStartInfo
            {
                FileName = input,
                UseShellExecute = true
            });
            SetStatus($"Launched: {input}");
        }
        catch (Exception ex)
        {
            SetStatus($"Launch failed: {ex.Message}");
        }
    }

    private void OpenGitHub_Click(object sender, RoutedEventArgs e)
    {
        Process.Start(new ProcessStartInfo
        {
            FileName = "https://github.com",
            UseShellExecute = true
        });
        SetStatus("Opened GitHub");
    }
}
