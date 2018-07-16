//
//  JRBaseAPI+HostConfig.m
//  JRWallet
//
//  Created by Primeledger on 2018/6/8.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRBaseAPI+Config.h"
#import <AFNetworking/AFNetworking.h>
@implementation JRBaseAPI (Config)

#pragma mark --- host config
+ (NSMutableDictionary *)cacheHostDic{
    static NSMutableDictionary * dic_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic_ = @{}.mutableCopy;
    });
    return dic_;
}

+(void)setCacheHost:(NSString *)cacheHost{
    if (cacheHost&&![cacheHost isKindOfClass:[NSString class]]) {
        NSLog(@"config Host Error:%@",cacheHost);
        return;
    }
    [self cacheHostDic][NSStringFromClass([self class])] = cacheHost;
}

+ (NSString *)cacheHost{
    return [self cacheHostDic][NSStringFromClass([self class])];
}

+ (void)registerHost:(NSString *)host{
    self.cacheHost = host;
}

+(NSString *)host{
    NSString * host_ = nil;
    Class hostClass = [self class];
    while (!host_&&hostClass) {
        if ([hostClass respondsToSelector:@selector(cacheHost)]) {
            host_ = [hostClass cacheHost];
            hostClass = [hostClass superclass];
        }else{
            break;
        }
    }
    return host_;
}
#pragma mark ----

+ (NSMutableDictionary *)sessionManagers{
    static NSMutableDictionary * dic_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic_ = @{}.mutableCopy;
    });
    return dic_;
}

+ (void)registerAFHTTPSessionManager:(AFHTTPSessionManager *)manager{
    [self sessionManagers][NSStringFromClass([self class])] = manager;
}

+ (AFHTTPSessionManager *)cacheManager{
    NSMutableDictionary * managerDic_ = [JRBaseAPI sessionManagers];
    return managerDic_[NSStringFromClass([self class])];
}

- (AFHTTPSessionManager *)sessionManager{
    NSMutableDictionary * managerDic_ = [JRBaseAPI sessionManagers];
    Class  key_Class = [self class];
    AFHTTPSessionManager * manager_ = nil;
    while (!manager_&&key_Class&&[key_Class respondsToSelector:@selector(cacheManager)]) {
        manager_ = [key_Class cacheManager];
        key_Class = [key_Class superclass];
    }
    if (manager_) managerDic_[NSStringFromClass([self class])] = manager_;
    return manager_;
}




@end
