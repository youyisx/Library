//
//  JRDeviceNetInfo.h
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRWifiInfo.h"
#import <CoreTelephony/CTCarrier.h>

@interface JRDeviceNetInfo : NSObject

+ (JRWifiInfo *)wifi;

/**
 蜂窝网络IP
 @return ip地址
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (CTCarrier *)carrier;

+ (NSString *)networkType;

+ (NSString *)DNSServers;
@end
