//
//  JRHardware.h
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRHardware : NSObject
+ (NSUInteger) totalMemory;

+ (NSUInteger) userMemory;

+ (NSUInteger) freeMemory;

+ (NSUInteger) cpuCount;

+ (NSString *) cpuType;

+ (NSString *) cpuSubType;
//cpu频率 获取不到 ....
+ (NSUInteger) cpuFrequency;
//手机剩余空间
+ (long long) freeDiskSpaceInBytes;

//手机总空间
+ (long long) totalDiskSpaceInBytes;
@end
