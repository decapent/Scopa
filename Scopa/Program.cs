using System;
using System.IO;
using Sporacid.Scopa.Entities.Enums;

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
            string rawArchiveRepositoryPath = @"E:\raw";
            string processedArchiveRepositoryPath = @"E:\processed";
            
            // List all the archives to be processed
            var archivesToProcess = Directory.EnumerateDirectories(rawArchiveRepositoryPath);
            foreach (var rawArchive in archivesToProcess)
            {
                // Extract Archive name from path
                var archiveName = rawArchive.Substring(rawArchive.LastIndexOf('\\') + 1);
                
                // Build needed parameters for Strategy Factory
                var logType = ParseEnum<LogTypes>(archiveName.Split('_')[1]);
                var sourcePath = string.Format("{0}\\{1}", rawArchiveRepositoryPath, archiveName);
                var destinationPath = string.Format("{0}\\{1}", processedArchiveRepositoryPath, logType.ToString());

                // Instantiate the strategy
                var strategy = LogStrategyFactory.CreateStrategy(logType, sourcePath, destinationPath);

                // Process the archive
                strategy.CreateLocalStagingDirectory();
            }    

            Console.WriteLine("\nDone Processing the files !!!\n");
            Console.ReadKey();
        }

        private static T ParseEnum<T>(string value)
        {
            return (T)Enum.Parse(typeof(T), value, true);
        }
    }
}