using nevarok.PerformanceMonitor.Abstract;

namespace nevarok.PerformanceMonitor.Monitors
{
    /// <summary>
    /// Fallback performance monitor data tracker implementation
    /// </summary>
    public class FallbackPerformanceMonitor : IPerformanceMonitor
    {
        public void StartTracking()
        {
        }

        public IPerformanceData StopTracking() => new PerformanceData();

        public struct PerformanceData : IPerformanceData
        {
            public long CpuCoresCount => 0;
            public double CpuUsagePercents => 0;
            public double MinCpuUsagePercents => 0;
            public double MaxCpuUsagePercents => 0;
            public double MemoryUsageMegabytes => 0;
            public double MinMemoryUsageMegabytes => 0;
            public double MaxMemoryUsageMegabytes => 0;
            public long RendererUtilization => 0;
            public long MinRendererUtilization => 0;
            public long MaxRendererUtilization => 0;
        }
    }
}