//
//  TaskInfoTracker.swift
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/5/3.
//

import Foundation

class TaskInfoTracker
{
    private var timer: Timer?
    private var sampleCount: Int = 0
    
    private var cpuUsageStat = Statistics<Double>()
    private var memoryUsageStat = Statistics<Double>()
    
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
        
        let doubleSampleCount = Double(sampleCount)
        
        data.cpuCoresCount = getCpuCoresCount()
        
        data.cpuUsage = cpuUsageStat.sum / doubleSampleCount
        data.minCpuUsage = cpuUsageStat.min
        data.maxCpuUsage = cpuUsageStat.max
        
        data.memoryUsage = memoryUsageStat.sum / doubleSampleCount
        data.minMemoryUsage = memoryUsageStat.min
        data.maxMemoryUsage = memoryUsageStat.max
    }

    private func reset()
    {
        sampleCount = 0
        
        cpuUsageStat.reset(min: Double.greatestFiniteMagnitude, max: 0.0)
        memoryUsageStat.reset(min: Double.greatestFiniteMagnitude, max: 0.0)
    }
    
    @objc private func sample()
    {
        let (cpuUsage, memoryUsage) = getUsage()
        
        cpuUsageStat.update(value: cpuUsage)
        memoryUsageStat.update(value: memoryUsage)
        
        sampleCount += 1
    }
    
    private func getUsage() -> (cpuUsage: Double, memoryUsage: Double)
    {
        var kr: kern_return_t
        var taskInfoCount: mach_msg_type_number_t = mach_msg_type_number_t(TASK_INFO_MAX)
        var tinfo = [integer_t](repeating: 0, count: Int(taskInfoCount))

        kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &taskInfoCount)
        if kr != KERN_SUCCESS
        {
            print("Error with task_info(): \(kr)")
            return (-1.0, 0.0)
        }

        let basicInfo = tinfo.withUnsafeBytes { ptr -> task_basic_info in ptr.load(as: task_basic_info.self) }
        let memoryUsage = Double(basicInfo.resident_size)

        var threadList: thread_act_array_t?
        var threadCount: mach_msg_type_number_t = 0
        kr = task_threads(mach_task_self_, &threadList, &threadCount)
        if kr != KERN_SUCCESS
        {
            print("Error getting threads: \(kr)")
            return (0.0, memoryUsage)
        }

        var cpuUsage: Double = 0.0

        if let threadList = threadList
        {
            for j in 0..<Int(threadCount)
            {
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                var thinfo = [integer_t](repeating: 0, count: Int(threadInfoCount))
                kr = thread_info(threadList[j], thread_flavor_t(THREAD_BASIC_INFO), &thinfo, &threadInfoCount)

                if kr != KERN_SUCCESS
                {
                    print("Error with thread_info: \(kr)")
                    continue
                }

                let threadBasicInfo = thinfo.withUnsafeBytes { ptr -> thread_basic_info in ptr.load(as: thread_basic_info.self) }

                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0
                {
                    cpuUsage += Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)
                }
            }

            kr = vm_deallocate(mach_task_self_, vm_address_t(bitPattern: threadList), vm_size_t(Int(threadCount) * MemoryLayout<thread_act_t>.stride))
            if kr != KERN_SUCCESS
            {
                print("Error deallocating thread list: \(kr)")
            }
        }

        return (cpuUsage, memoryUsage)
    }
    
    
    private func getCpuCoresCount() -> Int
    {
        return ProcessInfo.processInfo.processorCount
    }
    
    var description: String
    {
        return ("cpuUsageStat: \(cpuUsageStat)\n memoryUsageStat: \(memoryUsageStat)")
    }
}
