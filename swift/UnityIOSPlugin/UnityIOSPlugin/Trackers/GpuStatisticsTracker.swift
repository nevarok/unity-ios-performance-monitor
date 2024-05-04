//
//  GpuStatisticsTracker.swift
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/5/3.
//

import Foundation

class GpuStatisticsTracker
{ 
    private var timer: Timer?
    private var sampleCount: Int = 0
    
    private var gpuUtilization: GpuStatisticsFetcher?
    
    private var inUseSystemMemoryStat = Statistics<Int64>()
    private var allocatedSystemMemoryStat = Statistics<Int64>()
    private var tiledSceneBytesStat = Statistics<Int64>()
    private var allocatedPBSizeStat = Statistics<Int64>()
    private var tilerUtilizationStat = Statistics<Int>()
    private var rendererUtilizationStat = Statistics<Int>()
    private var deviceUtilizationStat = Statistics<Int>()
    private var splitSceneCountStat = Statistics<Int>()
    private var recoveryCountStat = Statistics<Int>()
    
    
    public init()
    {
        gpuUtilization = GpuStatisticsFetcher()
    }
    
    public func start(samplingInterval: TimeInterval)
    {
        reset()
        
        sample()
        
        timer = Timer.scheduledTimer(timeInterval: samplingInterval, target: self, selector: #selector(sample), userInfo: nil, repeats: true)
    }

    public func stop(data: MonitorData)
    {
        timer?.invalidate()
        timer = nil
        
        guard sampleCount > 0 else
        {
            return
        }

        sample()
        
        let int64SampleCount = Int64(sampleCount)
        let intSampleCount = Int(sampleCount)
        
        data.inUseSystemMemory = inUseSystemMemoryStat.sum / int64SampleCount
        data.allocatedSystemMemory = allocatedSystemMemoryStat.sum / int64SampleCount
        data.tiledSceneBytes = tiledSceneBytesStat.sum / int64SampleCount
        data.allocatedPBSize = allocatedPBSizeStat.sum / int64SampleCount
        data.tilerUtilization = tilerUtilizationStat.sum / intSampleCount
        data.rendererUtilization = rendererUtilizationStat.sum / intSampleCount
        data.deviceUtilization = deviceUtilizationStat.sum / intSampleCount
        data.splitSceneCount = splitSceneCountStat.sum / intSampleCount
        data.recoveryCount = recoveryCountStat.sum / intSampleCount
        
        data.minInUseSystemMemory = inUseSystemMemoryStat.min
        data.minAllocatedSystemMemory = allocatedSystemMemoryStat.min
        data.minTiledSceneBytes = tiledSceneBytesStat.min
        data.minAllocatedPBSize = allocatedPBSizeStat.min
        data.minTilerUtilization = tilerUtilizationStat.min
        data.minRendererUtilization = rendererUtilizationStat.min
        data.minDeviceUtilization = deviceUtilizationStat.min
        data.minSplitSceneCount = splitSceneCountStat.min
        data.minRecoveryCount = recoveryCountStat.min
        
        data.maxInUseSystemMemory = inUseSystemMemoryStat.max
        data.maxAllocatedSystemMemory = allocatedSystemMemoryStat.max
        data.maxTiledSceneBytes = tiledSceneBytesStat.max
        data.maxAllocatedPBSize = allocatedPBSizeStat.max
        data.maxTilerUtilization = tilerUtilizationStat.max
        data.maxRendererUtilization = rendererUtilizationStat.max
        data.maxDeviceUtilization = deviceUtilizationStat.max
        data.maxSplitSceneCount = splitSceneCountStat.max
        data.maxRecoveryCount = recoveryCountStat.max
    }
    
    private func reset()
    {
        sampleCount = 0
        
        inUseSystemMemoryStat.reset(min: Int64.max, max: 0)
        allocatedSystemMemoryStat.reset(min: Int64.max, max: 0)
        tiledSceneBytesStat.reset(min: Int64.max, max: 0)
        allocatedPBSizeStat.reset(min: Int64.max, max: 0)
        
        tilerUtilizationStat.reset(min: Int.max, max: 0)
        rendererUtilizationStat.reset(min: Int.max, max: 0)
        deviceUtilizationStat.reset(min: Int.max, max: 0)
        splitSceneCountStat.reset(min: Int.max, max: 0)
        recoveryCountStat.reset(min: Int.max, max: 0)
    }
    
    @objc private func sample()
    {
        gpuUtilization?.fetch()
        
        let deviceUtilization = gpuUtilization?.getDeviceUtilization ?? 0;
        
        if deviceUtilization <= 0
        {
            return
        }
                
        let tilerUtilization = gpuUtilization?.getTilerUtilization ?? 0;
        let rendererUtilization = gpuUtilization?.getRendererUtilization ?? 0;
        let splitSceneCount = gpuUtilization?.getSplitSceneCount ?? 0;
        let recoveryCount = gpuUtilization?.getRecoveryCount ?? 0;
        
        let inUseSystemMemory = gpuUtilization?.getInUseSystemMemory ?? 0;
        let allocatedSystemMemory = gpuUtilization?.getAllocatedSystemMemory ?? 0;
        let tiledSceneBytes = gpuUtilization?.getTiledSceneBytes ?? 0;
        let allocatedPBSize = gpuUtilization?.getAllocatedPBSize ?? 0;
        
        inUseSystemMemoryStat.update(value: inUseSystemMemory)
        allocatedSystemMemoryStat.update(value: allocatedSystemMemory)
        tiledSceneBytesStat.update(value: tiledSceneBytes)
        allocatedPBSizeStat.update(value: allocatedPBSize)
        
        tilerUtilizationStat.update(value: tilerUtilization)
        rendererUtilizationStat.update(value: rendererUtilization)
        deviceUtilizationStat.update(value: deviceUtilization)
        splitSceneCountStat.update(value: splitSceneCount)
        recoveryCountStat.update(value: recoveryCount)
        
        sampleCount += 1
    }
    
    var description: String
    {
        return ("inUseSystemMemory: \(inUseSystemMemoryStat)\n allocatedSystemMemory: \(allocatedSystemMemoryStat)\n tiledSceneBytes: \(tiledSceneBytesStat)\n allocatedPBSize: \(allocatedPBSizeStat)\n tilerUtilization: \(tilerUtilizationStat)\n rendererUtilization: \(rendererUtilizationStat)\n deviceUtilization: \(deviceUtilizationStat)\n splitSceneCount: \(splitSceneCountStat)\n recoveryCount: \(recoveryCountStat)")
    }
}
