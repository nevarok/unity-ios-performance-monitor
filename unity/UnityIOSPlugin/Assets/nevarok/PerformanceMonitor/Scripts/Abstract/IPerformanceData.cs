namespace nevarok.PerformanceMonitor.Abstract
{
    /// <summary>
    /// Performance data structure interface
    /// </summary>
    public interface IPerformanceData
    {
        /// <summary>
        /// Number of CPU cores.
        /// </summary>
        public long CpuCoresCount { get; }

        /// <summary>
        /// Current CPU usage percentage.
        /// </summary>
        public double CpuUsagePercents { get; }

        /// <summary>
        /// Minimum recorded CPU usage percentage.
        /// </summary>
        public double MinCpuUsagePercents { get; }

        /// <summary>
        /// Maximum recorded CPU usage percentage.
        /// </summary>
        public double MaxCpuUsagePercents { get; }

        /// <summary>
        /// Current memory usage in megabytes.
        /// </summary>
        public double MemoryUsageMegabytes { get; }

        /// <summary>
        /// Minimum recorded memory usage in megabytes.
        /// </summary>
        public double MinMemoryUsageMegabytes { get; }

        /// <summary>
        /// Maximum recorded memory usage in megabytes.
        /// </summary>
        public double MaxMemoryUsageMegabytes { get; }

        //// <summary>
        /// Percentage of time the GPU's rendering units were active. Rendering units are responsible for drawing pixels and processing visual data.
        /// </summary>
        public long RendererUtilization { get; }

        //// <summary>
        /// Minimum percentage of time the GPU's rendering units were active. Rendering units are responsible for drawing pixels and processing visual data.
        /// </summary>
        public long MinRendererUtilization { get; }

        //// <summary>
        /// Maximum percentage of time the GPU's rendering units were active. Rendering units are responsible for drawing pixels and processing visual data.
        /// </summary>
        public long MaxRendererUtilization { get; }
    }
}