//
//  SXDBManager+Cache.h
//  FMDBDemo
//
//  Created by jumei_vince on 17/5/9.
//  Copyright © 2017年 vince. All rights reserved.
//

#import "SXDBManager.h"

@interface SXDBManager (Cache)

@property (nonatomic)   double loopTime;

@property (nonatomic,readonly) BOOL isLoop;

- (void)delayAddUser:(SXUser *)user;

- (void)delayAddUsers:(NSArray <SXUser *>*)users;

@end
