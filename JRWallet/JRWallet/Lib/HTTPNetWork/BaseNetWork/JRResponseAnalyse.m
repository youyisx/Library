//
//  JRResponseAnalyse.m
//  JRWallet
//
//  Created by jumei_vince on 2018/4/4.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRResponseAnalyse.h"

@implementation JRResponseAnalyse

+ (instancetype)responseAnalyseWithSuccessCodeKey:(NSString *)codeKey
                                      successCode:(NSString *)code
                                        resultKey:(NSString *)resultKey
                                       messageKey:(NSString *)messageKey{
    JRResponseAnalyse * analyse_ = [JRResponseAnalyse new];
    analyse_.successCode = code;
    analyse_.successCodeKey = codeKey;
    analyse_.resultKey = resultKey;
    analyse_.messageKey = messageKey;
    return analyse_;
}

#pragma mark --- safe get
-(id)successCode{
    if (_successCode == nil) _successCode = @"";
    return _successCode;
}

-(NSString *)successCodeKey{
    if (_successCodeKey == nil) _successCodeKey = @"";
    return _successCodeKey;
}

- (NSString *)resultKey{
    if (_resultKey == nil) _resultKey = @"";
    return _resultKey;
}

-(NSString *)messageKey{
    if (_messageKey == nil) _messageKey = @"";
    return _messageKey;
}

#pragma mark ---

- (BOOL)matchingSuccessCode:(id)code{
    if ([code isKindOfClass:[NSString class]]) {
        return [self.successCode isEqualToString:code];
    }else if ([code isKindOfClass:[NSNumber class]]){
        return ([self.successCode intValue] == [code intValue]);
    }
    return NO;
}

#pragma mark --- analyse
-(id)analyseResponseVluae:(id)value error:(NSError *__autoreleasing *)error{
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultJson = (NSDictionary *)value;
        id jsonCode_ = resultJson[self.successCodeKey];
        NSString *jsonMessage_ = [resultJson[self.messageKey] description];
        if (![self matchingSuccessCode:jsonCode_]) {
            NSMutableDictionary *userInfo_ = [NSMutableDictionary dictionary];
            jsonMessage_ = jsonMessage_.length > 0 ? jsonMessage_:@"未知错误";
            [userInfo_ setValue:[NSString stringWithFormat:NSLocalizedStringFromTable(@"%@", @"Mall", nil), jsonMessage_]
                         forKey:NSLocalizedDescriptionKey];
            [userInfo_ setValue:resultJson
                         forKey:@"response"];
            *error = [NSError errorWithDomain:JRJSONErrorDomain
                                         code:JRJSONErrorResultError
                                     userInfo:userInfo_];
            return nil;
        }else{
            id result = resultJson[self.resultKey];
            if (![result isKindOfClass:[NSDictionary class]]&&![result isKindOfClass:[NSArray class]]) result = resultJson;
            return result;
        }
        
    }else {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:[NSString stringWithFormat:NSLocalizedStringFromTable(@"%@", @"Mall", nil),@"对不起，服务器发生错误。请稍后再试。"]
                    forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:JRJSONErrorDomain
                                     code:JRJSONErrorUnkonw
                                 userInfo:userInfo];
        return nil;
    }
    return nil;
}

@end
