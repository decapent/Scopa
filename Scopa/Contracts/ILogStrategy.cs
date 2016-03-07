namespace Sporacid.Scopa.Contracts
{
    /// <summary>
    /// Abstraction of a logging strategy
    /// </summary>
    public interface ILogStrategy
    {
        /// <summary>
        /// Create a local staging directory from the archive path
        /// </summary>
        /// <returns>The full path to the local staging directory</returns>
        string CreateLocalStagingDirectory();

        /// <summary>
        /// Upload processed archive to HDFS to be indexed by Hive.
        /// </summary>
        void PushToHDFS();
    }
}
