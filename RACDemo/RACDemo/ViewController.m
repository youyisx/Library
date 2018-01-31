//
//  ViewController.m
//  RACDemo
//
//  Created by jumei_vince on 2018/1/30.
//  Copyright © 2018年 vince. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TestViewController.h"
@interface ViewController ()<TestProtocal>

@property (nonatomic, copy) NSString * value;
@property (nonatomic, copy) NSString * value2;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    TestViewController * vc = [TestViewController new];
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //监听方法调用实现原理（rac内部通过runloop，在原函数名加前缀"rac_alias_"生成新函数，跟原函数做函数交换，然后外部调用原函数，实则调用 到新函数，新函数内部再调回到原函数，再发送热信号给外部的订阅者）
    [[[self rac_signalForSelector:@selector(testConcat)] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"呵呵");
    }];
    
//    [self testMap];
//    [self testChannel];
//    [self testProtocal];
    

//    [self testConcat];
//    [self testMerge];
//    [self testCombineLatest];
//    [self testZip];
//    [self testDelay];
//    [self testReplay];
//    [self testTimer];
//    [self testRetry];
//    [self testThrottle];
//    [self RACReplaySubject];
    [self testSelectorSignal];
}

#pragma mark - 对数据做中间处理 映射  map

- (void)testMap{
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"123");
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[signal map:^id(id value) {
            NSLog(@"value:%@",value);
            return @"a";
        }] subscribeNext:^(id x) {
            NSLog(@"x:%@",x);
        }];
    });
    

}
#pragma mark - flattenMap 将原信号的值转换成新的信号发出来
-(void)testflattenMap{
    
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"打蛋液");
        [subscriber sendNext:@"蛋液"];
        [subscriber sendCompleted];
        return nil;
        
    }];
    
    //对信号进行秩序秩序的第一步
    siganl = [siganl flattenMap:^RACStream *(NSString *value) {
        //处理上一步的RACSiganl的信号value.这里的value=@"蛋液"
        NSLog(@"把%@倒进锅里面煎",value);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"煎蛋"];
            [subscriber sendCompleted];
            return nil;
            
        }];
        
    }];
    //对信号进行第二步处理
    siganl = [siganl flattenMap:^RACStream *(id value) {
        NSLog(@"把%@装载盘里",value);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"上菜"];
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    
    //最后打印 最后带有===上菜
    [siganl subscribeNext:^(id x) {
        NSLog(@"====%@",x);
    }];
    
}


#pragma mark -  按特定条件过滤  filter

- (void)testFilter{
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@(15)];
        [subscriber sendNext:@(17)];
        [subscriber sendNext:@(21)];
        [subscriber sendNext:@(14)];
        [subscriber sendNext:@(30)];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    //过滤信号,打印
    [[singal filter:^BOOL(NSNumber *value) {
        
        //大于18岁的,才可以通过
        return value.integerValue >= 18;//return为yes可以通过
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
    }];
    
}

#pragma mark - 双向绑定
- (void)testChannel{
    
    RACChannelTo(self,value) = RACChannelTo(self,value2);//双向绑定
//中间需要做一些映射转换的 双向绑定
//    RACChannelTerminal * channelA = RACChannelTo(self,value);
//    RACChannelTerminal * channelB = RACChannelTo(self,value2);
//
//
//
//    [[channelA map:^id(id value) {
//        NSLog(@"channelA map:%@",value);
//        if ([value isEqualToString:@"西"]) {
//            return @"东";
//        }
//        return value;
//    }] subscribe:channelB] ;
//
//    [[channelB map:^id(id value) {
//        NSLog(@"channelB map:%@",value);
//        if ([value isEqualToString:@"左"]) {
//            return @"右";
//        }
//        return value;
//    }] subscribe:channelA];
    
//    [[RACObserve(self, value) filter:^BOOL(id value) {
//        return value?YES:NO;
//    }] subscribeNext:^(id x) {
//        NSLog(@"你向%@",x);
//    }];
//
//    [[RACObserve(self, value2) filter:^BOOL(id value) {
//        return value ? YES: NO;
//    }] subscribeNext:^(id x) {
//        NSLog(@"他向%@",x);
//
//    }];
    
    self.value = @"西";
    NSLog(@"value2 %@",self.value2);
    self.value2 = @"左";
    NSLog(@"value %@",self.value);
}
#pragma mark - 通过RAC 实现 代理函数
- (void)testProtocal{
    
    //使用RAC代替代理时,rac_signalForSelector: fromProtocol:这个代替代理的方法使用时,切记要将self设为代理这句话放在订阅代理信号的后面写,否则会无法执行
    [[[self rac_signalForSelector:@selector(test:action:) fromProtocol:@protocol(TestProtocal)] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * x) {
        NSLog(@"x:%@",x);
        
    }];
}

#pragma mark - 两个信号串联,两个管串联,一个管处理完自己的东西,下一个管才开始处理自己的东西

