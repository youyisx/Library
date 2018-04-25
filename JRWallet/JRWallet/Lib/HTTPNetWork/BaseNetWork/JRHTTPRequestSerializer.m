//
//  JRHTTPRequestSerializer.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRHTTPRequestSerializer.h"

@implementation JRHTTPRequestSerializer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeoutInterval = 10.f;//设置超时时间
        [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }
    return self;
}

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error{
    NSMutableURLRequest * request_ = [super requestWithMethod:method
                                                    URLString:URLString
                                                   parameters:parameters
                                                        error:error];
    //此处可对request 做修改
    
    return request_;
}

@end
