using System.Diagnostics;
using System.Drawing;
using System.Windows.Forms;

namespace NexOverlay;

public class OverlayForm : Form
{
    private readonly Label _statsLabel = new();
    private readonly Timer _timer = new();
    private readonly PerformanceCounter _cpu = new("Processor", "% Processor Time", "_Total");
    private readonly PerformanceCounter _ram = new("Memory", "Available MBytes");

    public OverlayForm()
    {
        FormBorderStyle = FormBorderStyle.None;
        TopMost = true;
        ShowInTaskbar = false;
        StartPosition = FormStartPosition.Manual;
        Location = new Point(24, 24);
        Size = new Size(320, 120);
        BackColor = Color.FromArgb(30, 32, 45);
        Opacity = 0.88;

        _statsLabel.Dock = DockStyle.Fill;
        _statsLabel.ForeColor = Color.FromArgb(170, 255, 190);
        _statsLabel.Font = new Font("Consolas", 11, FontStyle.Bold);
        _statsLabel.Padding = new Padding(12);
        Controls.Add(_statsLabel);

        _timer.Interval = 1000;
        _timer.Tick += (_, _) => UpdateStats();
        _timer.Start();
        UpdateStats();

        DoubleClick += (_, _) => Close();
    }

    private void UpdateStats()
    {
        var cpu = _cpu.NextValue();
        var ram = _ram.NextValue();
        var fpsHint = "FPS: Use RTSS for exact frame counter";
        _statsLabel.Text =
            $"NexOverlay\nCPU: {cpu,5:0.0}%\nRAM Free: {ram,6:0} MB\n{fpsHint}\n{DateTime.Now:HH:mm:ss}";
    }
}
