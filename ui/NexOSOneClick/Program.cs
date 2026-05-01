using System.Windows.Forms;

namespace NexOSOneClick;

internal static class Program
{
    [STAThread]
    static void Main()
    {
        ApplicationConfiguration.Initialize();
        Application.Run(new OneClickForm());
    }
}
