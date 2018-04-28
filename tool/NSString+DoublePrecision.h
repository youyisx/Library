//
//  NSString+DoublePrecision.h
//  Test
//
//  Created by vince on 2018/4/28.
//  Copyright © 2018年 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DoublePrecision)


/**
 此方法用于将有效的double 数据转换成未丢失精度的字条串

 @param value double数据
 @return 有效精度的字符串
 */
+(NSString *)decimalNumberWithDouble:(double)value;

/**
 获取有效的小数单位
 e.g -> 1.81  单位为:0.01; 1.8111 单位为:0.0001; 1.800 单位为:0.1
 @return 有效小数单位
 */
-(double)precisionUnit;

/**
 按有效单位递增

 @return 递增后的精度字符串
 */
- (NSString *)add;

/**
 按有效单位递减

 @return 递减后的精度字符串
 */
- (NSString *)subtract;


- (NSString *)add:(double)value;


- (NSString *)subtract:(double)value;

@end
