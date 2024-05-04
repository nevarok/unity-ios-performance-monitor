using System.Runtime.InteropServices;
using nevarok.PerformanceMonitor.Abstract;

namespace nevarok.PerformanceMonitor.Monitors
{
    /// <summary>
    /// IOS performance monitor data tracker implementation
    /// </summary>
    public class IOSPerformanceMonitor : IPerformanceMonitor
    {
#if !UNITY_EDITOR && UNITY_IOS
        const string DLL_IMPORT = "__Internal";
        
        [DllImport(DLL_IMPORT)]
        static extern void PerformanceMonitorBridge_StartTracking();
        
        [DllImport(DLL_IMPORT, CallingConvention = CallingConvention.Cdecl)]
        static extern PerformanceData PerformanceMonitorBridge_StopTracking();
#else
        static void PerformanceMonitorBridge_StartTracking()
        {
        }

        static PerformanceData PerformanceMonitorBridge_StopTracking() => new();
#endif
        /// <summary>
        /// Starts performance tracking
        /// </summary>
        public void StartTracking() => PerformanceMonitorBridge_StartTracking();

        /// <summary>
        /// Stops performance tracking
        /// </summary>
        /// <returns>Collected since start of tracking performance data</returns>
        public IPerformanceData StopTracking() => PerformanceMonitorBridge_StopTracking();

        [StructLayout(LayoutKind.Sequential)]
        public struct PerformanceData : IPerformanceData
        {
            private const double FACTOR_TO_PERCENTS_MULTIPLIER = 100.0;
            private const double BYTES_TO_MEGABYTES_MULTIPLIER = 1.0 / 1024.0 / 1024.0;

            private long _cpuCoresCount;

            private double _cpuUsage;
            private double _minCpuUsage;
            private double _maxCpuUsage;

            private double _memoryUsage;
            private double _minMemoryUsage;
            private double _maxMemoryUsage;

            private long _inUseSystemMemory;
            private long _allocatedSystemMemory;
            private long _tiledSceneBytes;
            private long _allocatedPBSize;
            private long _tilerUtilization;
            private long _rendererUtilization;
            private long _deviceUtilization;
            private long _splitSceneCount;
            private long _recoveryCount;

            private long _minInUseSystemMemory;
            private long _minAllocatedSystemMemory;
            private long _minTiledSceneBytes;
            private long _minAllocatedPBSize;
            private long _minTilerUtilization;
            private long _minRendererUtilization;
            private long _minDeviceUtilization;
            private long _minSplitSceneCount;
            private long _minRecoveryCount;

            private long _maxInUseSystemMemory;
            private long _maxAllocatedSystemMemory;
            private long _maxTiledSceneBytes;
            private long _maxAllocatedPBSize;
            private long _maxTilerUtilization;
            private long _maxRendererUtilization;
            private long _maxDeviceUtilization;
            private long _maxSplitSceneCount;
            private long _maxRecoveryCount;

            /// <summary>
            /// Number of CPU cores.
            /// </summary>
            public long CpuCoresCount => _cpuCoresCount;

            /// <summary>
            /// Current CPU usage percentage.
            /// </summary>
            public double CpuUsagePercents => _cpuUsage * FACTOR_TO_PERCENTS_MULTIPLIER;

            /// <summary>
            /// Minimum recorded CPU usage percentage.
            /// </summary>
            public double MinCpuUsagePercents => _minCpuUsage * FACTOR_TO_PERCENTS_MULTIPLIER;

            /// <summary>
            /// Maximum recorded CPU usage percentage.
            /// </summary>
            public double MaxCpuUsagePercents => _maxCpuUsage * FACTOR_TO_PERCENTS_MULTIPLIER;

            /// <summary>
            /// Current memory usage in megabytes.
            /// </summary>
            public double MemoryUsageMegabytes => _memoryUsage * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Minimum recorded memory usage in megabytes.
            /// </summary>
            public double MinMemoryUsageMegabytes => _minMemoryUsage * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Maximum recorded memory usage in megabytes.
            /// </summary>
            public double MaxMemoryUsageMegabytes => _maxMemoryUsage * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Amount of system memory currently being used by the GPU driver itself. It reflects the memory that the driver needs to manage GPU resources and operations.
            /// </summary>
            public double InUseSystemMemoryMegabytes => _inUseSystemMemory * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Total amount of system memory allocated for GPU use. This includes memory that may not be currently in use but has been reserved for potential GPU tasks.
            /// </summary>
            public double AllocatedSystemMemoryMegabytes => _allocatedSystemMemory * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Reflects the total size, of all scene data processed using the GPU's tiling method.
            /// </summary>
            public double TiledSceneMegabytes => _tiledSceneBytes * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Allocated Parameter Buffer Size, which is the memory allocated for parameter buffers used by shaders for storing variable values needed during rendering. 
            /// </summary>
            public double AllocatedPbSizeMegabytes => _allocatedPBSize * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Shows how much of the GPU's tiling engine capacity is being used. Tiling is a process that breaks down images into manageable pieces or tiles, which are then processed by the GPU.
            /// </summary>
            public long TilerUtilization => _tilerUtilization;

