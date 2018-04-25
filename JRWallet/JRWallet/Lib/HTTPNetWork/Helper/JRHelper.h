//
//  JRHelper.h
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRHelper : NSObject

+ (NSString *)idfa;

+ (NSString *)idfv;

+ (NSString *)platform;

+ (NSString *)clientVersion;

+ (NSString *)deviceModel;

+ (NSString *)networkType;

+ (NSString *)ipAddress:(BOOL)preferIPv4;

@end
