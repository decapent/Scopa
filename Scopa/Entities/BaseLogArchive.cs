using System;

namespace Sporacid.Scopa.Entities
{
    public abstract class BaseLogArchive
    {
        public LogTypes LogType { get; set; }
        public string rawDataSource { get; set; }
        public DateTime ArchiveDate { get; set; }

        public BaseLogArchive(LogTypes logType)
        {
            this.LogType = logType;
        }
    }
}
