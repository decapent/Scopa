using Sporacid.Scopa.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Sporacid.Scopa.Strategies
{
    /// <summary>
    /// Concrete strategy for SharePoint 2013 Log files processing. 
    /// </summary>
    public class SP2013LogStrategy : BaseLogStrategy
    {
        /// <summary>
        /// Create a new SP2013LogStrategy
        /// </summary>
        /// <param name="logArchive">The SP2013 Log Archive</param>
        /// <param name="destinationPath">The destination path</param>
        public SP2013LogStrategy(SP2013LogArchive logArchive, string destinationPath)
            : base("SP2013_Logs")
        {
            this.LogArchive = logArchive;
            this.DestinationPath = destinationPath;
        }

        /// <summary>
        /// Create a local staging directory from the archive path
        /// </summary>
        /// <param name="hiveTableName">The name of the hive table that will be used as staging</param>
        /// <returns>The full path to the local staging directory</returns>
        public override string CreateLocalStagingDirectory()
        {
            DirectoryInfo stagingDirectory = null;
            var stagingPath = string.Format("{0}\\{1}-staging", this.LogArchive.DataSourcePath, this.HiveTableName);

            try
            {
                stagingDirectory = Directory.CreateDirectory(stagingPath);

                // Process files from archive to proper HDFS index-friendly subfolders
                var filesToStage = Directory.EnumerateFiles(this.LogArchive.DataSourcePath, "*.log", SearchOption.AllDirectories).ToList();
                foreach (var filePath in filesToStage)
                {
                    var fileName = filePath.Substring(filePath.LastIndexOf("\\") + 1);
                    var HDFSIndexes = this.FetchHDFSIndexesName(fileName);

                    if (HDFSIndexes.ToList().Count > 0)
                    {
                        var fileDestination = this.EnsureHDFSIndexes(stagingDirectory.FullName, HDFSIndexes);

                        if(!Directory.Exists(this.DestinationPath))
                        {
                            Directory.CreateDirectory(this.DestinationPath);
                        }

                        var source = Path.Combine(this.LogArchive.DataSourcePath, fileName);
                        var destination = Path.Combine(this.DestinationPath, fileName);

                        File.Copy(source, destination, true);
                        Console.WriteLine("Moved [{0}] to [{1}]", source, destination);
                    }
                }
            }
            catch (IOException ioex)
            {
                Console.WriteLine(string.Format("SP2013LogStrategy.CreateLocalStaging --> {0}", ioex));
            }

            return stagingDirectory.FullName;
        }

        /// <summary>
        /// Push some files to HDFS
        /// </summary>
        public override void PushToHDFS()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stagingDirectoryPath"></param>
        /// <param name="HDFSIndexes"></param>
        /// <returns></returns>
        protected override string EnsureHDFSIndexes(string stagingDirectoryPath, IEnumerable<string> HDFSIndexes)
        {
            var fullIndexPath = stagingDirectoryPath;
            foreach (var index in HDFSIndexes)
            {
                fullIndexPath = string.Format("{0}\\{1}", fullIndexPath, index);
                if (!Directory.Exists(fullIndexPath))
                {
                    Directory.CreateDirectory(fullIndexPath);
                }
            }

            return fullIndexPath;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        protected override IEnumerable<string> FetchHDFSIndexesName(string fileName)
        {
            var HDFSIndexes = new List<string>();

            // Hostname can be extracted directly from the archive file name
            // since file name is following HOSTNAME_LOGTYPE_TIMESTAMP nomenclature
            var hostName = this.LogArchive.DataSourcePath.Substring(this.LogArchive.DataSourcePath.LastIndexOf("\\") + 1).Split('_')[0];

            // logdate can be obtained from the file directly as the second last information
            var fileNameSegments = fileName.Split('_').ToList();
            if (fileNameSegments.Count > 2)
            {
                var logDate = fileNameSegments[fileNameSegments.Count - 2];

                // Build the index and add it to the HDFS Index list
                hostName = string.Format("hostname={0}", hostName);
                logDate = string.Format("logdate={0}", logDate);
                HDFSIndexes.Add(hostName);
                HDFSIndexes.Add(logDate);
            }

            return HDFSIndexes;
        }
    }
}