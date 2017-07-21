//
//  JRDeviceInfo.m
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import "JRDeviceInfo.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <sys/utsname.h>
#import <sys/param.h>
#import "SSKeychain.h"
#import <CommonCrypto/CommonDigest.h>

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

@implementation JRDeviceInfo

+ (NSString *)bundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
}

#pragma mark -- 设备信息

+ (NSString*)deviceModelName{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    
    
    //iPod 系列
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    
    
    //iPad 系列
    
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        
        ||[deviceModel isEqualToString:@"iPad4,5"]
        
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        
        ||[deviceModel isEqualToString:@"iPad4,8"]
        
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}

+ (NSString *)deviceName {
    return [UIDevice currentDevice].name;
}

+ (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
    
}

+ (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)model {
    return [UIDevice currentDevice].model;
}

+ (NSString *)localizedModel {
    return [UIDevice currentDevice].localizedModel;
}

//电池电量
+ (int)batteryLevel{
    if (![[UIDevice currentDevice] isBatteryMonitoringEnabled]) {
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    }
    int level = (int)([UIDevice currentDevice].batteryLevel * 100);
    if (level <0 ) return -1;
    return level;
    
}
//是否正在充电
+ (BOOL)isInCharge{
    if (![[UIDevice currentDevice] isBatteryMonitoringEnabled]) {
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    }
    switch ([UIDevice currentDevice].batteryState) {
        case UIDeviceBatteryStateCharging://充电状态
            return YES;
            break;
        case UIDeviceBatteryStateFull://充满状态（连接充电器充满状态）
            return YES;
            break;
        default:
            return NO;
            break;
    }
}
/**
 获取当前屏幕亮度
 */
+ (int)brightness{
    return (int)([UIScreen mainScreen].brightness * 100);
}

#pragma mark -- 越狱判断
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

char* printEnv(void)
{
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    NSLog(@"%s", env);
    return env;
}

+ (BOOL)isJailBreak
{
    //判定常见的越狱文件
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        NSString * path = [NSString stringWithUTF8String:jailbreak_tool_pathes[i]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSLog(@"判定常见的越狱文件(%@):The device is jail broken!",path);
            return YES;
        }
    }
    //判定是否存在cydia这个应用。
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        NSLog(@"判定是否存在cydia这个应用:The device is jail broken!");
        return YES;
    }
    NSString * USER_APP_PATH = @"/User/Applications/";
    //读取系统所有应用的名称
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
        NSLog(@"读取系统所有应用的名称:The device is jail broken!");
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
        NSLog(@"applist = %@", applist);
        return YES;
    }
    //读取环境变量 这个DYLD_INSERT_LIBRARIES环境变量，在非越狱的机器上应该是空，越狱的机器上基本都会有
    if (printEnv()) {
        NSLog(@"读取环境变量:The device is jail broken!");
        return YES;
    }
    return NO;
}

//是否为模拟器
+ (BOOL)isEmulator{
#if TARGET_IPHONE_SIMULATOR//模拟器
    return YES;
#elif TARGET_OS_IPHONE//真机
    return NO;
#endif
    return YES;
}

/**
 *得到本机现在用的语言
 * en-CN 或en  英文  zh-Hans-CN或zh-Hans  简体中文   zh-Hant-CN或zh-Hant  繁体中文    ja-CN或ja  日本  ......
 */
+ (NSString*)preferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

#pragma mark -- 系统时间

/**
 开机时间
 */
+ (int64_t)bootTime{
    
    int64_t interval = [self currentTime] - [self activeTime];
    return interval;
}
/**
 从开机到现在的活动时间
 */
+ (int64_t)activeTime{
    
    NSTimeInterval upTime =  [NSProcessInfo processInfo].systemUptime;
    return (int64_t)upTime;
}
/**
 系统当前时间
 */
+ (int64_t)currentTime{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return (int64_t)interval;
}

+ (NSString *)timeZone{
    return [NSString stringWithFormat:@"%@ %@",[NSTimeZone systemTimeZone].name,[NSTimeZone systemTimeZone].abbreviation];
}
#pragma mark -- 唯一标识

/**
 广告标识符
 */
+ (NSString *)idfa{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId.length >0 ? adId : @"";
}

/**
 Vindor标示符
 */
+ (NSString *)idfv{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv.length > 0 ? idfv : @"";
}

/**
 openudid
 */
+ (NSString *)openudid{
    NSString * account = @"JRopenudid_0";
    NSString * service = [[self bundleID] stringByAppendingString:@".JRService"];
    NSString * openudid = [SSKeychain passwordForService:service account:account];
    if (openudid == nil) {
        unsigned char result[16];
        const char *cStr = [[[NSProcessInfo processInfo] globallyUniqueString] UTF8String];
        CC_MD5( cStr, strlen(cStr), result );
        openudid = [[NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15],
                     arc4random() % 4294967295] lowercaseString];
        [SSKeychain setPassword:openudid forService:service account:account];
        
    }
    return openudid;
}

/**
 uuid
 */
+ (NSString *)uuid{
    NSString * account = @"JRuuid_0";
    NSString * service = [[self bundleID] stringByAppendingString:@".JRService"];
    NSString * uuid = [SSKeychain passwordForService:service account:account];
    if (uuid == nil) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        uuid = [[uuid stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
        CFRelease(puuid);
        CFRelease(uuidString);
        [SSKeychain setPassword:uuid forService:service account:account];
    }
    return uuid;
}
#pragma mark -- 内存及硬盘情况
//获取当前设备可用内存(单位：MB）
+ (unsigned long long)availableMemory{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return (vm_page_size * vmStats.free_count);
}
//当前设备总内存
+ (unsigned long long)physicalMemory{
    return [NSProcessInfo processInfo].physicalMemory;
}


@end
