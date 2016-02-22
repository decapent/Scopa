using Sporacid.Scopa.Contracts;
using Sporacid.Scopa.Entities;
using Sporacid.Scopa.Strategies;

namespace Sporacid.Scopa
{
    /// <summary>
    /// Factory of concrete ILogStrategy object.
    /// </summary>
    public static class LogStrategyFactory
    {
        /// <summary>
        /// Create a new ILogStrategy
        /// </summary>
        /// <param name="logType">The type of log to create</param>
        /// <param name="dataSourcePath">The path to the repository of unprocessed file</param>
        /// <returns>A concrete log strategy</returns>
        public static ILogStrategy CreateStrategy(LogTypes logType, string dataSourcePath)
        {
            ILogStrategy strategy = null;

            switch (logType)
            {
                case LogTypes.SharePoint2013:
                    strategy = CreateSP2013Strategy(dataSourcePath);
                    break;
                case LogTypes.IIS:
                    break;
                case LogTypes.Twitter:
                    break;
                default:
                    break;
            }

            return strategy;
        }

        private static SP2013LogStrategy CreateSP2013Strategy(string dataSourcePath)
        {
            var archive = new SharePoint2013LogArchive(dataSourcePath);
            return new SP2013LogStrategy(archive, "SP2013_Logs");
        }
    }
}