            /// <summary>
            /// Percentage of time the GPU's rendering units were active. Rendering units are responsible for drawing pixels and processing visual data.
            /// </summary>
            public long RendererUtilization => _rendererUtilization;

            /// <summary>
            /// Percentage reflects the overall utilization of the GPU hardware. It considers all aspects of GPU operations, not just tiling or rendering. 
            /// </summary>
            public long DeviceUtilization => _deviceUtilization;

            /// <summary>
            /// How many times scenes had to be split into smaller segments for processing. Splitting scenes can help in managing rendering workload more efficiently across different GPU units.
            /// </summary>
            public long SplitSceneCount => _splitSceneCount;

            /// <summary>
            /// Number of times the GPU had to recover from errors or other interruptions during operations. A value of 0 means there were no recoveries, which typically suggests stable GPU performance during the measurement period.
            /// </summary>
            public long RecoveryCount => _recoveryCount;

            /// <summary>
            /// Minimum amount of system memory currently being used by the GPU driver itself. It reflects the memory that the driver needs to manage GPU resources and operations.
            /// </summary>
            public double MinInUseSystemMemoryMegabytes => _minInUseSystemMemory * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Minimum amount of system memory allocated for GPU use. This includes memory that may not be currently in use but has been reserved for potential GPU tasks.
            /// </summary>
            public double MinAllocatedSystemMemoryMegabytes =>
                _minAllocatedSystemMemory * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Reflects the minimum, of all scene data processed using the GPU's tiling method.
            /// </summary>
            public double MinTiledSceneMegabytes => _minTiledSceneBytes * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Minimum allocated Parameter Buffer size, which is the memory allocated for parameter buffers used by shaders for storing variable values needed during rendering. 
            /// </summary>
            public double MinAllocatedPbSizeMegabytes => _minAllocatedPBSize * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Shows minimum of the GPU's tiling engine capacity is being used. Tiling is a process that breaks down images into manageable pieces or tiles, which are then processed by the GPU.
            /// </summary>
            public long MinTilerUtilization => _minTilerUtilization;

            /// <summary>
            /// Minimum percentage of GPU's rendering units were active. Rendering units are responsible for drawing pixels and processing visual data.
            /// </summary>
            public long MinRendererUtilization => _minRendererUtilization;

            /// <summary>
            /// Minimum utilization percentage of the GPU hardware. It considers all aspects of GPU operations, not just tiling or rendering. 
            /// </summary>
            public long MinDeviceUtilization => _minDeviceUtilization;

            /// <summary>
            /// Minimum times scenes had to be split into smaller segments for processing. Splitting scenes can help in managing rendering workload more efficiently across different GPU units.
            /// </summary>
            public long MinSplitSceneCount => _minSplitSceneCount;

            /// <summary>
            /// Minimum number of times the GPU had to recover from errors or other interruptions during operations. A value of 0 means there were no recoveries, which typically suggests stable GPU performance during the measurement period.
            /// </summary>
            public long MinRecoveryCount => _minRecoveryCount;

            /// <summary>
            /// Maximum amount of system memory currently being used by the GPU driver itself. It reflects the memory that the driver needs to manage GPU resources and operations.
            /// </summary>
            public double MaxInUseSystemMemoryMegabytes => _maxInUseSystemMemory * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Maximum of system memory allocated for GPU use. This includes memory that may not be currently in use but has been reserved for potential GPU tasks.
            /// </summary>
            public double MaxAllocatedSystemMemoryMegabytes =>
                _maxAllocatedSystemMemory * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Reflects maximum size, of all scene data processed using the GPU's tiling method.
            /// </summary>
            public double MaxTiledSceneMegabytes => _maxTiledSceneBytes * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Maximum allocated Parameter Buffer Size, which is the memory allocated for parameter buffers used by shaders for storing variable values needed during rendering. 
            /// </summary>
            public double MaxAllocatedPbSizeMegabytes => _maxAllocatedPBSize * BYTES_TO_MEGABYTES_MULTIPLIER;

            /// <summary>
            /// Shows maximum of the GPU's tiling engine capacity is being used. Tiling is a process that breaks down images into manageable pieces or tiles, which are then processed by the GPU.
            /// </summary>
            public long MaxTilerUtilization => _maxTilerUtilization;

            /// <summary>
            /// Maximum percentage of time the GPU's rendering units were active. Rendering units are responsible for drawing pixels and processing visual data.
            /// </summary>
            public long MaxRendererUtilization => _maxRendererUtilization;

            /// <summary>
            /// Percentage reflects the maximum utilization of the GPU hardware. It considers all aspects of GPU operations, not just tiling or rendering. 
            /// </summary>
            public long MaxDeviceUtilization => _maxDeviceUtilization;

            /// <summary>
            /// Maximum number of times scenes had to be split into smaller segments for processing. Splitting scenes can help in managing rendering workload more efficiently across different GPU units.
            /// </summary>
            public long MaxSplitSceneCount => _maxSplitSceneCount;

            /// <summary>
            /// Maximum number of times the GPU had to recover from errors or other interruptions during operations. A value of 0 means there were no recoveries, which typically suggests stable GPU performance during the measurement period.
            /// </summary>
            public long MaxRecoveryCount => _maxRecoveryCount;
        }
    }
}