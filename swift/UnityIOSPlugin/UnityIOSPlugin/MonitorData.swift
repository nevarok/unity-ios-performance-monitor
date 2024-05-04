//
//  MonitorData.swift
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/5/4.
//

import Foundation

@objc public class MonitorData: NSObject
{
    @objc public var cpuCoresCount: Int = 0
    @objc public var cpuUsage: Double = 0.0
    @objc public var minCpuUsage: Double = 0.0
    @objc public var maxCpuUsage: Double = 0.0
    @objc public var memoryUsage: Double = 0.0
    @objc public var minMemoryUsage: Double = 0.0
    @objc public var maxMemoryUsage: Double = 0.0

    @objc public var inUseSystemMemory: Int64 = 0
    @objc public var allocatedSystemMemory: Int64 = 0
    @objc public var tiledSceneBytes: Int64 = 0
    @objc public var allocatedPBSize: Int64 = 0
    @objc public var tilerUtilization: Int = 0
    @objc public var rendererUtilization: Int = 0
    @objc public var deviceUtilization: Int = 0
    @objc public var splitSceneCount: Int = 0
    @objc public var recoveryCount: Int = 0

    @objc public var minInUseSystemMemory: Int64 = 0
    @objc public var minAllocatedSystemMemory: Int64 = 0
    @objc public var minTiledSceneBytes: Int64 = 0
    @objc public var minAllocatedPBSize: Int64 = 0
    @objc public var minTilerUtilization: Int = 0
    @objc public var minRendererUtilization: Int = 0
    @objc public var minDeviceUtilization: Int = 0
    @objc public var minSplitSceneCount: Int = 0
    @objc public var minRecoveryCount: Int = 0

    @objc public var maxInUseSystemMemory: Int64 = 0
    @objc public var maxAllocatedSystemMemory: Int64 = 0
    @objc public var maxTiledSceneBytes: Int64 = 0
    @objc public var maxAllocatedPBSize: Int64 = 0
    @objc public var maxTilerUtilization: Int = 0
    @objc public var maxRendererUtilization: Int = 0
    @objc public var maxDeviceUtilization: Int = 0
    @objc public var maxSplitSceneCount: Int = 0
    @objc public var maxRecoveryCount: Int = 0
    
    public func reset()
    {
        cpuCoresCount = 0
        cpuUsage = 0
        minCpuUsage = 0
        maxCpuUsage = 0
        memoryUsage = 0
        minMemoryUsage = 0
        maxMemoryUsage = 0

        inUseSystemMemory = 0
        allocatedSystemMemory = 0
        tiledSceneBytes = 0
        allocatedPBSize = 0
        tilerUtilization = 0
        rendererUtilization = 0
        deviceUtilization = 0
        splitSceneCount = 0
        recoveryCount = 0

        minInUseSystemMemory = 0
        minAllocatedSystemMemory = 0
        minTiledSceneBytes = 0
        minAllocatedPBSize = 0
        minTilerUtilization = 0
        minRendererUtilization = 0
        minDeviceUtilization = 0
        minSplitSceneCount = 0
        minRecoveryCount = 0

        maxInUseSystemMemory = 0
        maxAllocatedSystemMemory = 0
        maxTiledSceneBytes = 0
        maxAllocatedPBSize = 0
        maxTilerUtilization = 0
        maxRendererUtilization = 0
        maxDeviceUtilization = 0
        maxSplitSceneCount = 0
        maxRecoveryCount = 0
    }
    
    @objc public override var description: String
    {        
        let prefix = "\nMonitorData:"
        let cpuStats = String(format: "CPU Cores: %d, CPU Usage: %.2f%%, Min CPU Usage: %.2f%%, Max CPU Usage: %.2f%%",
                              cpuCoresCount,
                              cpuUsage * 100.0,
                              minCpuUsage * 100.0,
                              maxCpuUsage * 100.0)
        let memoryStats = String(format: "Memory Usage: %.2fMB, Min Memory Usage: %.2fMB, Max Memory Usage: %.2fMB",
                                 memoryUsage / 1024 / 1024,
                                 minMemoryUsage / 1024 / 1024,
                                 maxMemoryUsage / 1024 / 1024)
        let systemMemoryStats = String(format: "In Use System Memory: %lld bytes, Min In Use System Memory: %lld bytes, Max In Use System Memory: %lld bytes",
                                       inUseSystemMemory / 1024 / 1024,
                                       minInUseSystemMemory / 1024 / 1024,
                                       maxInUseSystemMemory / 1024 / 1024)
        let allocatedMemoryStats = String(format: "Allocated System Memory: %lld bytes, Min Allocated System Memory: %lld bytes, Max Allocated System Memory: %lld bytes",
                                          allocatedSystemMemory / 1024 / 1024,
                                          minAllocatedSystemMemory / 1024 / 1024,
                                          maxAllocatedSystemMemory / 1024 / 1024)
        let sceneStats = String(format: "Tiled Scene Bytes: %lld, Min Tiled Scene Bytes: %lld, Max Tiled Scene Bytes: %lld",
                                tiledSceneBytes / 1024 / 1024,
                                minTiledSceneBytes / 1024 / 1024,
                                maxTiledSceneBytes / 1024 / 1024)
        let pbSizeStats = String(format: "Allocated PB Size: %lld, Min Allocated PB Size: %lld, Max Allocated PB Size: %lld",
                                 allocatedPBSize / 1024 / 1024,
                                 minAllocatedPBSize / 1024 / 1024,
                                 maxAllocatedPBSize / 1024 / 1024)
        let utilizationStats = String(format: "Tiler Utilization: %d%%, Min Tiler Utilization: %d%%, Max Tiler Utilization: %d%%, Renderer Utilization: %d%%, Min Renderer Utilization: %d%%, Max Renderer Utilization: %d%%, Device Utilization: %d%%, Min Device Utilization: %d%%, Max Device Utilization: %d%%",
                                      tilerUtilization,
                                      minTilerUtilization,
                                      maxTilerUtilization,
                                      rendererUtilization,
                                      minRendererUtilization,
                                      maxRendererUtilization,
                                      deviceUtilization,
                                      minDeviceUtilization,
                                      maxDeviceUtilization)
        let countStats = String(format: "Split Scene Count: %d, Min Split Scene Count: %d, Max Split Scene Count: %d, Recovery Count: %d, Min Recovery Count: %d, Max Recovery Count: %d",
                                splitSceneCount,
                                minSplitSceneCount,
                                maxSplitSceneCount,
                                recoveryCount,
                                minRecoveryCount,
                                maxRecoveryCount)

        return [prefix, cpuStats, memoryStats, systemMemoryStats, allocatedMemoryStats, sceneStats, pbSizeStats, utilizationStats, countStats].joined(separator: "\n - ")
    }
}
