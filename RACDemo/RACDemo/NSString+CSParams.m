//
//  NSString+JMParams.m
//  JuMei
//
//  Created by vince on 2016/12/1.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "NSString+CSParams.h"
#import <objc/runtime.h>
@implementation NSString (CSParams)

- (NSDictionary *)params {
    if (self.length == 0) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSArray *components = [url.query componentsSeparatedByString:@"&"];
    if (components.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    for (NSString *str in components) {
        NSArray *subComponents = [str componentsSeparatedByString:@"="];
        if (subComponents.count != 2) {
            continue;
        }
        NSString *key = subComponents[0];
        NSString *value = subComponents[1];
        if (!key || !value) {
            continue;
        }
        params[key] = [value stringByRemovingPercentEncoding];
    }
    return params;
}

- (NSString *)objectForKeyedSubscript:(NSString *)key {
    NSDictionary *params = objc_getAssociatedObject(self, @selector(params));
    BOOL anyParams = YES;
    if (!params) {
        params = [self params];
        anyParams = NO;
    }
    
    if (!params || params.count == 0) {
        return nil;
    }
    
    if (!anyParams) {
        objc_setAssociatedObject(self, @selector(params), params, OBJC_ASSOCIATION_RETAIN);
    }
    
    return params[key];
}

@end
