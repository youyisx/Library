//
//  CSJSONRequestSerializer.m
//  JRWallet
//
//  Created by xxx on 2018/6/8.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "CSJSONRequestSerializer.h"
#import "CSJSONRequestHandle.h"
@interface CSJSONRequestSerializer()


@end

@implementation CSJSONRequestSerializer

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.requestHandle = [[CSJSONRequestHandle alloc] init];
    }
    return self;
}


-(NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                URLString:(NSString *)URLString
                               parameters:(id)parameters
                                    error:(NSError *__autoreleasing  _Nullable *)error{
    NSMutableURLRequest * request_ = [super requestWithMethod:method
                                                    URLString:URLString
                                                   parameters:parameters
                                                        error:error];
    if ([self.requestHandle respondsToSelector:@selector(timeoutInterval)]) {
        request_.timeoutInterval = [self.requestHandle  timeoutInterval];
    }
    if ([self.requestHandle respondsToSelector:@selector(headerFields)]) {
        NSDictionary * headers_ = [self.requestHandle headerFields];
        NSArray <NSString *>*keys = headers_.allKeys;
        for (NSString * key_ in keys) {
            NSString * value_ = [headers_[key_] description];
            if (value_.length) [request_ setValue:value_ forHTTPHeaderField:key_];
        }
    }
    return request_;
}
//
//#pragma mark --- request 之前的准备工作
//
//- (void)requestConfig{
//    
//    //    NSDictionary * headerField_ = [self headerField];
//    //    for (NSString * key in headerField_.allKeys) {
//    //        [self.sessionManager.requestSerializer setValue:[headerField_[key] description] forHTTPHeaderField:key];
//    //    }
//    //    NSString * cookieStr_ = nil;
//    //    NSDictionary * cookies = [self cookie];
//    //    if (self.commonCookies&&[self.commonCookies isKindOfClass:[JRCommonCookie class]]) {
//    //        [self.commonCookies appendCookies:cookies];
//    //        cookieStr_ = self.commonCookies.cookies;
//    //    }else{
//    //        cookieStr_ = [JRCommonCookie cookiesWithParam:cookies];
//    //    }
//    //
//    //    if (cookieStr_.length > 0) {
//    //        [self.sessionManager.requestSerializer setValue:cookieStr_ forHTTPHeaderField:@"Cookie"];
//    //    }
//}

@end
