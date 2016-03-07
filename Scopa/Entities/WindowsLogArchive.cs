using System;
using Sporacid.Scopa.Entities.Enums;

namespace Sporacid.Scopa.Entities
{
    /// <summary>
    /// A Windows repository of unprocessed log files.
    /// </summary>
    public class WindowsLogArchive : BaseLogArchive
    {
        /// <summary>
        /// The windows event type that was retrieved
        /// </summary>
        public WindowsEventTypes EventType { get; set; }

        /// <summary>
        /// Create a new instance of a Windows event Log Archive
        /// </summary>
        /// <param name="eventType">The windows event type of the archive</param>
        /// <param name="dataSourcePath">Path to repository of unprocesssed Windows event log files</param>
        public WindowsLogArchive(WindowsEventTypes eventType, string dataSourcePath)
            : base(LogTypes.Windows)
        {
            this.EventType = eventType;
            this.DataSourcePath = dataSourcePath;
            this.ArchiveDate = DateTime.Now;
        }
    }
}