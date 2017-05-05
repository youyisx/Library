//
//  SXUser.h
//  FMDBDemo
//
//  Created by jumei_vince on 17/4/27.
//  Copyright © 2017年 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXUser : NSObject
@property (nonatomic, assign)int uid;
@property (nonatomic, copy)  NSString * name;
@property (nonatomic, copy)  NSString * des;
@property (nonatomic, strong) NSDate * creatDate;
@end
