using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sporacid.Scopa.Entities
{
    /// <summary>
    /// 
    /// </summary>
    public class WindowsLogArchive : BaseLogArchive
    {
        /// <summary>
        /// Create a new instance of a SharePoint2013LogArchive
        /// </summary>
        /// <param name="DataSourcePath">Path to repository of unprocesssed SP2013 log file</param>
        public WindowsLogArchive(string DataSourcePath)
            : base(LogTypes.Windows)
        {
            this.DataSourcePath = DataSourcePath;
            this.ArchiveDate = DateTime.Now;
        }
    }
}