- (void)testConcat{
    
    //两个信号串联,两个管串联,一个管处理完自己的东西,下一个管才开始处理自己的东西
    
    //创建一个信号管A
    RACSignal *siganlA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"asdf");
        [subscriber sendNext:@"吃饭"];
        [subscriber sendCompleted];
        return nil;
        
    }];
    
    //创建一个信号管B
    RACSignal *siganlB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"sdfsdfasdf");
        [subscriber sendNext:@"吃的饱饱的,才可以睡觉的"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //串联管A和管B (concat 通过内部先订单当前信号（自己），完成后再去触发订阅下一个信号)
    RACSignal *concatSiganl = [siganlA concat:siganlB];
    //串联后的接收端处理 ,两个事件,走两次,第一个打印siggnalA的结果,第二次打印siganlB的结果
    [concatSiganl subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
    }];

    
}
#pragma mark - 并联,只要有一个管有东西,就可以打印
- (void)testMerge{
    //创建信号A
    RACSignal *siganlA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"纸厂污水"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //创建信号B
    RACSignal *siganlB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"电镀厂污水"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //并联两个信号,根上面一样,分两次打印 (merge 内部将需要合并的信号，放到数组中，然后生成新的信号，新信号订阅后，for 执行数组中的各个信号)
    RACSignal *mergeSiganl = [RACSignal merge:@[siganlA,siganlB]];
    [mergeSiganl subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
}

#pragma mark - 组合 只有两个信号都有值,才可以组合
- (void)testCombineLatest{
    //定义2个自定义信号
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    
    //组合信号
    [[RACSignal combineLatest:@[letters,numbers] reduce:^(NSString *letter, NSString *number){
        
        return [letter stringByAppendingString:number];
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
    }];
    
    
    //自己控制发生信号值
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    [numbers sendNext:@"1"]; //打印B1
    [letters sendNext:@"C"];//打印C1
    [numbers sendNext:@"2"];//打印C2
    
    
    
}
#pragma mark - 合流压缩
- (void)testZip{
    
    //创建信号A
    RACSignal *siganlA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"红"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //创建信号B
    RACSignal *siganlB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//
        [subscriber sendNext:@"白"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //合流后处理的是压缩包,需要解压后才能取到里面的值
    [[siganlA zipWith:siganlB] subscribeNext:^(id x) {
        
        //解压缩
        RACTupleUnpack(NSString *stringA, NSString *stringB) = x;
        NSLog(@"%@ %@",stringA, stringB);
    }];
    
}

#pragma mark - 命令 RACCommand

-(void)testCommand{
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //打印：今天我投降了
        
        //命令执行代理
        NSLog(@"%@我投降了",input);
        //返回一个RACSignal信号
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            return nil;
        }];
        
    }];
    
    //执行命令
    [command execute:@"今天"];
    
    
    
}

#pragma mark - 延迟
- (void)testDelay{
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"等等我,我还有10s就到了");
        [subscriber sendNext:@"北极"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //延迟10s接受next的玻璃球
    [[siganl delay:10] subscribeNext:^(id x) {
        
        NSLog(@"我到了%@",x);
        
    }];
    NSLog(@"%s",__FUNCTION__);
    
}

#pragma mark - 重放

- (void)testReplay{
    
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"执行信号内容");
        [subscriber sendNext:@"电影"];
        [subscriber sendNext:@"呵呵"];

        [subscriber sendCompleted];
        return nil;

    }];
//信号 内的内容会被重复执行
//    [siganl subscribeNext:^(id x) {
//        NSLog(@"1:%@",x);
//    }];
//    [siganl subscribeNext:^(id x) {
//        NSLog(@"2:%@",x);
//    }];
//    [siganl subscribeNext:^(id x) {
//        NSLog(@"3:%@",x);
//    }];
    
//    创建该普通信号的重复信号 replay 避免信号重复执行 （执行replay 不论有没有订阅者 原信息的内容就会执行一次，replayLazily则不会）
//    RACSignal *replaySiganl = [siganl replay];
//    //重复接受信号
//    [replaySiganl subscribeNext:^(NSString *x) {
//        NSLog(@"小米%@",x);
//    }];
//    [replaySiganl subscribeNext:^(NSString *x) {
//        NSLog(@"小红%@",x);
//
//    }];
//
//    RACSignal *replayLast = [siganl replayLast]; //提供最新的值给订阅者 （执行replayLast 不论有没有订阅者 原信息的内容就会执行一次，replayLazily则不会）
//    [replayLast subscribeNext:^(id x) {
//        NSLog(@"replayLast:%@",x);
//    }];
//    [replayLast subscribeNext:^(id x) {
//        NSLog(@"replayLast2:%@",x);
//
//    }];
    
    RACSignal * replayLazily = [siganl replayLazily];//直到订阅时候才真正创建一个信号，源信号的订阅代码才开始执行
        [replayLazily subscribeNext:^(id x) {
            NSLog(@"replayLazily:%@",x);
        }];
        [replayLazily subscribeNext:^(id x) {
            NSLog(@"replayLazily2:%@",x);
    
        }];
    
}

