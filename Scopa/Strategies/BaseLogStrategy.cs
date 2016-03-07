using System.Collections.Generic;
using Sporacid.Scopa.Contracts;
using Sporacid.Scopa.Entities;

namespace Sporacid.Scopa.Strategies
{
    /// <summary>
    /// Abstraction of a log strategy entity that implements the ILogStrategy contract
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
        protected string HiveTableName { get; private set; }

        /// <summary>
        /// Abstract log strategy
        /// </summary>
        /// <param name="hiveTableName">The Hive table name</param>
        protected BaseLogStrategy(string hiveTableName)
        {
            this.HiveTableName = hiveTableName;
        }

        /// <summary>
        /// Create a local staging directory from the archive path
        /// </summary>
        /// <returns>The full path to the local staging directory</returns>
        public abstract string CreateLocalStagingDirectory();

        /// <summary>
        /// Upload processed archive to HDFS to be indexed by Hive.
        /// </summary>
        public abstract void PushToHDFS();

        /// <summary>
        /// Retrieves the HDFS folder index from the file name
        /// </summary>
        /// <param name="fileName">The name of the log file</param>
        /// <returns>An ordered list of the HDFS indexes</returns>
        protected abstract IEnumerable<string> FetchHDFSIndexesName(string fileName);

        /// <summary>
        /// Ensure the staging folder indexes as directories
        /// </summary>
        /// <param name="stagingDirectoryPath">The staging directory disk path</param>
        /// <param name="HDFSIndexes">An ordered list of the indexes to ensure</param>
        /// <returns>The fully qualified path to copy the log file being processed</returns>
        protected abstract string EnsureHDFSIndexes(string stagingDirectoryPath, IEnumerable<string> HDFSIndexes);
    }
}
