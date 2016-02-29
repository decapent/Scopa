using System;

namespace Sporacid.Scopa.Entities
{
    /// <summary>
    /// A SharePoint2013 repository of unprocessed log files.
    /// </summary>
    public class IISLogArchive : BaseLogArchive
    {
        /// <summary>
        /// Create a new instance of a SharePoint2013LogArchive
        /// </summary>
        /// <param name="DataSourcePath">Path to repository of unprocesssed SP2013 log file</param>
        public IISLogArchive(string DataSourcePath)
            : base(LogTypes.IIS)
        {
            this.DataSourcePath = DataSourcePath;
            this.ArchiveDate = DateTime.Now;
        }
    }
}