#pragma mark - 定时器 超时 相关

- (void)testTimer{
 
//    RACSignal *siganl = [RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]];
//    //定时器执行代码
//    [siganl subscribeNext:^(id x) {
//        NSLog(@"吃药");
//
//    }];
    
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"我快到了");
        RACSignal *sendSiganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"sendsiganl action");
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
        
        //发生信号要12s才到
        [[sendSiganl delay:5] subscribeNext:^(id x) {
            //这里才发送next玻璃球到siganl
            NSLog(@"发送：%@",x);
            [subscriber sendNext:@"我到了"];
            [subscriber sendCompleted];
            
        }];
        return nil;
        
        
    }];
    
    [[siganl timeout:6 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        
        NSLog(@"等了你3s,你一直没来,我走了");
        
    }];
    
}

#pragma mark - 重试
- (void)testRetry{
    
    __block int failedCount = 0;

    //创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (failedCount < 10) {
            failedCount ++;
            NSLog(@"我失败了");
            [subscriber sendError:nil];
        }else{
            NSLog(@"经历了数百次后,我成功了");
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        return nil;
        
    }];
    
    [siganl subscribeNext:^(id x) {
        NSLog(@"成功了么？%@",x);
    }];
    
    //重试
    RACSignal *retrySiganl = [siganl retry];
    //直到发生next的玻璃球
    [retrySiganl subscribeNext:^(id x) {
        NSLog(@"总会成功的,%@",x);

    }];
    

}

#pragma mark - 节流,不好意思,这里每一秒只能通过一个人,如果1s内发生多个,只通过最后一个

- (void)testThrottle{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //即使发送一个next的玻璃球
        [subscriber sendNext:@"A"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"B"];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"C"];
            [subscriber sendNext:@"D"];
            [subscriber sendNext:@"E"];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"F"];
        });
        return nil;
        
    }];
    
    //对信号进行节流,限制时间内一次只能通过一个玻璃球
    [[signal throttle:1] subscribeNext:^(id x) {
        NSLog(@"%@通过了",x);
        
    }];

    
}
#pragma mark - 条件(takeUntil方法,当给定的signal完成前一直取值)
- (void)testTakeUntil{
    RACSignal *takeSiganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //创建一个定时器信号,每一秒触发一次
        RACSignal *siganl = [RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]];
        [siganl subscribeNext:^(id x) {
            //在这里定时发送next玻璃球
            [subscriber sendNext:@"直到世界尽头"];
            
        }];
        return nil;
        
    }];
    
    //创建条件信号
    RACSignal *conditionSiganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //设置5s后发生complete玻璃球
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"世界的今天到了,请下车");
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    //设置条件,takeSiganl信号在conditionSignal信号接收完成前,不断取值
    [[takeSiganl takeUntil:conditionSiganl] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
    }];
    
}

#pragma mark - RACReplaySubject
/**
 *  RACReplaySubject创建方法
 1.创建RACSubject
 2.订阅信号
 3.发送信号
 工作流程:
 1.订阅信号,内部保存了订阅者,和订阅者相应的block
 2.当发送信号的,遍历订阅者,调用订阅者的nextBlock
 3.发送的信号会保存起来,当订阅者订阅信号的时候,会将之前保存的信号,一个个作用于新的订阅者,保存信号的容量由capacity决定,这也是有别于RACSubject的
 */

-(void)RACReplaySubject{
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
//    [replaySubject subscribeNext:^(id x) {
//        NSLog(@" 1 %@",x);
//    }];
//    
//    [replaySubject subscribeNext:^(id x) {
//        NSLog(@"2 %@",x);
//    }];
    [replaySubject sendNext:@7];
    [replaySubject sendNext:@8];
    [replaySubject sendNext:@9];

    [replaySubject subscribeNext:^(id x) {
        NSLog(@"3 %@",x);
    }];
    
}

#pragma mark - rac_liftSelector:withSignals
//这里的rac_liftSelector:withSignals 就是干这件事的，它的意思是当signalA和signalB都至少sendNext过一次，接下来只要其中任意一个signal有了新的内容，doA:withB这个方法就会自动被触发

-(void)testSelectorSignal{
    
    RACSignal *sigalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *NSEC_PER_SEC));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"A"];
            
        });
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"Another B"];
        });
//        [subscriber sendCompleted];
        return nil;
        
    }];
    [self rac_liftSelector:@selector(doA:withB:) withSignals:sigalA,signalB, nil];
    
}

- (void)doA:(id)a withB:(id)b{
    NSLog(@"%s,a-%@,b-%@",__FUNCTION__,a,b);
}

@end
