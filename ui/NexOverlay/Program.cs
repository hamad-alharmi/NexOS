using System.Diagnostics;
using System.Windows.Forms;

namespace NexOverlay;

internal static class Program
{
    [STAThread]
    static void Main()
    {
        ApplicationConfiguration.Initialize();
        Application.Run(new OverlayForm());
    }
}
