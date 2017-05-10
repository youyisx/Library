//
//  SXDBManager.h
//  FMDBDemo
//
//  Created by jumei_vince on 17/4/27.
//  Copyright © 2017年 vince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXUser.h"
@interface SXDBManager : NSObject

+ (instancetype)shareDBManager;

- (void)addUser:(SXUser *)user;

- (void)deleteUser:(NSString *)uid;

- (void)userList:(void(^)(NSArray <SXUser *>*list))block;
//批量处理
- (void)addUsers:(NSArray <SXUser *>*)users;

- (void)deleteUsers:(NSArray *)uids;
@end
