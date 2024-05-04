namespace nevarok.PerformanceMonitor.Abstract
{
    /// <summary>
    /// Performance monitor interface
    /// </summary>
    public interface IPerformanceMonitor
    {
        /// <summary>
        /// Starts performance tracking
        /// </summary>
        void StartTracking();

        /// <summary>
        /// Stops performance tracking
        /// </summary>
        /// <returns>Collected since start of tracking performance data</returns>
        IPerformanceData StopTracking();
    }
}