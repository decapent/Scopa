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
        /// <param name="hiveTableName">The name of the hive table that will be used as staging</param>
        /// <returns>The full path to the local staging directory</returns>
        string CreateLocalStagingDirectory(string hiveTableName);

        void PushToHDFS();
    }
}
