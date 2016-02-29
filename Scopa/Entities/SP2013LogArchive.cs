using System;

namespace Sporacid.Scopa.Entities
{
    /// <summary>
    /// A SharePoint2013 repository of unprocessed log files.
    /// </summary>
    public class SP2013LogArchive : BaseLogArchive
    {
        /// <summary>
        /// Create a new instance of a SharePoint2013LogArchive
        /// </summary>
        /// <param name="DataSourcePath">Path to repository of unprocesssed SP2013 log file</param>
        public SP2013LogArchive(string DataSourcePath)
            : base(LogTypes.SharePoint2013)
        {
            this.DataSourcePath = DataSourcePath;
            this.ArchiveDate = DateTime.Now;
        }
    }
}
