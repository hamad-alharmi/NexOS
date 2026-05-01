using Microsoft.UI.Xaml;
using System;

namespace NexShellPrototype;

public static class Program
{
    [STAThread]
    public static void Main(string[] args)
    {
        Application.Start((p) => new App());
    }
}
