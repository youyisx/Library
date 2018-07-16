//
//  SXViewController.m
//  JRWallet
//
//  Created by Primeledger on 2018/6/14.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "SXViewController.h"
#import "CSUploadAPI.h"

@interface SXViewController ()

@end

@implementation SXViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CSUploadAPI * upload = [CSUploadAPI new];
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"222" ofType:@"JPG"];
    upload.data = [NSData dataWithContentsOfFile:imagePath];
    [[RACObserve(upload, progress) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"pro:%@",x);
    }];
    [[[upload request:nil takeUntil:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"--x:%@",x);
    } error:^(NSError *error) {
        NSLog(@"--error:%@",error);
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
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
