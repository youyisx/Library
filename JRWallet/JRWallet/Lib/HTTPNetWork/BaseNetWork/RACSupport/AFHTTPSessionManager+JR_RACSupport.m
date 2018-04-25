//
//  AFHTTPSessionManager+JR_RACSupport.m
//  JRWallet
//
//  Created by jumei_vince on 2018/4/4.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "AFHTTPSessionManager+JR_RACSupport.h"

@implementation AFHTTPSessionManager (JR_RACSupport)

- (RACSignal *)jr_rac_GET:(NSString *)path parameters:(id)parameters{
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSURLSessionDataTask * task = [self jr_getRequest:path param:parameters subscriber:subscriber];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"cancel task");

            if (task.state != NSURLSessionTaskStateCompleted){
                [task cancel];}
            NSLog(@"cancel task 1");

        }];
    }] setNameWithFormat:@"<%@> -RAC_GET:%@,param:%@",self.class,path,parameters];
}

- (RACSignal *)jr_rac_POST:(NSString *)path parameters:(id)parameters{
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSURLSessionDataTask * task = [self jr_postRequest:path param:parameters subscriber:subscriber];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"cancel task");

            if (task.state != NSURLSessionTaskStateCompleted){
                [task cancel];
                NSLog(@"cancel task 1");

            }
            
        }];
    }] setNameWithFormat:@"<%@> -RAC_POST:%@,param:%@",self.class,path,parameters] ;
}

#pragma mark --- Private

- (NSURLSessionDataTask *)jr_postRequest:(NSString *)path
                                   param:(NSDictionary *)param_
                              subscriber:(id<RACSubscriber>) subscriber{
    NSURLSessionDataTask * sessionTask =
    [self POST:path
    parameters:param_
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [subscriber sendNext:responseObject];
           [subscriber sendCompleted];
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [subscriber sendError:error];
       }];
    return sessionTask;
}

- (NSURLSessionDataTask *)jr_getRequest:(NSString *)path
                                  param:(NSDictionary *)param_
                             subscriber:(id<RACSubscriber>) subscriber{
    NSURLSessionDataTask * sessionTask =
    [self GET:path
   parameters:param_
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [subscriber sendNext:responseObject];
          [subscriber sendCompleted];
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          [subscriber sendError:error];
      }];
    return sessionTask;
}
@end
