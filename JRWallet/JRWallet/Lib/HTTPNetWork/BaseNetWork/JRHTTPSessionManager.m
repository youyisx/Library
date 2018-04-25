//
//  JRHTTPSessionManager.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRHTTPSessionManager.h"
#import "JRHTTPRequestSerializer.h"
#import "JRJSONResponseserializer.h"
@implementation JRHTTPSessionManager

+ (instancetype)jr_shareHTTPSessionManager{
    static JRHTTPSessionManager * manager_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager_ = [[JRHTTPSessionManager alloc] initWithBaseURL:nil];
        manager_.requestSerializer = [JRHTTPRequestSerializer serializer];
        manager_.responseSerializer = [JRJSONResponseserializer serializer];
        manager_.securityPolicy.allowInvalidCertificates = YES;
        manager_.securityPolicy.validatesDomainName = NO;
    });
    return manager_;
}


@end
