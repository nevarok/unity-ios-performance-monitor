//
//  PerformanceMonitorBridge.h
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/4/29.
//

#ifndef PerformanceMonitorBridge_h
#define PerformanceMonitorBridge_h

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    long cpuCoresCount;
    
    double cpuUsage;
    double minCpuUsage;
    double maxCpuUsage;
    
    double memoryUsage;
    double minMemoryUsage;
    double maxMemoryUsage;
    
    long inUseSystemMemory;
    long allocatedSystemMemory;
    long tiledSceneBytes;
    long allocatedPBSize;
    long tilerUtilization;
    long rendererUtilization;
    long deviceUtilization;
    long splitSceneCount;
    long recoveryCount;
    
    long minInUseSystemMemory;
    long minAllocatedSystemMemory;
    long minTiledSceneBytes;
    long minAllocatedPBSize;
    long minTilerUtilization;
    long minRendererUtilization;
    long minDeviceUtilization;
    long minSplitSceneCount;
    long minRecoveryCount;
    
    long maxInUseSystemMemory;
    long maxAllocatedSystemMemory;
    long maxTiledSceneBytes;
    long maxAllocatedPBSize;
    long maxTilerUtilization;
    long maxRendererUtilization;
    long maxDeviceUtilization;
    long maxSplitSceneCount;
    long maxRecoveryCount;
} PerformanceDataStruct;

void PerformanceMonitorBridge_StartTracking(void);
PerformanceDataStruct PerformanceMonitorBridge_StopTracking(void);

#ifdef __cplusplus
}
#endif

#endif /* PerformanceMonitorBridge_h */
