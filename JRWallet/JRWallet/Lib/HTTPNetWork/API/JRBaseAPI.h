//
//  JRBaseAPI.h
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


FOUNDATION_EXTERN NSString * const JRAPIHTTPMethod_GET;
FOUNDATION_EXTERN NSString * const JRAPIHTTPMethod_POST;

@class AFHTTPSessionManager;
@interface JRBaseAPI : NSObject

@property (nonatomic, readonly) AFHTTPSessionManager * sessionManager;

/** HTTP请求方式 ，默认为 JRAPIHTTPMethod_POST */
@property (nonatomic, copy) NSString * httpMethod;
@property (nonatomic, copy) NSString * path;
@property (nonatomic, copy) NSDictionary * commonParam;

/** 发入请求前，最后一次调整参数的机会 */
- (NSDictionary *)adjustTotalParam:(NSDictionary *)param;


//////数据解析相关
@property (nonatomic, strong) NSArray * dataHandles;//object 必须遵守CSDataHandleProtocol 协议
- (void)addDataHandleWithObjectPath:(NSString *)objectPath
                        ObjectClass:(NSString *)objectClass;
- (void)addDataHandleWithObjectClass:(NSString *)objectClass;

/**
 发起请求

 @param param 参数
 @return 任务信号
 */
- (RACSignal *)request:(NSDictionary *)param;
//支持条件cancel的请求
- (RACSignal *)request:(NSDictionary *)param
             takeUntil:(RACSignal *)cancel;

- (RACCommand *)requestCommand;


- (id)resolvingResultWithRespone:(id)value;

@end
