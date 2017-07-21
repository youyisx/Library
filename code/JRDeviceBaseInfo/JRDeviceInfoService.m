//
//  JRDeviceInfoService.m
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import "JRDeviceInfoService.h"
#import <JRDeviceBaseInfo/JRDeviceBaseInfo.h>
#import <UIKit/UIKit.h>

static void(^baseInfoblock)(NSDictionary *) = nil;

#import "JMAnalyticsManager.h"
#import "SCStartUpConfigBusiness.h"
#import "SCGlobal.h"
@implementation JRDeviceInfoService

+(dispatch_queue_t)taskQueue {
    static dispatch_queue_t taskQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        taskQueue = dispatch_queue_create("com.jumei.jrDeviceInfoTask", DISPATCH_QUEUE_SERIAL);
    });
    return taskQueue;
}

+(SCStartUpConfigBusiness *)business{
    static SCStartUpConfigBusiness * business = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        business = [[SCStartUpConfigBusiness alloc] init];
    });
    return business;
}


+(void)getJRDeviceBaseInfo:(void(^)(NSDictionary *))block{
    if (!block) return;
    dispatch_async([self taskQueue], ^{
        baseInfoblock = block;
        NSMutableDictionary * dic = @{}.mutableCopy;
        dic[@"jr_app_os"]           = stringWithObject([JRDeviceInfo systemName]);
        dic[@"jr_app_idfa"]         = stringWithObject([JRDeviceInfo idfa]);
        dic[@"jr_app_idfv"]         = stringWithObject([JRDeviceInfo idfv]);
        dic[@"jr_app_bootTime"]     = [NSString stringWithFormat:@"%lld",[JRDeviceInfo bootTime]];
        dic[@"jr_app_now"]          = [NSString stringWithFormat:@"%lld",[JRDeviceInfo currentTime]];
        dic[@"jr_app_activeTime"]   = [NSString stringWithFormat:@"%lld",[JRDeviceInfo activeTime]];
        dic[@"jr_app_totalMem"]     = [NSString stringWithFormat:@"%lu",(unsigned long)[JRHardware totalMemory]];
        dic[@"jr_app_freeMem"]      = [NSString stringWithFormat:@"%lu",(unsigned long)[JRHardware freeMemory]];
        dic[@"jr_app_brightness"]   = [NSString stringWithFormat:@"%d",[JRDeviceInfo brightness]];
        dic[@"jr_app_remainBattery"]= [NSString stringWithFormat:@"%d",[JRDeviceInfo batteryLevel]];
        NSString * ipAdress = [JRDeviceNetInfo getIPAddress:YES];
        dic[@"jr_app_cellIp"]       = stringWithObject(ipAdress);
        dic[@"jr_app_netDns"]       = stringWithObject([JRDeviceNetInfo DNSServers]);
        JRWifiInfo * wf = [JRDeviceNetInfo wifi];
        dic[@"jr_app_wifiIp"]       = stringWithObject(wf.wifiIP);
        dic[@"jr_app_wifiMask"]     = stringWithObject(wf.wifiNetMast);
        dic[@"jr_app_netType"]      = stringWithObject([JRDeviceNetInfo networkType]);
        dic[@"jr_app_ssid"]         = stringWithObject(wf.SSID);
        dic[@"jr_app_bssid"]        = stringWithObject(wf.BSSID);
        dic[@"jr_app_netGateway"]   = stringWithObject(wf.wifiGateWay);
        
        dic[@"jr_app_jailbreak"]    = [JRDeviceInfo isJailBreak] ? @"1":@"0";
        dic[@"jr_app_platform"]     = stringWithObject([JRDeviceInfo model]);
        dic[@"jr_app_osVersion"]    = stringWithObject([JRDeviceInfo systemVersion]);
        dic[@"jr_app_deviceName"]   = stringWithObject([JRDeviceInfo deviceName]);
        CTCarrier * carrier = [JRDeviceNetInfo carrier];
        dic[@"jr_app_carrier"]      = stringWithObject(carrier.carrierName);
        dic[@"jr_app_carrierISO"]   = stringWithObject(carrier.isoCountryCode);
        dic[@"jr_app_mcc"]          = stringWithObject(carrier.mobileCountryCode);
        dic[@"jr_app_mnc"]          = stringWithObject(carrier.mobileNetworkCode);
        dic[@"jr_app_bundleId"]     = stringWithObject([JRDeviceInfo bundleID]);
        dic[@"jr_app_curLang"]      = stringWithObject([JRDeviceInfo preferredLanguage]);
        
        dic[@"jr_app_openudid"]     = stringWithObject([JRDeviceInfo openudid]);
        dic[@"jr_app_cpuCoreNum"]   = [NSString stringWithFormat:@"%lu",(unsigned long)[JRHardware cpuCount]];
        dic[@"jr_app_cpuSubType"]   = stringWithObject([JRHardware cpuSubType]);
//        dic[@"jr_app_cpuSerial"]    = @"";
//        dic[@"jr_app_cpuSpeed"]     = [NSString stringWithFormat:@"%lu",(unsigned long)[JRHardware cpuFrequency]];
        dic[@"jr_app_netIp"]        = stringWithObject(ipAdress);
        dic[@"jr_app_cpuType"]      = stringWithObject([JRHardware cpuType]);
        dic[@"jr_app_uuid"]         = stringWithObject([JRDeviceInfo uuid]);
        dic[@"jr_app_isInCharge"]   = [JRDeviceInfo isInCharge] ? @"1":@"0";
        dic[@"jr_app_totalDisk"]    = [NSString stringWithFormat:@"%lld",[JRHardware totalDiskSpaceInBytes]];
        dic[@"jr_app_freeDisk"]     = [NSString stringWithFormat:@"%lld",[JRHardware freeDiskSpaceInBytes]];
        dic[@"jr_app_isEmulator"]   = [JRDeviceInfo isEmulator] ? @"1":@"0";
        dic[@"jr_app_timeZone"]     = stringWithObject([JRDeviceInfo timeZone]);
        
        int width                   = (int)(CGRectGetWidth([UIScreen mainScreen].bounds)*[UIScreen mainScreen].scale);
        int height                  = (int)(CGRectGetHeight([UIScreen mainScreen].bounds)*[UIScreen mainScreen].scale);
        dic[@"jr_app_screensize"]   = [NSString stringWithFormat:@"%dx%d",height,width];
        dic[@"jr_app_model"]        = stringWithObject([JRDeviceInfo deviceModelName]);
        //经纬度
        dic[@"jr_app_geo"] = @"0,0";
        dispatch_async(dispatch_get_main_queue(), ^{
            [JRLocationInfo currentLocation:^(CLLocationCoordinate2D coordinate) {
                dic[@"jr_app_geo"] = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
                if (baseInfoblock) {
                    baseInfoblock(dic);
                    baseInfoblock = nil;
                }
            }];
        });
    });
    
    
}

+(void)trackEventDataAnalyze:(JRAnalyzeEvent)event{
    NSString * eventStr = nil;
    BOOL requestSwitch = NO;
    switch (event) {
        case JRAnalyzeEvent_Start_Hot:
            eventStr = @"app_startup_jr_hot";
            break;
        case JRAnalyzeEvent_Start_Cold:
            eventStr = @"app_startup_jr_cold";
            requestSwitch = YES;
            break;
        default:
            eventStr = @"app_startup_jr_hot";
            break;
    }
    
    void(^taskBlock)() = ^{
        if (![SCGlobal sharedGlobal].userConfigSwitch) return;
        SCLogm(@"JRDeviceInfoService --> %@ ,获取信息",eventStr);
        [self getJRDeviceBaseInfo:^(NSDictionary *info) {
            SCLogm(@"JRDeviceInfoService -->上报 %@ ",eventStr);
            [JMAnalyticsManager track:eventStr withProperties:info];
        }];
    };
    if (requestSwitch) {
        [[self business] cancelStartUpConfigRequestHTTPSesion];
        [[self business] startUpConfigRequestSuccess:^{
            taskBlock();
        } failure:^(NSError *error) {
            taskBlock();
        }];
    }else{
        taskBlock();
    }
}



@end
