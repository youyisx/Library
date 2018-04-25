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
#import "JRHTTPSessionManager.h"

#import "JRCommonCookie.h"

#import "AFHTTPSessionManager+JR_RACSupport.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import <MJExtension/MJExtension.h>


@interface JRBaseAPI()

@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;

@property (nonatomic, copy, class) NSString * cacheHost;

@property (nonatomic, strong) RACCommand * requestCommand;

@end

@implementation JRBaseAPI
@dynamic timeoutInterval;

#pragma mark --- http config
+(void)setCacheHost:(NSString *)cacheHost{
    if ([cacheHost isKindOfClass:[NSString class]]||cacheHost == nil) {
        objc_setAssociatedObject([self class], "jr_api_host", cacheHost,OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

+ (NSString *)cacheHost{
    return objc_getAssociatedObject([self class], "jr_api_host");
}

+ (void)registerHost:(NSString *)host{
    self.cacheHost = host;
}

+(NSString *)host{
    
    NSString * host_ =self.cacheHost;
    if (host_) return host_;
    
    Class targetClass = [self superclass];
    while (!host_&&targetClass&&targetClass != [NSObject class]) {
        @autoreleasepool{
            if ([targetClass respondsToSelector:@selector(cacheHost)])host_ = [targetClass cacheHost];
            if (host_){
                self.cacheHost = host_;
            }else{
                targetClass = [targetClass superclass];
            }
        }
    }
    
    return host_;
}

//
//+ (AFHTTPSessionManager *)sessionManager{
//    return objc_getAssociatedObject([self class], "jr_http_sessionmanager");
//}
//
//+(void)setSessionManager:(AFHTTPSessionManager *)sessionManager{
//    objc_setAssociatedObject([self class], "jr_http_sessionmanager", sessionManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

+(AFHTTPSessionManager *)shareHttpSessionManager{
    NSURL * baseURL = [NSURL URLWithString:[[self class] host]];
    NSAssert(baseURL, @"<%@> host不存在...",[self class]);
    AFHTTPSessionManager * sessionManager_ = [[JRHTTPSessionManager alloc] initWithBaseURL:baseURL];
    return sessionManager_;
}

#pragma mark --- life
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.sessionManager = [self httpSessionManager];
        _commonCookies = [JRCommonCookie commonCookieWithDomain:nil];
        _httpMethod = JRAPIHTTPMethod_POST;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark --- get && set
-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval{
    self.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

-(NSTimeInterval)timeoutInterval{
    return self.sessionManager.requestSerializer.timeoutInterval;
}
#pragma mark --- request 之前的准备工作

- (void)requestConfig{
    
    NSDictionary * headerField_ = [self headerField];
    for (NSString * key in headerField_.allKeys) {
        [self.sessionManager.requestSerializer setValue:[headerField_[key] description] forHTTPHeaderField:key];
    }
    NSString * cookieStr_ = nil;
    NSDictionary * cookies = [self cookie];
    if (self.commonCookies&&[self.commonCookies isKindOfClass:[JRCommonCookie class]]) {
        [self.commonCookies appendCookies:cookies];
        cookieStr_ = self.commonCookies.cookies;
    }else{
        cookieStr_ = [JRCommonCookie cookiesWithParam:cookies];
    }
    
    if (cookieStr_.length > 0) {
        [self.sessionManager.requestSerializer setValue:cookieStr_ forHTTPHeaderField:@"Cookie"];
    }
}



#pragma mark --- send request

- (RACSignal *)request:(NSDictionary *)param{
    return [self request:param cancel:nil];
}

- (RACSignal *)request:(NSDictionary *)param
                cancel:(RACSignal *)cancel{
    [self requestConfig];
    NSMutableDictionary * totalParam_ = [self commonParam].mutableCopy;
    if ([param isKindOfClass:[NSDictionary class]]) [totalParam_ addEntriesFromDictionary:param];
    NSDictionary * lastParam_ = [self adjustTotalParam:totalParam_];
    RACSignal * signal = nil;
    if ([self.httpMethod isEqualToString:JRAPIHTTPMethod_GET]) {
        signal = [[self.sessionManager jr_rac_GET:[self path] parameters:lastParam_] takeUntil:cancel];
    }else if ([self.httpMethod isEqualToString:JRAPIHTTPMethod_POST]){
        signal = [[self.sessionManager jr_rac_POST:[self path] parameters:lastParam_] takeUntil:cancel];
    }
    signal = [[signal map:^id(id value) {
        return [self resolvingResultWithRespone:value];
    }] replayLast];
    
    return signal;
}

#pragma mark --- resolving
- (id)resolvingResultWithRespone:(id)value{

    NSString * resolvObject_ = [self responseResolvingModel];
    //需要解析成model的class名称；或者需要自定义解析数据并且实现了"+(id)responseResolving:(id)result"函数的class名称
    
    if (resolvObject_&&[resolvObject_ isKindOfClass:[NSString class]]) {
        __strong Class resolvC = NSClassFromString(resolvObject_);
        SEL ss = NSSelectorFromString(@"jr_responseResolving:");
        if (resolvC&&[resolvC respondsToSelector:ss]) {
            Method method = class_getClassMethod(resolvC, ss);
            char type[512] = {};
            method_getReturnType(method, type, 512);
            NSString * resultType = [[NSString alloc] initWithCString:type encoding:NSUTF8StringEncoding];
            if ([resultType hasPrefix:@"@"]) {
                __strong id responeParam = value;
                id(*_method_invoke_res)(Class,Method,id) = (id(*)(Class,Method,id))method_invoke;
                return  _method_invoke_res(resolvC,method,responeParam);
            }
        }else{
            if ([value isKindOfClass:[NSArray class]]) {
                return [resolvC mj_objectArrayWithKeyValuesArray:value];
            }else if ([value isKindOfClass:[NSDictionary class]]){
                return [resolvC mj_objectWithKeyValues:value];
            }
        }
    }
    return  value;
}

#pragma mark --- extend param

/** 以下函数 字类可根据需求进行重载 */

/** API PATH */
- (NSString *)path{
    return @"";
}

/** API Request 相关json参数 */
- (NSDictionary *)commonParam{
    return @{};
}

/** cookie 追加参数 */
- (NSDictionary *)cookie{
    return @{};
}

/** header 追加参数 */
- (NSDictionary *)headerField{
    return @{};
}

/** 发入请求前，最后一次调整参数的机会 */
- (NSDictionary *)adjustTotalParam:(NSDictionary *)param{
    return param;
}


@end
