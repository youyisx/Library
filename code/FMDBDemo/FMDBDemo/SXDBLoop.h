//
//  SXDBLoop.h
//  FMDBDemo
//
//  Created by jumei_vince on 17/5/10.
//  Copyright © 2017年 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXDBLoop : NSObject

@property (nonatomic,  assign) double loopTime;// default 1, value > 0
@property (nonatomic,readonly) BOOL isLoop;


-(void)activeDBLoopWithAsyncLoopBlock:(void(^)())block;

- (void)destroyDBLoop;

@end
