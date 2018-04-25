//
//  JRResponseAnalyse.h
//  JRWallet
//
//  Created by jumei_vince on 2018/4/4.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRHTTPError.h"

@interface JRResponseAnalyse : NSObject

@property (nonatomic, copy) NSString * successCodeKey;

@property (nonatomic, copy) NSString * successCode;

@property (nonatomic, copy) NSString * resultKey;

@property (nonatomic, copy) NSString * messageKey;

+ (instancetype)responseAnalyseWithSuccessCodeKey:(NSString *)codeKey
                                      successCode:(NSString *)code
                                        resultKey:(NSString *)resultKey
                                       messageKey:(NSString *)messageKey;

- (id)analyseResponseVluae:(id)value error:(NSError *__autoreleasing *)error;


@end
