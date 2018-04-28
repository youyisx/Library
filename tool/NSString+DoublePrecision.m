//
//  NSString+DoublePrecision.m
//  Test
//
//  Created by vince on 2018/4/28.
//  Copyright © 2018年 vince. All rights reserved.
//

#import "NSString+DoublePrecision.h"



@implementation NSString (DoublePrecision)


+(NSString *)decimalNumberWithDouble:(double)value{
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", value];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

-(double)precisionUnit{
    if (self.doubleValue == 0) return 1.f;
    NSString * tempString = [NSString decimalNumberWithDouble:self.doubleValue];
    NSRange range = [tempString rangeOfString:@"."];
    if (range.length == 0) return 1.0f;
    NSUInteger length = tempString.length - (range.location+range.length);
    int denominator = 1;
    while (length > 0) {
        denominator *=10;
        length--;
    }
    return 1.0/denominator;
}

/**
 按有效单位递增
 
 @return 递增后的精度字符串
 */
- (NSString *)add{
    return [NSString decimalNumberWithDouble:(self.doubleValue + [self precisionUnit])];
}

/**
 按有效单位递减
 
 @return 递减后的精度字符串
 */
- (NSString *)subtract{
    return [NSString decimalNumberWithDouble:(self.doubleValue - [self precisionUnit])];
}


- (NSString *)add:(double)value{
    return [NSString decimalNumberWithDouble:(self.doubleValue + value)];

}


- (NSString *)subtract:(double)value{
    return [NSString decimalNumberWithDouble:(self.doubleValue - value)];
}
@end
