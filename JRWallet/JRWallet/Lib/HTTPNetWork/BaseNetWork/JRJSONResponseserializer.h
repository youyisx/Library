//
//  JRJSONResponseserializer.h
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "JRResponseAnalyse.h"

@interface JRJSONResponseserializer : AFJSONResponseSerializer

@property (nonatomic, strong) JRResponseAnalyse * responseAnalyse;

@end
