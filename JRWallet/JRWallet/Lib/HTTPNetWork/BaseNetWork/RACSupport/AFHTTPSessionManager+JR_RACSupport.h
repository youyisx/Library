//
//  AFHTTPSessionManager+JR_RACSupport.h
//  JRWallet
//
//  Created by jumei_vince on 2018/4/4.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AFHTTPSessionManager (JR_RACSupport)

- (RACSignal *)jr_rac_GET:(NSString *)path parameters:(id)parameters;

- (RACSignal *)jr_rac_POST:(NSString *)path parameters:(id)parameters;


@end
