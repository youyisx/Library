//
//  TestViewController.m
//  RACDemo
//
//  Created by jumei_vince on 2018/1/30.
//  Copyright © 2018年 vince. All rights reserved.
//

#import "TestViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TestViewController ()

@end

@implementation TestViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.delegate test:@"test" action:@"action"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    RACSignal * s1 = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"执行 s1");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@(2)];
            [subscriber sendCompleted];
        });
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"s1 dis");
        }];
    }] replayLazily];
    
    [[s1 takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"x-->%@",x);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
