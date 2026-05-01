using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Timer = System.Windows.Forms.Timer;

namespace NexOverlay
{
    public class OverlayForm : Form
    {
        private Timer _timer = new Timer();
        private int _tickCount = 0;

        public OverlayForm()
        {
            // No InitializeComponent()

            SetupWindow();
            SetupTimer();
        }

        private void SetupWindow()
        {
            this.FormBorderStyle = FormBorderStyle.None;
            this.TopMost = true;
            this.ShowInTaskbar = false;

            this.BackColor = Color.Black;
            this.TransparencyKey = Color.Black; // makes background invisible

            this.Bounds = Screen.PrimaryScreen.Bounds;

            EnableClickThrough();
        }

        private void SetupTimer()
        {
            _timer.Interval = 16; // ~60 FPS update loop
            _timer.Tick += TimerTick;
            _timer.Start();
        }

        private void TimerTick(object? sender, EventArgs e)
        {
            _tickCount++;
            this.Invalidate(); // triggers repaint
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);

            var g = e.Graphics;

            using var font = new Font("Segoe UI", 16, FontStyle.Bold);
            using var brush = new SolidBrush(Color.Lime);

            g.DrawString($"NexOverlay | Ticks: {_tickCount}", font, brush, 20, 20);
        }

        // 🔥 Click-through overlay (so it doesn’t block the game)
        private void EnableClickThrough()
        {
            int initialStyle = GetWindowLong(this.Handle, GWL_EXSTYLE);
            SetWindowLong(this.Handle, GWL_EXSTYLE,
                initialStyle | WS_EX_LAYERED | WS_EX_TRANSPARENT);
        }

        private const int GWL_EXSTYLE = -20;
        private const int WS_EX_LAYERED = 0x80000;
        private const int WS_EX_TRANSPARENT = 0x20;

        [DllImport("user32.dll")]
        private static extern int GetWindowLong(IntPtr hwnd, int index);

        [DllImport("user32.dll")]
        private static extern int SetWindowLong(IntPtr hwnd, int index, int newStyle);
    }
}
