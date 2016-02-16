using System;

namespace Sporacid.Scopa.Entities
{
    public class SharePoint2013LogArchive : BaseLogArchive
    {
        public SharePoint2013LogArchive(string rawDataSource)
            :base(LogTypes.SharePoint2013)
        {
            this.rawDataSource = rawDataSource;
            this.ArchiveDate = DateTime.Now;
        }
    }
}
