//
//  JRDeviceNetInfo.m
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import "JRDeviceNetInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#include <arpa/inet.h>
#include <resolv.h>
#include <dns.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation JRDeviceNetInfo

+ (JRWifiInfo *)wifi{
    id info = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info) {
            return [[JRWifiInfo alloc] initWithInfo:info];
        }
    }
    return nil;
}

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark -- 运营商信息

+ (CTCarrier *)carrier{
    //    这里需要注意的是，当你的手机内没有SIM卡时，这时获取到的运营商名称为手机的默认运营商，比如电信版手机名称为中国电信。
    //获取本机运营商名称
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    //当前手机所属运营商名称
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        NSLog(@"没有SIM卡");
        return nil;
    }
    return carrier;
    
}
#pragma mark -- 网络类型
+ (NSString *)networkType{
    if ([self wifi]) {
        return @"wifi";
    }
    // 获取手机网络类型
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *currentStatus = info.currentRadioAccessTechnology;
    NSString *netconnType = @"";
    if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]) {
        netconnType = @"GPRS";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]) {
        netconnType = @"EDGE";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]){
        netconnType = @"WCDMA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]){
        netconnType = @"HSDPA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]){
        netconnType = @"HSUPA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]){
        netconnType = @"CDMA1x";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
        netconnType = @"CDMAEVDORev0";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
        netconnType = @"CDMAEVDORevA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
        netconnType = @"CDMAEVDORevB";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
        netconnType = @"HRPD";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
        netconnType = @"LTE";
    }
    return netconnType.length > 0 ? netconnType : currentStatus;
}

+ (NSString *)DNSServers
{
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    NSMutableArray * dnsList = @[].mutableCopy;
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            [dnsList addObject:s];
            NSLog(@"%@",s);
        }
    }
    else
        NSLog(@"%@",@" res_init result != 0");
    
    res_nclose(res);
    
    return [dnsList componentsJoinedByString:@","];
}

@end
