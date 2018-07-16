//
//  NSString+JMParams.h
//  JuMei
//
//  Created by vince on 2016/12/1.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CSParams)

- (NSDictionary *)params;
- (NSString *)objectForKeyedSubscript:(NSString *)key;

@end
