//
//  JRJSONResponseserializer.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRJSONResponseserializer.h"

@implementation JRJSONResponseserializer

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
        self.responseAnalyse = [JRResponseAnalyse responseAnalyseWithSuccessCodeKey:@"code"
                                                                        successCode:@"0"
                                                                          resultKey:@"data"
                                                                         messageKey:@"message"];
    }
    return self;
}

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error{
    id json = [super responseObjectForResponse:response data:data error:error];
    //此处对返回数据做统一处理...
    if (*error != nil) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:[NSString stringWithFormat:NSLocalizedStringFromTable(@"%@", @"Mall", nil),@"对不起，服务器发生错误。请稍后再试。"]
                    forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:JRJSONErrorDomain
                                     code:JRJSONErrorUnkonw
                                 userInfo:userInfo];
        return nil;
    }
    if (self.responseAnalyse) {
        json = [self.responseAnalyse analyseResponseVluae:json error:error];
        if (json) {
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
        return json;
    }
    return json;
}

@end
