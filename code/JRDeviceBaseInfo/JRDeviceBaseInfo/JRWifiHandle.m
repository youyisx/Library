//
//  JRWifiHandle.m
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import "JRWifiHandle.h"
#include <sys/socket.h>
//for ifaddrs
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#if TARGET_IPHONE_SIMULATOR
#import <net/route.h>
#else
#import "route.h"
#endif
#import <stdio.h>
#import <stdlib.h>
#import <ctype.h>
#import <sys/param.h>
#import <sys/sysctl.h>
//#define CTL_NET         4               /* network, see socket.h */

@interface JRWifiHandle()
@property (nonatomic,copy,readwrite) NSString * wifiGateWay;
@property (nonatomic,copy,readwrite) NSString * wifiIP;
@property (nonatomic,copy,readwrite) NSString * wifiBroadcastAddress;
@property (nonatomic,copy,readwrite) NSString * wifiNetMast;
@property (nonatomic,copy,readwrite) NSString * wifiInterface;
@end

@implementation JRWifiHandle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupWifiInformation];
    }
    return self;
}

- (void)setupWifiInformation{
    _wifiGateWay = [NSString stringWithFormat:@"%@",[self defaultGateWay]];
    
    if (_wifiGateWay == nil) {
        _wifiGateWay = [NSString stringWithFormat:@"%@",@""];
    }
    if (_wifiBroadcastAddress == nil) {
        _wifiBroadcastAddress = [NSString stringWithFormat:@"%@",@""];
    }
    if (_wifiIP == nil) {
        _wifiIP = [NSString stringWithFormat:@"%@",@""];
    }
    if (_wifiInterface == nil) {
        _wifiInterface = [NSString stringWithFormat:@"%@",@""];
    }
    if (_wifiNetMast == nil) {
        _wifiNetMast = [NSString stringWithFormat:@"%@",@""];
    }
}

#pragma makr - wifi methods
- (NSString *) defaultGateWay
{
    NSString * vlcGateWay;
    NSString* routerIP= [self routerIp];
    NSLog(@"local device ip address----%@",routerIP);
    
    
    in_addr_t i =inet_addr([routerIP cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x =&i;
    char * r= getdefaultgateway(x);
    
    //char*转换为NSString
    vlcGateWay = [[NSString alloc] initWithFormat:@"%s",r];
    NSLog(@"gateway: %@",vlcGateWay);
    return vlcGateWay;
}

//返回广播地址，利用广播地址获取网关
- (NSString *) routerIp {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    //ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    //routerIP----192.168.1.255 广播地址
                    NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    _wifiBroadcastAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    
                    //--192.168.1.106 本机地址
                    NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    _wifiIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    //--255.255.255.0 子网掩码地址
                    NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    _wifiNetMast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    
                    //--en0 端口地址
                    NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                    _wifiInterface = [NSString stringWithUTF8String:temp_addr->ifa_name];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


#define ROUNDUP(a) \
((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

char * getdefaultgateway(in_addr_t * addr)
{
#if 0
    /* net.route.0.inet.dump.0.0 ? */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_DUMP, 0, 0/*tableid*/};
#endif
    /* net.route.0.inet.flags.gateway */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char * buf, * p;
    struct rt_msghdr * rt;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i;
    int r = -1;
    static char tmp[20];
    
    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &l, 0, 0) < 0) {
        return tmp;
    }
    if(l>0) {
        buf = malloc(l);
        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &l, 0, 0) < 0) {
            return tmp;
        }
        for(p=buf; p<buf+l; p+=rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for(i=0; i<RTAX_MAX; i++) {
                if(rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if( ((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
               && sa_tab[RTAX_DST]->sa_family == AF_INET
               && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                
                unsigned char octet[4]  = {0,0,0,0};
                for (int i=0; i<4; i++){
                    octet[i] = ( ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr >> (i*8) ) & 0xFF;
                }
                
                if(((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    
                    *addr = ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                    r = 0;
                    sprintf(tmp,"%d.%d.%d.%d",octet[0],octet[1],octet[2],octet[3]);
                    printf("gateway : %s\n",tmp);
                    printf("gateway address--%d.%d.%d.%d\n",octet[0],octet[1],octet[2],octet[3]);
                }
            }
        }
        free(buf);
    }
    return tmp;
}

@end
