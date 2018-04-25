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

@class AFHTTPSessionManager,JRCommonCookie;
@interface JRBaseAPI : NSObject

@property (nonatomic, assign)NSInteger tag;//标识符

/** HTTP请求方式 ，默认为 JRAPIHTTPMethod_POST */
@property (nonatomic, copy) NSString * httpMethod;

/** 默认公共cookies */
@property (nonatomic,strong)JRCommonCookie * commonCookies;

/** 自动解析成model对象
 1.需要解析成model的class名称；
 2.或者需要自定义解析数据并且实现了"+(id)responseResolving:(id)result"函数的class名称
 */
@property (nonatomic, copy) NSString * responseResolvingModel;

/** request 超时时间设置 */
@property (nonatomic) NSTimeInterval timeoutInterval;


/** 注册API的HOST，父类注册，对子类仍然有效 */
+ (void)registerHost:(NSString *)host;

/**
 配合registerHost使用，BaseAPI内部通过类继承结构递归找到所对应的host,子类无需重载
 @return 对应class的host
 */
+ (NSString *)host;

/** 以下函数 子类均可根据需求进行重载 */

/** 这应该是个单例哈，sessiomManager （>3.0）这玩意儿本身内部有泄漏，对象无法释放，只能按单例来解决
 sessionManager{ 内部自定了request,response的相关配置类，子类如果需要重载，请酌情考虑 }
 @return AFHTTPSessionManager
 */
+ (AFHTTPSessionManager *)shareHttpSessionManager;


/**
 发起请求

 @param param 参数
 @return 任务信号
 */
- (RACSignal *)request:(NSDictionary *)param;

- (RACSignal *)request:(NSDictionary *)param
                cancel:(RACSignal *)cancel;


#pragma mark --- 按业务需求可自由重载以下函数

/** API PATH */
- (NSString *)path;

/** API Request 相关固定参数 */
- (NSDictionary *)commonParam;

/** cookie 追加的cookie */
- (NSDictionary *)cookie;

/** header 追加的header */
- (NSDictionary *)headerField;

/** 发入请求前，最后一次调整参数的机会 */
- (NSDictionary *)adjustTotalParam:(NSDictionary *)param;


@end
