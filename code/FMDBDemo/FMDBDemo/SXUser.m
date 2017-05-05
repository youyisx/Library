//
//  SXUser.m
//  FMDBDemo
//
//  Created by jumei_vince on 17/4/27.
//  Copyright © 2017年 vince. All rights reserved.
//

#import "SXUser.h"

@implementation SXUser

- (NSString *)description
{
    return [NSString stringWithFormat:@"SXUser:uid->%d name:%@ des:%@ creatDate:%@", _uid,_name,_des,_creatDate];
}
@end
