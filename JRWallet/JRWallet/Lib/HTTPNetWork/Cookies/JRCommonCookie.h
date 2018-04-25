//
//  JRCommonCookie.h
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRCommonCookie : NSObject

@property (nonatomic, copy, readonly) NSString * cookies;

+ (instancetype)commonCookieWithDomain:(NSString *)domain;

- (void)appendCookies:(NSDictionary *)cookies;

+ (NSString *)cookiesWithParam:(NSDictionary *)param;


/** @return  公共cookis信息 */
- (NSDictionary *)commonCookis;

@end
