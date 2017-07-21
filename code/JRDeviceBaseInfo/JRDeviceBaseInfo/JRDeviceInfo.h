//
//  JRDeviceInfo.h
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRDeviceInfo : NSObject
+ (NSString *)bundleID;

+ (NSString*)deviceModelName;//设备名称 e.g. "iPhone6s"

+ (NSString *)deviceName;//设备名称 e.g. "My iPhone"

+ (NSString *)systemName;//系统类型os e.g. "ios"

+ (NSString *)systemVersion;//e.g. "10.3"

+ (NSString *)model;//设备型号 e.g. @"iPhone", @"iPod touch"

+ (NSString *)localizedModel;

/**
 电池电量
 
 @return 0-100 百分比
 */
+ (int)batteryLevel;
//是否正在充电
+ (BOOL)isInCharge;
/**
 获取当前屏幕亮度
 
 @return 0-100 百分比
 */
+ (int)brightness;

/**
 设备是否越狱
 
 @return 越狱:yes,非越狱:no
 */
+ (BOOL)isJailBreak;

//是否为模拟器
+ (BOOL)isEmulator;

/**
 *得到本机现在用的语言
 * en-CN 或en  英文  zh-Hans-CN或zh-Hans  简体中文   zh-Hant-CN或zh-Hant  繁体中文    ja-CN或ja  日本  ......
 */
+ (NSString*)preferredLanguage;

//-------------------系统时间

/**
 开机时间
 */
+ (int64_t)bootTime;

/**
 从开机到现在的活动时间
 */
+ (int64_t)activeTime;

/**
 系统当前时间
 */
+ (int64_t)currentTime;

+ (NSString *)timeZone;

//-------------------唯一标识
/**
 广告标识符
 */
+ (NSString *)idfa;

/**
 Vindor标示符
 */
+ (NSString *)idfv;

/**
 openudid
 */
+ (NSString *)openudid;//

/**
 uuid
 */
+ (NSString *)uuid;

@end
