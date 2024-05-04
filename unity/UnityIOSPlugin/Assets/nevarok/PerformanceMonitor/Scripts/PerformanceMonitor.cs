using nevarok.PerformanceMonitor.Abstract;
using nevarok.PerformanceMonitor.Monitors;

namespace nevarok.PerformanceMonitor
{
    /// <summary>
    /// Performance tracking service class
    /// </summary>
    public static class PerformanceMonitor
    {
        static readonly IPerformanceMonitor _monitor;

        static PerformanceMonitor()
        {
#if (UNITY_EDITOR && UNITY_IOS) || UNITY_IOS
            _monitor = new IOSPerformanceMonitor();
#else
            _monitor = new FallbackPerformanceMonitor();
#endif
        }

        /// <summary>
        /// Starts performance tracking
        /// </summary>
        public static void StartTracking() => _monitor.StartTracking();

        /// <summary>
        /// Stops performance tracking
        /// </summary>
        /// <returns>Collected since start of tracking performance data</returns>
        public static IPerformanceData StopTracking() => _monitor.StopTracking();
    }
}