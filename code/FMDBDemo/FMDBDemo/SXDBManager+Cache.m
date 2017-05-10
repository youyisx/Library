//
//  SXDBManager+Cache.m
//  FMDBDemo
//
//  Created by jumei_vince on 17/5/9.
//  Copyright © 2017年 vince. All rights reserved.
//

#import "SXDBManager+Cache.h"
#import "SXDBLoop.h"
#import <objc/runtime.h>

@implementation SXDBManager (Cache)
@dynamic isLoop,loopTime;
#pragma mark --get/set func
-(double)loopTime{
    return [self dbLoop].loopTime;
}

-(void)setLoopTime:(double)loopTime{
    [self dbLoop].loopTime = loopTime;
}

-(BOOL)isLoop{
    return [self dbLoop].isLoop;
}
#pragma mark ---public func

- (void)initialConfiguration{
    [self cacheUsers];
    [self dbLoop];
    [self semaphore];
}

- (void)delayAddUser:(SXUser *)user{
    [self delayAddUsers:@[user]];
}

- (void)delayAddUsers:(NSArray <SXUser *>*)users {
    [self semaphoreLock:^{
        
        [[self cacheUsers] addObjectsFromArray:users];
        
        if (!self.isLoop) {
            __typeof(self) __weak wSelf = self;
            [[self dbLoop] activeDBLoopWithAsyncLoopBlock:^{
                
                [wSelf semaphoreLock:^{
                    NSArray * list = [wSelf cacheUsers].copy;
                    if (list.count == 0) {
                        [[wSelf dbLoop] destroyDBLoop];
                        return;
                    }
                    NSLog(@"开始添加 %lu 个数据",(unsigned long)list.count);
                    [[wSelf cacheUsers] removeAllObjects];
                    [wSelf addUsers:list];
                    
                }];
                
            }];
        }
        
    }];
}
#pragma mark ---private func

- (NSMutableArray *)cacheUsers{
    NSMutableArray * list = objc_getAssociatedObject(self, "org.sxdbmanager.cacheUsers");
    if (!list) {
        list = @[].mutableCopy;
        objc_setAssociatedObject(self, "org.sxdbmanager.cacheUsers", list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return list;
}

- (SXDBLoop *)dbLoop{
    SXDBLoop * loop = objc_getAssociatedObject(self, "org.sxdbmanager.dbloop");
    if (!loop) {
        loop = [[SXDBLoop alloc] init];
        objc_setAssociatedObject(self, "org.sxdbmanager.dbloop", loop, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return loop;
}

- (dispatch_semaphore_t)semaphore{
    dispatch_semaphore_t s = objc_getAssociatedObject(self, "org.sxdbmanager.semaphore");
    if (!s) {
        s = dispatch_semaphore_create(1);
        objc_setAssociatedObject(self, "org.sxdbmanager.semaphore", s, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return s;
}

- (void)semaphoreLock:(void(^)())block{
    dispatch_semaphore_wait([self semaphore], DISPATCH_TIME_FOREVER);
    !block?:block();
    dispatch_semaphore_signal([self semaphore]);
}

@end
