using System.Diagnostics;
using System.Drawing;
using System.Windows.Forms;

namespace NexOSOneClick;

public class OneClickForm : Form
{
    private readonly Label _status = new();
    private readonly ComboBox _preset = new();

    public OneClickForm()
    {
        Text = "NexOS OneClick";
        StartPosition = FormStartPosition.CenterScreen;
        Size = new Size(620, 430);
        BackColor = Color.FromArgb(16, 20, 30);
        ForeColor = Color.White;

        var panel = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            Padding = new Padding(16),
            AutoScroll = true,
            FlowDirection = FlowDirection.TopDown,
            WrapContents = false
        };
        Controls.Add(panel);

        panel.Controls.Add(NewTitle("NexOS OneClick Control"));

        _preset.Items.AddRange(new object[] { "GamingMode", "MinimalMode", "AestheticMode" });
        _preset.SelectedIndex = 0;
        _preset.DropDownStyle = ComboBoxStyle.DropDownList;
        _preset.Width = 220;
        panel.Controls.Add(_preset);

        panel.Controls.Add(NewButton("Install (Skip Java)", () =>
            RunPs(@".\scripts\install\Install-NexOS.ps1", $"-Preset {_preset.Text} -SkipJava", true)));
        panel.Controls.Add(NewButton("Apply Preset", () =>
            RunPs(@".\scripts\install\Apply-NexOSProfile.ps1", $"-Preset {_preset.Text} -SkipJava", true)));
        panel.Controls.Add(NewButton("Enable Game Mode", () =>
            RunPs(@".\scripts\performance\GameMode.ps1", "-Mode Enable", true)));
        panel.Controls.Add(NewButton("Disable Game Mode", () =>
            RunPs(@".\scripts\performance\GameMode.ps1", "-Mode Disable", true)));
        panel.Controls.Add(NewButton("Optimize Idle", () =>
            RunPs(@".\scripts\performance\Optimize-Idle.ps1", "", true)));
        panel.Controls.Add(NewButton("Start Overlay", StartOverlay));
        panel.Controls.Add(NewButton("Launch NexShell", LaunchShell));
        panel.Controls.Add(NewButton("Export Diagnostics", () =>
            RunPs(@".\scripts\ops\Export-Diagnostics.ps1", "", true)));

        _status.AutoSize = true;
        _status.Padding = new Padding(0, 12, 0, 0);
        _status.ForeColor = Color.FromArgb(150, 240, 170);
        _status.Text = "Status: Ready";
        panel.Controls.Add(_status);
    }

    private Control NewTitle(string text) =>
        new Label
        {
            Text = text,
            AutoSize = true,
            Font = new Font("Segoe UI", 16, FontStyle.Bold),
            Padding = new Padding(0, 0, 0, 12)
        };

    private Button NewButton(string text, Action action)
    {
        var button = new Button
        {
            Text = text,
            Width = 280,
            Height = 36,
            FlatStyle = FlatStyle.Flat,
            BackColor = Color.FromArgb(39, 60, 92),
            ForeColor = Color.White
        };
        button.Click += (_, _) =>
        {
            try
            {
                action();
                SetStatus($"{text} launched");
            }
            catch (Exception ex)
            {
                SetStatus($"Error: {ex.Message}");
            }
        };
        return button;
    }

    private void SetStatus(string text) => _status.Text = $"Status: {text}";

    private static string BaseDir => AppContext.BaseDirectory;

    private void RunPs(string relativeScript, string args, bool elevate)
    {
        var script = Path.GetFullPath(Path.Combine(BaseDir, relativeScript));
        var psi = new ProcessStartInfo
        {
            FileName = "powershell.exe",
            Arguments = $"-ExecutionPolicy Bypass -File \"{script}\" {args}",
            UseShellExecute = true,
            Verb = elevate ? "runas" : ""
        };
        Process.Start(psi);
    }

    private void StartOverlay()
    {
        var exe = Path.GetFullPath(Path.Combine(BaseDir, @"ui\NexOverlay\NexOverlay.exe"));
        if (!File.Exists(exe))
        {
            throw new FileNotFoundException("Overlay exe not found", exe);
        }
        Process.Start(new ProcessStartInfo { FileName = exe, UseShellExecute = true });
    }

    private void LaunchShell()
    {
        var exe = Path.GetFullPath(Path.Combine(BaseDir, @"ui\NexShell\NexShellPrototype.exe"));
        if (!File.Exists(exe))
        {
            throw new FileNotFoundException("NexShell exe not found", exe);
        }
        Process.Start(new ProcessStartInfo { FileName = exe, UseShellExecute = true });
    }
}
