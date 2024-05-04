//
//  GpuStatisticsFetcher.m
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/5/3.
//

#import "GpuStatisticsFetcher.h"
#import "IOKit.h"

const char *kIOServicePlane = "IOService";

#define GPU_UTILI_KEY(key, value) static NSString * const GPU ## key ##Key = @#value;

GPU_UTILI_KEY(InUseSystemMemory, In use system memory)
GPU_UTILI_KEY(AllocatedSystemMemory, Alloc system memory)
GPU_UTILI_KEY(TilerUtilization, Tiler Utilization %)
GPU_UTILI_KEY(RecoveryCount, recoveryCount)
GPU_UTILI_KEY(RendererUtilization, Renderer Utilization %)
GPU_UTILI_KEY(TiledSceneBytes, TiledSceneBytes)
GPU_UTILI_KEY(SplitSceneCount, SplitSceneCount)
GPU_UTILI_KEY(DeviceUtilization, Device Utilization %)
GPU_UTILI_KEY(AllocatedPBSize, Allocated PB Size)

@implementation GpuStatisticsFetcher
{
    NSDictionary *utilizationInfo;
}

+ (NSDictionary *)utilizeDictionary
{
    NSDictionary *dictionary = nil;
    
    io_iterator_t iterator;
#if TARGET_IPHONE_SIMULATOR
    if (IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceNameMatching("IntelAccelerator"), &iterator) == kIOReturnSuccess)
    {
        for (io_registry_entry_t regEntry = IOIteratorNext(iterator); regEntry; regEntry = IOIteratorNext(iterator))
        {
            CFMutableDictionaryRef serviceDictionary;
            if (IORegistryEntryCreateCFProperties(regEntry, &serviceDictionary, kCFAllocatorDefault, kNilOptions) != kIOReturnSuccess)
            {
                IOObjectRelease(regEntry);
                continue;
            }
            
            dictionary = ((__bridge NSDictionary *)serviceDictionary)[@"PerformanceStatistics"];
            
            CFRelease(serviceDictionary);
            IOObjectRelease(regEntry);
            break;
        }
        IOObjectRelease(iterator);
    }
    
#elif TARGET_OS_IOS
    if (IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceNameMatching("sgx"), &iterator) == kIOReturnSuccess)
    {
        for (io_registry_entry_t regEntry = IOIteratorNext(iterator); regEntry; regEntry = IOIteratorNext(iterator))
        {
            io_iterator_t innerIterator;
            if (IORegistryEntryGetChildIterator(regEntry, kIOServicePlane, &innerIterator) == kIOReturnSuccess)
            {
                for (io_registry_entry_t gpuEntry = IOIteratorNext(innerIterator); gpuEntry; gpuEntry = IOIteratorNext(innerIterator))
                {
                    CFMutableDictionaryRef serviceDictionary;
                    if (IORegistryEntryCreateCFProperties(gpuEntry, &serviceDictionary, kCFAllocatorDefault, kNilOptions) != kIOReturnSuccess)
                    {
                        IOObjectRelease(gpuEntry);
                        continue;
                    }

                    dictionary = ((__bridge NSDictionary *)serviceDictionary)[@"PerformanceStatistics"];
                    
                    CFRelease(serviceDictionary);
                    IOObjectRelease(gpuEntry);
                    break; // Exit after first successful fetch
                }
                IOObjectRelease(innerIterator);
            }
            IOObjectRelease(regEntry);
            if (dictionary) break; // Ensure we exit outer loop if dictionary was set
        }
        IOObjectRelease(iterator);
    }
#endif
    
    return dictionary;
}

- (void)fetch
{
    utilizationInfo = [[GpuStatisticsFetcher utilizeDictionary] copy];
}

- (int64_t) getInUseSystemMemory
{
    return [utilizationInfo[GPUInUseSystemMemoryKey] longLongValue];
}

- (int64_t) getAllocatedSystemMemory
{
    return [utilizationInfo[GPUAllocatedSystemMemoryKey] longLongValue];
}

- (int64_t) getTiledSceneBytes
{
    return [utilizationInfo[GPUTiledSceneBytesKey] longLongValue];
}

- (int64_t) getAllocatedPBSize
{
    return [utilizationInfo[GPUAllocatedPBSizeKey] longLongValue];
}

- (NSInteger)getTilerUtilization
{
    return [utilizationInfo[GPUTilerUtilizationKey] integerValue];
}

- (NSInteger)getRendererUtilization
{
    return [utilizationInfo[GPURendererUtilizationKey] integerValue];
}

- (NSInteger)getDeviceUtilization
{
    return [utilizationInfo[GPUDeviceUtilizationKey] integerValue];
}

- (NSInteger)getSplitSceneCount
{
    return [utilizationInfo[GPUSplitSceneCountKey] integerValue];
}

- (NSInteger)getRecoveryCount
{
    return [utilizationInfo[GPURecoveryCountKey] integerValue];
}

@end

