using System;
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
        /// <param name="destinationPath">The path to the repository of processed file</param>
        /// <returns>A concrete log strategy</returns>
        public static BaseLogStrategy CreateStrategy(LogTypes logType, string dataSourcePath, string destinationPath)
        {
            if (string.IsNullOrEmpty(dataSourcePath) || string.IsNullOrEmpty(destinationPath))
            {
                throw new ArgumentNullException("LogStrategyFactory.CreateStrategy: Null//Empty DataSourcePath or DestinationPath parameters supplied!");
            }

            BaseLogStrategy strategy = null;
            switch (logType)
            {
                case LogTypes.SP2013:
                    strategy = CreateSP2013Strategy(dataSourcePath, destinationPath);
                    break;
                case LogTypes.IIS:
                    strategy = CreateIISStrategy(dataSourcePath, destinationPath);
                    break;
                default:
                    break;
            }

            return strategy;
        }

        private static SP2013LogStrategy CreateSP2013Strategy(string dataSourcePath, string destinationPath)
        {
            var archive = new SP2013LogArchive(dataSourcePath);
            return new SP2013LogStrategy(archive, destinationPath);
        }

        private static IISLogStrategy CreateIISStrategy(string dataSourcePath, string destinationPath)
        {
            var archive = new IISLogArchive(dataSourcePath);
            return new IISLogStrategy(archive, destinationPath);
        }
    }
}
