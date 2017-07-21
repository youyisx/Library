//
//  JRHardware.m
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import "JRHardware.h"
#import <mach/mach.h>
#import <sys/sysctl.h>
#import <sys/mount.h>

@implementation JRHardware
+ (NSString *) cpuType{
    size_t size;
    cpu_type_t type;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    NSString * typeStr = nil;
    switch (type) {
        case CPU_TYPE_ARM64:
            typeStr = @"ARM64";
            break;
        case CPU_TYPE_ARM:
            typeStr = @"ARM";
            break;
        case CPU_TYPE_X86:
            typeStr = @"X86";
            break;
        case CPU_TYPE_X86_64:
            typeStr = @"X86_86";
            break;
        default:
            typeStr = @"unKnow";
            break;
    }
    return typeStr;
    
}

+ (NSString *) cpuSubType{
    size_t size;
    cpu_subtype_t subtype;
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    return [NSString stringWithFormat:@"%d",subtype];
}

+ (NSUInteger) freeMemory
{
    return [self totalMemory] - [self userMemory];
}

+ (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

+ (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}
//cpu频率 获取不到 ....
+ (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}
//
//+ (NSUInteger) busFrequency
//{
//    return [self getSysInfo:HW_BUS_FREQ];
//}



+ (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

//手机剩余空间
+ (long long) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace;
    //    return [self humanReadableStringFromBytes:freespace];
    
}
//手机总空间
+ (long long) totalDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = 0;
    if (statfs("/", &buf) >= 0) {
        freespace = (long long)buf.f_bsize * buf.f_blocks;
    }
    if (statfs("/private/var", &buf) >= 0) {
        freespace += (long long)buf.f_bsize * buf.f_blocks;
    }
    printf("%lld\n",freespace);
    return freespace;
    //    return [self humanReadableStringFromBytes:freespace];
}

//计算文件大小
//+ (NSString *)humanReadableStringFromBytes:(unsigned long long)byteCount
//{
//    float numberOfBytes = byteCount;
//    int multiplyFactor = 0;
//
//    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB",@"EB",@"ZB",@"YB",nil];
//
//    while (numberOfBytes > 1024) {
//        numberOfBytes /= 1024;
//        multiplyFactor++;
//    }
//
//    return [NSString stringWithFormat:@"%4.2f %@",numberOfBytes, [tokens objectAtIndex:multiplyFactor]];
//}

@end
