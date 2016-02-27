using System;
using Sporacid.Scopa.Entities;

namespace Sporacid.Scopa
{
    /// <summary>
    /// Program class that encapsulates Main program thread
    /// </summary>
    public class Program
    {
        /// <summary>
        /// The Main program
        /// </summary>
        /// <param name="args">The supplied arguments</param>
        public static void Main(string[] args)
        {
            var strategy = LogStrategyFactory.CreateStrategy(LogTypes.SharePoint2013, @"C:\Logs\SP2013Logs");
            strategy.CreateLocalStagingDirectory("SP2013_Logs");

            strategy = LogStrategyFactory.CreateStrategy(LogTypes.IIS, @"C:\Logs\IISLogs");
            strategy.CreateLocalStagingDirectory("IIS_Logs");
            
            Console.ReadKey();
        }
    }
}