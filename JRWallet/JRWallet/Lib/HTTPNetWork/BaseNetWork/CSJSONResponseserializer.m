//
//  JRJSONResponseserializer.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "CSJSONResponseserializer.h"
#import "CSJSONResponseHandle.h"
@implementation CSJSONResponseserializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.acceptableContentTypes = [NSSet setWithObjects:
                                       @"application/json",
                                       @"text/json",
                                       @"text/javascript",
                                       @"text/html",
                                       @"text/plain",
                                       nil
                                       ];
        self.responseHandle = [[CSJSONResponseHandle alloc] init];
    }
    return self;
}

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error{
    id json_ = [super responseObjectForResponse:response data:data error:error];
    if (*error){
        [self.responseHandle cs_responseFail:*error];
        return nil;
    }

    if (self.responseHandle) json_ = [self.responseHandle cs_responseWithResponse:json_];
    if ([json_ isKindOfClass:[NSError class]]) {
        *error = json_;
        json_ = nil;
        [self.responseHandle cs_responseFail:*error];
    }else{
        //缓存服务器响应的cookies信息
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSArray *cookies_ = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields]
                                                                   forURL:httpResponse.URL];
        for (NSHTTPCookie *cookie in cookies_) {
            NSMutableDictionary * cookieProperties = [[cookie properties] mutableCopy];
            NSHTTPCookie *newCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:newCookie];
        }
    }
    return json_;
}

@end
