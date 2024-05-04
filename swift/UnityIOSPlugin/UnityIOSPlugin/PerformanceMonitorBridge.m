//
//  PerformanceMonitorBridge.m
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/4/29.
//

#include "PerformanceMonitorBridge.h"

#import <Foundation/Foundation.h>
#import "UnityIOSPlugin-Swift.h"

static PerformanceMonitor *monitor = nil;
static PerformanceDataStruct cachedData = (PerformanceDataStruct){};

void InitMonitor(void)
{
    monitor = [[PerformanceMonitor alloc] init];
}

void PerformanceMonitorBridge_StartTracking(void)
{
    if (!monitor)
    {
        InitMonitor();
    }

    [monitor startTracking];
}

PerformanceDataStruct PerformanceMonitorBridge_StopTracking(void)
{
    if (!monitor)
    {
        InitMonitor();
    }
    
    MonitorData *data = [monitor stopTracking];
    
    cachedData.cpuCoresCount = data.cpuCoresCount;
    cachedData.cpuUsage = data.cpuUsage;
    cachedData.minCpuUsage = data.minCpuUsage;
    cachedData.maxCpuUsage = data.maxCpuUsage;
    cachedData.memoryUsage = data.memoryUsage;
    cachedData.minMemoryUsage = data.minMemoryUsage;
    cachedData.maxMemoryUsage = data.maxMemoryUsage;
    
    cachedData.inUseSystemMemory = data.inUseSystemMemory;
    cachedData.allocatedSystemMemory = data.allocatedSystemMemory;
    cachedData.tiledSceneBytes = data.tiledSceneBytes;
    cachedData.allocatedPBSize = data.allocatedPBSize;
    cachedData.tilerUtilization = data.tilerUtilization;
    cachedData.rendererUtilization = data.rendererUtilization;
    cachedData.deviceUtilization = data.deviceUtilization;
    cachedData.splitSceneCount = data.splitSceneCount;
    cachedData.recoveryCount = data.recoveryCount;
    
    cachedData.minInUseSystemMemory = data.minInUseSystemMemory;
    cachedData.minAllocatedSystemMemory = data.minAllocatedSystemMemory;
    cachedData.minTiledSceneBytes = data.minTiledSceneBytes;
    cachedData.minAllocatedPBSize = data.minAllocatedPBSize;
    cachedData.minTilerUtilization = data.minTilerUtilization;
    cachedData.minRendererUtilization = data.minRendererUtilization;
    cachedData.minDeviceUtilization = data.minDeviceUtilization;
    cachedData.minSplitSceneCount = data.minSplitSceneCount;
    cachedData.minRecoveryCount = data.minRecoveryCount;
    
    cachedData.maxInUseSystemMemory = data.maxInUseSystemMemory;
    cachedData.maxAllocatedSystemMemory = data.maxAllocatedSystemMemory;
    cachedData.maxTiledSceneBytes = data.maxTiledSceneBytes;
    cachedData.maxAllocatedPBSize = data.maxAllocatedPBSize;
    cachedData.maxTilerUtilization = data.maxTilerUtilization;
    cachedData.maxRendererUtilization = data.maxRendererUtilization;
    cachedData.maxDeviceUtilization = data.maxDeviceUtilization;
    cachedData.maxSplitSceneCount = data.maxSplitSceneCount;
    cachedData.maxRecoveryCount = data.maxRecoveryCount;
    
    return cachedData;
}

