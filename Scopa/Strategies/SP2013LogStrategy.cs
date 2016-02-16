﻿using Sporacid.Scopa.Contracts;
using Sporacid.Scopa.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Sporacid.Scopa.Strategies
{
    /// <summary>
    /// Concrete strategy for SharePoint 2013 Log files
    /// </summary>
    public class SP2013LogStrategy : ILogStrategy
    {
        public SharePoint2013LogArchive logArchive { get; set; }
        public string DestinationPath { get; set; }

        public SP2013LogStrategy(SharePoint2013LogArchive logArchive, string destinationPath)
        {
            this.logArchive = logArchive;
            this.DestinationPath = destinationPath;
        }

        /// <summary>
        /// Create a local staging directory from the archive path
        /// </summary>
        /// <param name="hiveTableName">The name of the hive table that will be used as staging</param>
        /// <returns>The full path to the local staging directory</returns>
        public string CreateLocalStagingDirectory(string hiveTableName)
        {
            DirectoryInfo stagingDirectory = null;
            var stagingPath = string.Format("{0}\\{1}-staging", this.logArchive.rawDataSource, hiveTableName);

            try
            {
                stagingDirectory = Directory.CreateDirectory(stagingPath);

                // Process files from archive to proper HDFS index-friendly subfolders
                var filesToStage = Directory.EnumerateFiles(this.logArchive.rawDataSource, "*.log", SearchOption.AllDirectories).ToList();
                foreach (var filePath in filesToStage)
                {
                    var fileName = filePath.Substring(filePath.LastIndexOf("\\") + 1);
                    var HDFSIndexes = this.FetchHDFSIndexesName(fileName);

                    if (HDFSIndexes.Count > 0)
                    {
                        var fileDestination = this.EnsureHDFSIndexes(stagingDirectory.FullName, HDFSIndexes);

                        fileDestination = string.Format("{0}\\{1}", fileDestination, fileName);
                        File.Copy(filePath, fileDestination, true);
                        Console.WriteLine("Moved [{0}] to [{1}]", filePath, fileDestination);
                    }
                }
            }
            catch(IOException ioex)
            {
                Console.WriteLine(ioex);
            }

            return stagingDirectory.FullName;
        }

        private string EnsureHDFSIndexes(string stagingDirectoryPath, List<string> HDFSIndexes)
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

        private List<string> FetchHDFSIndexesName(string fileName)
        {
            var HDFSIndexes = new List<string>();
            var segments = fileName.Split('-').ToList();

            // This might need some explaining...
            if (segments.Count >= 2)
            {
                var hostnameSegments = new string[segments.Count - 2];
                for (int i = 0; i < segments.Count - 2; i++)
                {
                    hostnameSegments[i] = segments[i];
                }

                var hostname = string.Format("hostname={0}", string.Join("-", hostnameSegments));
                var logDate = string.Format("logdate={0}", segments[segments.Count - 2]);
                HDFSIndexes.Add(hostname);
                HDFSIndexes.Add(logDate);
            }

            return HDFSIndexes;
        }


        public void PushToHDFS()
        {
            throw new NotImplementedException();
        }
    }
}