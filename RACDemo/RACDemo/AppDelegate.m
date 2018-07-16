//
//  AppDelegate.m
//  RACDemo
//
//  Created by jumei_vince on 2018/1/30.
//  Copyright © 2018年 vince. All rights reserved.
//

#import "NSString+CSParams.h"
#import "AppDelegate.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <KVOController/KVOController.h>

@interface SXSignal:RACSubject

@end

@implementation SXSignal

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end


@interface TestModel:NSObject

@end

@implementation TestModel

- (void)log:(id)a{
    NSLog(@"%s_:%@",__FUNCTION__,a);
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end

@interface AppDelegate ()

@property (nonatomic, copy) NSString * test;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"----%s",__FUNCTION__);
    
//    [[RACSignal return:@"title"] subscribeNext:^(id x) {
//        
//        NSLog(@"x:%@",x);
//    }];
    
//
//    NSString * aa = @"coinSuper://router/page?action=1&label=2&name=yuo&id=99";
//    NSDictionary * dic = [aa params];
//    NSString * r_ = aa[@"name"];
    
    
//    RACSignal * s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//       NSLog(@"执行s");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"send s");
//            [subscriber sendError:[NSError errorWithDomain:@"xx" code:0 userInfo:@{}]];
////            [subscriber sendNext:@(1)];
////            [subscriber sendCompleted];
//        });
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"s dis");
//        }];
//    }];
//
//    [[s flattenMap:^RACStream *(id value) {
//        NSLog(@"value:%@",value);
//        return nil;
//    }] subscribeNext:^(id x) {
//        NSLog(@"result:%@",x);
//    } error:^(NSError *error) {
//        NSLog(@"error:%@",error);
//    }];
    
//
//    RACSignal * s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"执行s1");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@(1)];
//            [subscriber sendCompleted];
////            [subscriber sendError:nil];
//        });
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"s1 --disposable");
//        }];
//    }];
//    RACSignal * s2 =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"执行s2");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@(2)];
//            [subscriber sendCompleted];
//        });
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"s2 --disposable");
//        }];
//    }];
//    NSLog(@"订阅then");
//    [[s1 then:^RACSignal *{
//        NSLog(@"准备返回s2");
//        return s2;
//    }] subscribeNext:^(id x) {
//        NSLog(@"x-->%@",x);
//
//    } error:^(NSError *error) {
//        NSLog(@"error:%@",error);
//
//    }];
//    [[[s1 concat:s2] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
//        NSLog(@"x-->%@",x);
//    } error:^(NSError *error) {
//        NSLog(@"error:%@",error);
//    }];
    
//    RACSignal *s2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"执行 s2");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@(1)];
//            [subscriber sendCompleted];
//        });
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"s2 dis");
//        }];
//    }];
//
//
//    [[s1 zipWith:s2] subscribeNext:^(id x) {
//        NSLog(@"x:%@",x);
//
//    } error:^(NSError *error) {
//        NSLog(@"error:%@",error);
//
//    }];
    
    return YES;
    
}


-(void)application:(UIApplication *)application
performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem
 completionHandler:(nonnull void (^)(BOOL))completionHandler{
    NSLog(@"shortcutItem:%@",shortcutItem);
    
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
