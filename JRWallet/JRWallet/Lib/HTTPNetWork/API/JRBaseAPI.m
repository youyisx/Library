//
//  JRBaseAPI.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//


NSString * const JRAPIHTTPMethod_GET = @"GET";
NSString * const JRAPIHTTPMethod_POST = @"POST";

#import "JRBaseAPI.h"

#import "AFHTTPSessionManager+JR_RACSupport.h"

#import "JRBaseAPI+Config.h"
#import "CSJSONDataHandle.h"
@interface JRBaseAPI()

@end

@implementation JRBaseAPI

#pragma mark --- life
- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpMethod = JRAPIHTTPMethod_POST;
    }
    return self;
}

- (void)addDataHandleWithObjectPath:(NSString *)objectPath
                        ObjectClass:(NSString *)objectClass{
    CSJSONDataHandle * handle_ = [CSJSONDataHandle jsonDataHandleWithPath:objectPath
                                                                ClassName:objectClass];
    NSMutableArray * handleList_ = self.dataHandles.mutableCopy;
    if (!handleList_) handleList_ = @[].mutableCopy;
    [handleList_ addObject:handle_];
    self.dataHandles = handleList_;
}

- (void)addDataHandleWithObjectClass:(NSString *)objectClass{
    [self addDataHandleWithObjectPath:nil
                          ObjectClass:objectClass];
}

#pragma mark --- send request
- (RACCommand *)requestCommand{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self request:input];
    }];
}

- (RACSignal *)request:(NSDictionary *)param
             takeUntil:(RACSignal *)cancel{
    NSMutableDictionary * totalParam_ = [self commonParam].mutableCopy;
    if ([param isKindOfClass:[NSDictionary class]]) [totalParam_ addEntriesFromDictionary:param];
    NSDictionary * lastParam_ = [self adjustTotalParam:totalParam_];
    RACSignal * signal = nil;
    if ([self.httpMethod isEqualToString:JRAPIHTTPMethod_GET]) {
        signal = [self.sessionManager jr_rac_GET:[self path] parameters:lastParam_];
    }else if ([self.httpMethod isEqualToString:JRAPIHTTPMethod_POST]){
        signal = [self.sessionManager jr_rac_POST:[self path] parameters:lastParam_];
    }
    if (cancel&&[cancel isKindOfClass:[RACSignal class]]) signal = [signal takeUntil:cancel];
    
    signal = [[signal map:^id(id value) {
        return [self resolvingResultWithRespone:value];
    }] replayLast];
    
    return signal;
}

- (RACSignal *)request:(NSDictionary *)param{
   return  [self request:param
               takeUntil:nil];
}


#pragma mark --- resolving
- (id)resolvingResultWithRespone:(id)value{
    if (!self.dataHandles.count) return value;
    NSMutableArray * resultList_ = @[].mutableCopy;
    for (id<CSDataHandleProtocol> handle_ in self.dataHandles) {
        id result_ = [handle_ cs_ObjectWithData:value];
        if (result_) [resultList_ addObject:result_];
    }
    if (!resultList_.count) return nil;
    return resultList_.count == 1 ? resultList_.firstObject:resultList_;
}

#pragma mark --- extend param

/** 发入请求前，最后一次调整参数的机会 */
- (NSDictionary *)adjustTotalParam:(NSDictionary *)param{
    return param;
}


@end
