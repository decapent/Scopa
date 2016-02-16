using Sporacid.Scopa.Contracts;
using Sporacid.Scopa.Entities;
using Sporacid.Scopa.Strategies;

namespace Sporacid.Scopa
{
    public class LogStrategyFactory
    {
        public static ILogStrategy CreateStrategy(LogTypes logType, string rawDataSource)
        {
            ILogStrategy strategy = null;

            switch(logType)
            {
                case LogTypes.SharePoint2013:
                    strategy = CreateSP2013Strategy(rawDataSource);
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

        private static SP2013LogStrategy CreateSP2013Strategy(string rawDataSource)
        {
            var archive = new SharePoint2013LogArchive(rawDataSource);
            return new SP2013LogStrategy(archive, "SP2013_Logs");
        }
    }
}
