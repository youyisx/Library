//
//  SXDBLoop.m
//  FMDBDemo
//
//  Created by jumei_vince on 17/5/10.
//  Copyright © 2017年 vince. All rights reserved.
//

#import "SXDBLoop.h"
@interface SXDBLoop()
{
    dispatch_source_t _timer;
    dispatch_queue_t  _queue;
}
@end
@implementation SXDBLoop
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loopTime = 1.0;
        _queue = dispatch_queue_create("org.sxdbloop.queue", NULL);
    }
    return self;
}

-(void)setLoopTime:(double)loopTime{
    if (loopTime >0) {
        _loopTime = loopTime;
    }
}

-(BOOL)isLoop{
    return _timer?YES:NO;
}

-(void)activeDBLoopWithAsyncLoopBlock:(void(^)())block{
    [self destroyDBLoop];
    double period = self.loopTime; //设置时间间隔
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,_queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),period*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        //@"倒计时结束，关闭"
        //dispatch_source_cancel(timer);
        !block?:block();
    });
    dispatch_resume(timer);
    _timer = timer;
    NSLog(@"启动循环");
}

- (void)destroyDBLoop{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        NSLog(@"停止循环");
    }
}

@end
