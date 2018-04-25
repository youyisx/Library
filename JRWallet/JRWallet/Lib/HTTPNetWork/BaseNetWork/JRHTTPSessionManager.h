//
//  JRHTTPSessionManager.h
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**
 大家注意哈 AFHTTPSessionManager(>3.0) 这玩意儿有坑，manager无法释放，只能以单例的形式存在
 */
@interface JRHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)jr_shareHTTPSessionManager;

@end
