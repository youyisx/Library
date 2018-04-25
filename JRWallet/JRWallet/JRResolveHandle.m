//
//  JRResolveHandle.m
//  JRWallet
//
//  Created by jumei_vince on 2018/4/3.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRResolveHandle.h"
#import <MJExtension/MJExtension.h>
@implementation JRResolveHandle

+(id)jr_responseResolving:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = result[@"user_data_config"];
        JRResolveHandle * aa = [JRResolveHandle mj_objectWithKeyValues:dict];
        return aa;
    }
    return @(1);
}

-(NSString *)description{
    return [[self mj_keyValues] description];
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
@end
