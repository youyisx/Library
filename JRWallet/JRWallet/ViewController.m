//
//  ViewController.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "ViewController.h"

#import "JRHTTPDefine.h"

#import <objc/runtime.h>
#import <objc/message.h>


#import "JRResolveHandle.h"
#import "TTTAttributedLabel.h"
#import "CSAPI.h"
#import "CSUploadAPI.h"

#import "SXViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>
@interface TestModel:NSObject
@property (nonatomic, copy) NSString * articleSeqNo;
@property (nonatomic, copy) NSString * indexImage;
@property (nonatomic, copy) NSString * publishTime;
@property (nonatomic, copy) NSString * summary;
@property (nonatomic, copy) NSString * title;
@end

@implementation TestModel

@end

@interface ViewController ()

@property (nonatomic, strong)     RACCommand * command;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *infoLabel;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    UIViewController * nextVC = [UIViewController new];
//    nextVC.view.backgroundColor =[UIColor orangeColor];
//
//    UINavigationController * nextNC = [[UINavigationController alloc] initWithRootViewController:nextVC];
//    [self presentViewController:nextNC animated:YES completion:nil];
//    NSLog(@"nextVC:%@,nextNC:%@",nextVC,nextNC);
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"visibleViewController-->%@",self.navigationController.visibleViewController);
//
//
//    });
    

}

- (void)cancelTask{
    NSLog(@"应该要cancel才对");
}

- (void)test{

//    CSAPI * signal_ = [CSAPI new];
//    [signal_ addDataHandleWithObjectPath:nil ObjectClass:nil];
//    [signal_ addDataHandleWithObjectPath:@"newsList" ObjectClass:nil];
//    [signal_ addDataHandleWithObjectPath:@"noticeList" ObjectClass:@"TestModel"];
//    [[signal_ request:nil] subscribeNext:^(id x) {
//        NSLog(@"x:%@",x);
//    } error:^(NSError *error) {
//        NSLog(@"-------error:%@",error.userInfo[NSLocalizedDescriptionKey] );
//    }];
    
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];

    
    self.infoLabel.numberOfLines = 0;
    [self.infoLabel setText:[NSString stringWithFormat:@"我已同意干啥尼，ksksk，我也不知道；怎么办。。。基本面有东西基本面魂牵梦萦asdf土aaadf顶起夺需要"]];
    
//    self.infoLabel setText:<#(id)#> afterInheritingLabelAttributesAndConfiguringWithBlock:<#^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)block#>
//    JRResolveHandle * hh = [JRResolveHandle new];
//    [[hh rac_willDeallocSignal] subscribeNext:^(id x) {
//        NSLog(@"hh ddd");
//    }];
//    printf("retain count hh = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(hh)));
//
//    @autoreleasepool{
//    AFHTTPSessionManager * aa = [[AFHTTPSessionManager alloc] init];
//
////
//    [[aa rac_willDeallocSignal] subscribeNext:^(id x) {
//        NSLog(@"...");
//    }];
//
//        printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(aa)));
//
//    }
//    JRHTTPSessionManager * ss = [[JRHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:JRBASEURL_DEV]];
//    JRHTTPSessionManager * ss1 = [[JRHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:JRBASEURL_DEV]];
//
//    [[ss rac_willDeallocSignal] subscribeNext:^(id x) {
//        NSLog(@"???");
//    }];
//    [JRBaseAPI registerHost:JRBASEURL_DEV];
////    [self test];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self cancelTask];
//    });
    
//    [self test];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self cancelTask];
//    });
//    [self test];
//    [self  test];

    
    
    //    [command execute:@"B"];
    //    [command execute:@"C"];
//    [[command.executionSignals.switchToLatest takeUntil:[self rac_signalForSelector:@selector(cancelTask)]] subscribeNext:^(id x) {
//        NSLog(@"任务完成...%@",x);
//        h.app_startup_jr_hot = @"2";
//    }];
    
    
    
//    RACSignal * lastS = command.executionSignals;
//
//    RACSignal * currentS = command.executing;
//    NSLog(@"currents:%@  lastS:%@",currentS,lastS);
//
//    [[currentS takeUntil:[self rac_signalForSelector:@selector(cancelTask)]] subscribeNext:^(id x) {
//        NSLog(@"678678当前任务 %@",x);
//    }];

    
//    [[[command execute:@"A"] takeUntil:[self rac_signalForSelector:@selector(cancelTask)]] subscribeNext:^(id x) {
//        NSLog(@"---%@",x);
//    }];;
   
    
//    RACSignal * ss =[[command execute:nil] takeUntil:[self rac_signalForSelector:@selector(cancelTask)]];
//
//    NSLog(@"ss:%@",ss);
//
//    [ss subscribeNext:^(id x) {
//        NSLog(@"会有什么事儿呢:%@",x);
//    }];

    
//    RACSignal * signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"开始执行了么？");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"send value");
//            [subscriber sendNext:@"ABC"];
//            [subscriber sendNext:@"456"];
//          
//        });
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    NSLog(@"send error");
//                    [subscriber sendNext:@"last"];
//                    [subscriber sendCompleted];
//                    
//                });
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"over...");
//        }];
//    }] replayLazily];
//    
//    [signal subscribeNext:^(id x) {
//        NSLog(@"1 %@",x);
//    }];
//    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [signal subscribeNext:^(id x) {
//            NSLog(@"3 %@",x);
//        }];
//    });
    
    
//    [[signal map:^id(id value) {
//        NSLog(@"action map:%@",value);
//        return value;
//    }] subscribeNext:^(id x) {
//        NSLog(@"map result:%@",x);
//    } error:^(NSError *error) {
//        NSLog(@"出错啦:%@",error);
//    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    SXViewController * vc = [SXViewController new];
//    [self presentViewController:vc animated:YES completion:nil];
    UIWindow * window_ = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud_ = [MBProgressHUD showHUDAddedTo:window_ animated:YES];
    hud_.detailsLabel.text = @"网异常请重试";
    hud_.detailsLabel.font = [UIFont systemFontOfSize:18.f];
//    hud_.detailsLabel.textColor = cs_textPrimaryColor();
    hud_.mode = MBProgressHUDModeText;
    
//    hud_.backgroundColor = [cs_linePrimaryColor() colorWithAlphaComponent:0.8f];
    hud_.bezelView.layer.cornerRadius = 8.f;
    hud_.detailsLabel.numberOfLines = 0.f;
    hud_.removeFromSuperViewOnHide = YES;

    [hud_ hideAnimated:YES afterDelay:2.5];
    
    
}


@end
