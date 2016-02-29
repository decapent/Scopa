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
            var strategy = LogStrategyFactory.CreateStrategy(LogTypes.SharePoint2013, @"C:\Logs\VMSPPLAV_SP2013_20160228012426", @"C:\Processed\SP2013");
            strategy.CreateLocalStagingDirectory();

            strategy = LogStrategyFactory.CreateStrategy(LogTypes.IIS, @"C:\Logs\VMSPPLAV_IIS_20160228012426", @"C:\Processed\IISLogs");
            strategy.CreateLocalStagingDirectory();
                        
            Console.WriteLine("\nDone Processing the files !!!\n");
            Console.ReadKey();
        }
    }
}