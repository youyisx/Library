//
//  CSJSONResponseHandle.m
//  JRWallet
//
//  Created by Primeledger on 2018/6/11.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "CSJSONResponseHandle.h"

@implementation CSJSONResponseHandle

-(id)cs_responseWithResponse:(id)data{
    NSString * code = data[@"code"];
    id result_ = nil;
    if (code.integerValue != 1000) {
        NSString * message = data[@"msg"];
        result_ = [NSError errorWithDomain:@"com.coinsuper.responseError"
                                      code:code.integerValue
                                  userInfo:@{NSLocalizedDescriptionKey:message}];
    }else{
        result_ = data[@"data"];
    }
    
    return result_;
}

-(void)cs_responseFail:(NSError *)error{
    //
}

@end
