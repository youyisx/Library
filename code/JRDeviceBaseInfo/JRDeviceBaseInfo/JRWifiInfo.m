//
//  JRWifiInfo.m
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import "JRWifiInfo.h"
#import "JRWifiHandle.h"

@interface JRWifiInfo()
@property (nonatomic,copy,readwrite) NSString * BSSID;
@property (nonatomic,copy,readwrite) NSString * SSID;//wifi名称
@property (nonatomic,strong) NSDictionary * info;
@property (nonatomic,strong) JRWifiHandle * wifiHandle;
@end

@implementation JRWifiInfo

-(instancetype)initWithInfo:(NSDictionary *)info{
    self = [self init];
    if (self) {
        // 这里其实对应的有三个key:kCNNetworkInfoKeySSID、kCNNetworkInfoKeyBSSID、kCNNetworkInfoKeySSIDData，
        // 不过它们都是CFStringRef类型的
        //  WiFiName = [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
        self.info = info;
        self.SSID = info[@"SSID"];
        self.BSSID = info[@"BSSID"];
    }
    return self;
}

-(NSString *)SSID{
    if ([_SSID isKindOfClass:[NSString class]] && _SSID.length > 0) {
        return _SSID;
    }
    return @"";
}

-(NSString *)BSSID{
    if ([_BSSID isKindOfClass:[NSString class]] && _BSSID.length > 0) {
        return _BSSID;
    }
    return @"";
}

-(JRWifiHandle *)wifiHandle{
    if (!_wifiHandle) {
        _wifiHandle = [[JRWifiHandle alloc] init];
    }
    return _wifiHandle;
}

-(NSString *)wifiGateWay{
    return self.wifiHandle.wifiGateWay;
}

-(NSString *)wifiIP{
    return self.wifiHandle.wifiIP;
}

-(NSString *)wifiBroadcastAddress{
    return self.wifiHandle.wifiBroadcastAddress;
}

-(NSString *)wifiNetMast{
    return self.wifiHandle.wifiNetMast;
}

-(NSString *)wifiInterface{
    return self.wifiHandle.wifiInterface;
}

@end
