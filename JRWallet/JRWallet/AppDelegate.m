//
//  AppDelegate.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "CSAPI.h"
#import "JRBaseAPI+Config.h"
#import "CSNetWorkManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    RACSignal * signale = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"信号开始执行");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@(1)];
            [subscriber sendCompleted];
            NSLog(@"信号执行完成");
        });
        return nil;
    }];
    
    
    
    NSLog(@"信号创建完成");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"--->订阅信号");
        [signale subscribeNext:^(id x) {
            NSLog(@"收到信号：%@",x);
        }];
    });
    
//    AFHTTPSessionManager * ss = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    RACSignal * signal_ = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@"2"];
//            [subscriber sendCompleted];
//        });
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"信号over了。。。");
//        }];
//    }];
//
//    [[signal_ takeUntil:ss.rac_willDeallocSignal] subscribeNext:^(id x) {
//        NSLog(@"-->%@",x);
//    }];
//
//    [ss POST:@"s" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success:%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error:%@",error);
//    }];
    
    AFHTTPSessionManager * manager_ = [CSNetWorkManager sessionManagerWithHost:@"http://10.200.172.67:50006"
                                                                 RequestHandle:nil
                                                                ResponseHandle:nil];
    
    [JRBaseAPI registerAFHTTPSessionManager:manager_];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
