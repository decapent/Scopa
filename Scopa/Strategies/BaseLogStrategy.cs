using Sporacid.Scopa.Contracts;
using Sporacid.Scopa.Entities;
using System.Collections.Generic;

namespace Sporacid.Scopa.Strategies
{
    /// <summary>
    /// Abstraction of a lof strategy that implements the ILogStrategy contract
    /// </summary>
    public abstract class BaseLogStrategy : ILogStrategy
    {
        /// <summary>
        /// The log archive definition
        /// </summary>
        public BaseLogArchive LogArchive { get; set; }

        /// <summary>
        /// The path the to directory to copy the processed file
        /// </summary>
        public string DestinationPath { get; set; }

        /// <summary>
        /// The name of the HDFS table
        /// </summary>
        protected string HiveTableName { get; set; }

        /// <summary>
        /// Abstract log strategy
        /// </summary>
        /// <param name="hiveTableName">The Hive table name</param>
        protected BaseLogStrategy (string hiveTableName)
        {
            this.HiveTableName = hiveTableName;
        }

        /// <summary>
        /// Create a local staging directory from the archive path
        /// </summary>
        /// <param name="hiveTableName">The name of the hive table that will be used as staging</param>
        /// <returns>The full path to the local staging directory</returns>
        public abstract string CreateLocalStagingDirectory();

        /// <summary>
        /// 
        /// </summary>
        public abstract void PushToHDFS();

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        protected abstract string EnsureHDFSIndexes(string stagingDirectoryPath, IEnumerable<string> HDFSIndexes);

        /// <summary>
        /// Retrieves the HDFS folder index from the file name
        /// </summary>
        /// <param name="fileName">The name of the log file</param>
        /// <returns>A list of the HDFS indexes</returns>
        protected abstract IEnumerable<string> FetchHDFSIndexesName(string fileName);
    }
}
