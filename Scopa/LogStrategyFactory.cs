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
        public static BaseLogStrategy CreateStrategy(LogTypes logType, string dataSourcePath)
        {
            BaseLogStrategy strategy = null;

            if (!string.IsNullOrEmpty(dataSourcePath))
            {
                switch (logType)
                {
                    case LogTypes.SharePoint2013:
                        strategy = CreateSP2013Strategy(dataSourcePath);
                        break;
                    case LogTypes.IIS:
                        strategy = CreateIISStrategy(dataSourcePath);
                        break;
                    default:
                        break;
                }
            }

            return strategy;
        }

        private static SP2013LogStrategy CreateSP2013Strategy(string dataSourcePath)
        {
            var archive = new SP2013LogArchive(dataSourcePath);
            return new SP2013LogStrategy(archive, "SP2013_Logs");
        }

        private static IISLogStrategy CreateIISStrategy(string dataSourcePath)
        {
            var archive = new IISLogArchive(dataSourcePath);
            return new IISLogStrategy(archive, "IIS_Logs");
        }
    }
}
