namespace Sporacid.Scopa.Entities.Enums
{
    /// <summary>
    /// Supported log types.
    /// </summary>
    public enum LogTypes
    {
        IIS,
        SP2013,
        Windows
    }

    /// <summary>
    /// Supported Windows event type
    /// </summary>
    public enum WindowsEventTypes
    {
        Application,
        Security,
        Setup,
        System
    }
}