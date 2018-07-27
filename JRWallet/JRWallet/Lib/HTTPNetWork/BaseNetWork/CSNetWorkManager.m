//
//  CSNetWorkManager.m
//  JRWallet
//
//  Created by xxx on 2018/6/8.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "CSNetWorkManager.h"
#import "CSJSONResponseserializer.h"
#import "CSJSONRequestSerializer.h"

@implementation CSNetWorkManager


+ (AFHTTPSessionManager *)sessionManagerWithHost:(NSString *)host{
    if (![host isKindOfClass:[NSString class]]||!host.length) return nil;
    AFHTTPSessionManager * manager_ = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:host]];
    manager_.securityPolicy.allowInvalidCertificates = YES;
    manager_.securityPolicy.validatesDomainName = NO;
    return manager_;
}

+ (AFHTTPSessionManager *)sessionManagerWithHost:(NSString *)host
                                   RequestHandle:(id<CSRequestHandleProtocol>)requestHandle
                                  ResponseHandle:(id<CSResponseHandleProtocol>)responseHandle{
    AFHTTPSessionManager * manager_ = [self sessionManagerWithHost:host];
    CSJSONResponseserializer * response_ = [CSJSONResponseserializer serializer];
//    response_.responseHandle = responseHandle;
    manager_.responseSerializer = response_;
    
    CSJSONRequestSerializer * request_ = [CSJSONRequestSerializer serializer];
//    request_.requestHandle = requestHandle;
    manager_.requestSerializer = request_;
    return manager_;
}

@end
