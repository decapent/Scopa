using Sporacid.Scopa.Entities;
using System;

namespace Sporacid.Scopa
{
    class Program
    {
        static void Main(string[] args)
        {
            var strategy = LogStrategyFactory.CreateStrategy(LogTypes.SharePoint2013, @"C:\Logs\SP2013Logs");
            strategy.CreateLocalStagingDirectory("SP2013_Logs");
            


            Console.ReadKey();
        }
    }
}
