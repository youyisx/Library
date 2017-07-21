//
//  JRWifiHandle.h
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRWifiHandle : NSObject
@property (nonatomic,copy,readonly) NSString * wifiGateWay;//网关
@property (nonatomic,copy,readonly) NSString * wifiIP;//ip
@property (nonatomic,copy,readonly) NSString * wifiBroadcastAddress;//广播地址
@property (nonatomic,copy,readonly) NSString * wifiNetMast;//子网掩码
@property (nonatomic,copy,readonly) NSString * wifiInterface;//en0端口
@end
