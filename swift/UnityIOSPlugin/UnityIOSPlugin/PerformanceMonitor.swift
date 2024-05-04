//
//  PerformanceMonitor.swift
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/4/29.
//

import Foundation

@objc public class PerformanceMonitor : NSObject
{
    private var isTracking: Bool
    
    private var taskInfoTracker: TaskInfoTracker?
    private var gpuTracker: GpuStatisticsTracker?
    private var cachedData: MonitorData
    private let samplingInterval: TimeInterval = 1.0 / 10.0
    
    public override init()
    {
        isTracking = false
        
        taskInfoTracker = TaskInfoTracker()
        gpuTracker = GpuStatisticsTracker()
        cachedData = MonitorData()
    }
    
    @objc public func startTracking()
    {
        if isTracking
        {
           let _ = stopTracking()
        }
        
        isTracking = true
        
        taskInfoTracker?.start(samplingInterval: samplingInterval)
        gpuTracker?.start(samplingInterval: samplingInterval)
    }

    @objc public func stopTracking() -> MonitorData
    {
        cachedData.reset()
        
        if !isTracking
        {
            return cachedData
        }
    
        isTracking = false
        
        taskInfoTracker?.stop(data: cachedData)
        gpuTracker?.stop(data: cachedData)

        return cachedData
    }
}
