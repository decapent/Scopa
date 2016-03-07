using System;
using Sporacid.Scopa.Entities.Enums;

namespace Sporacid.Scopa.Entities
{
    /// <summary>
    /// Abstraction of a log archive
    /// </summary>
    public abstract class BaseLogArchive
    {
        /// <summary>
        /// Instanciate a new log archive with it's type
        /// </summary>
        /// <param name="logType">The type of log to be processed</param>
        public BaseLogArchive(LogTypes logType)
        {
            this.LogType = logType;
        }

        /// <summary>
        /// The type of log
        /// </summary>
        public LogTypes LogType { get; set; }

        /// <summary>
        /// The datasource path containing log files to be processed
        /// </summary>
        public string DataSourcePath { get; set; }

        /// <summary>
        /// Date the raw data was archived
        /// </summary>
        public DateTime ArchiveDate { get; set; }
    }
}
