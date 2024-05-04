//
//  GpuStatisticsFetcher.h
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/5/3.
//


#import <Foundation/Foundation.h>

#ifndef NS_NOESCAPE
#define NS_NOESCAPE
#endif

@interface GpuStatisticsFetcher : NSObject

@property (nonatomic, readonly) int64_t getInUseSystemMemory;
@property (nonatomic, readonly) int64_t getAllocatedSystemMemory;
@property (nonatomic, readonly) int64_t getTiledSceneBytes;
@property (nonatomic, readonly) int64_t getAllocatedPBSize;
@property (nonatomic, readonly) NSInteger getTilerUtilization;
@property (nonatomic, readonly) NSInteger getRendererUtilization;
@property (nonatomic, readonly) NSInteger getDeviceUtilization;
@property (nonatomic, readonly) NSInteger getSplitSceneCount;
@property (nonatomic, readonly) NSInteger getRecoveryCount;

- (void)fetch;

@end
