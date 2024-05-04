# Performance Monitor

Optimize and track your Unity iOS application's performance metrics using Performance Monitor. It's designed to give developers a comprehensive view of their iOS app's CPU, GPU, and RAM usage in real-time.

## Caution
**Important**: This plugin utilizes IOKit for gathering system performance data, which is not permitted for use in apps distributed through the App Store. As such, the Performance Monitor is intended solely for performance debugging and optimization purposes during development. **Do not include this library in your production builds intended for App Store submission**.

## Prerequisites

Tested on:
- **Xcode**: Version 15.3
- **iOS**: iOS 17.4
- **Unity**: 2022.3.26f1 LTS

## Installation

1. **Download** the `PerformanceMonitor.unitypackage` from the [GitHub releases section](https://github.com/nevarok/unity-ios-performance-monitor/releases).
2. **Import** the package into your Unity project via `Assets > Import Package > Custom Package`.

## Quick Start Guide

<div align="center">
  <a href="ttps://youtu.be/a0vYPUdTbSY"><img src="http://img.youtube.com/vi/a0vYPUdTbSY/0.jpg" alt="Unity iOS Performance Monitor Showcase"></a>
</div>

### Setup the Monitor
To integrate the Performance Monitor into your scene, follow these steps:

```csharp
// Include the necessary namespaces
using nevarok.PerformanceMonitor;
using nevarok.PerformanceMonitor.Abstract;
using nevarok.PerformanceMonitor.Monitors;
```

### Start Monitoring
Place the following code where you want to begin collecting performance data, such as in the Start method of a MonoBehaviour script:

```csharp
// Start collecting performance data
PerformanceMonitor.StartTracking();
```

### Stop Monitoring and Retrieve Data
To stop monitoring and process the collected data, use:

```csharp
// Stop tracking and retrieve the performance data
var performanceData = PerformanceMonitor.StopTracking();
```

### Displaying Data
After stopping the monitor, you can display or process the retrieved data. Here's a simple way to log the CPU and memory usage:

```csharp
// Output the CPU and memory usage to the console
Debug.Log($"CPU Usage: {performanceData.CpuUsagePercents}%");
Debug.Log($"Memory Usage: {performanceData.MemoryUsageMegabytes} MB");
```

### PerformanceData API
The `IOSPerformanceMonitor.PerformanceData` struct provides detailed metrics about the performance of your iOS device during runtime. Below are the descriptions of each field within `IOSPerformanceMonitor.PerformanceData`:


- `CpuCoresCount`: The number of CPU cores available on the device.
- `CpuUsagePercents`: The current CPU usage as a percentage of total capacity.
- `MinCpuUsagePercents`: The minimum CPU usage recorded since tracking began.
- `MaxCpuUsagePercents`: The maximum CPU usage recorded since tracking began.
- `MemoryUsageMegabytes`: The current RAM usage in megabytes.
- `MinMemoryUsageMegabytes`: The minimum RAM usage recorded since tracking began.
- `MaxMemoryUsageMegabytes`: The maximum RAM usage recorded since tracking began.
- `InUseSystemMemoryMegabytes`: The amount of system memory currently being used by the GPU driver, in megabytes.
- `AllocatedSystemMemoryMegabytes`: The total amount of system memory allocated for GPU use, in megabytes.
- `TiledSceneMegabytes`: The size of all scene data processed using the GPU's tiling method, in megabytes.
- `AllocatedPbSizeMegabytes`: The memory allocated for parameter buffers used by shaders during rendering, in megabytes.
- `TilerUtilization`: The percentage of the GPU's tiler engine capacity being used.
- `RendererUtilization`: The percentage of time the GPU's rendering units were active.
- `DeviceUtilization`: The overall utilization percentage of the GPU hardware.
- `SplitSceneCount`: The number of times scenes were split into smaller segments for processing.
- `RecoveryCount`: The number of times the GPU had to recover from errors or other interruptions.


Each metric provides insights that can help developers identify performance bottlenecks and optimize their applications accordingly.

### Examples and Further Guidance
Check the `SampleScene` in the `nevarok/PerformanceMonitor/Scenes/` folder and review the `DemoPerformanceMonitor.cs` script for details. 

### Support and Contributions
Encounter an issue or have a suggestion? Visit please visit [GitHub Issues page](https://github.com/nevarok/unity-ios-performance-monitor/issues) to get help or contribute. Your feedback helps improve the plugin!

