//
//  ViewController.m
//  FMDBDemo
//
//  Created by jumei_vince on 17/4/27.
//  Copyright © 2017年 vince. All rights reserved.
//

#import "ViewController.h"
#import "SXDBManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
        NSLog(@"list:%@",list);
    }];
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickedAdd:(UIButton *)sender {
    if (sender.tag == 0) {
        NSLog(@"添加一个用户");
        SXUser * u = [[SXUser alloc] init];
        u.uid = arc4random()%1000;
        u.name = @"112vince111";
        u.des  = @"123asdfasdf...";
        u.creatDate = [NSDate date];
        [[SXDBManager shareDBManager] addUser:u];
        
        [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
            NSLog(@"new list:%@",list);
        }];
    }else if (sender.tag == 1){
        NSLog(@"批量添加一组用户");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray * ma = @[].mutableCopy;
            for (int i =0 ; i < 10000; i++) {
                SXUser * u = [[SXUser alloc] init];
                u.uid = i;
                u.name = @"112vince111";
                u.des  = @"123asdfasdf...";
                u.creatDate = [NSDate date];
                [ma addObject:u];
            }
            [ViewController testFunctionTimes:@"批量添加" tast:^{
                [[SXDBManager shareDBManager] addUsers:ma];
            }];
            [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
                NSLog(@"new list:%@",list);
            }];
        });
        
    }
   
}

//可以封装成
+ (void)testFunctionTimes:(NSString *)funcNmae tast:(dispatch_block_t)block {
    CFAbsoluteTime startime = CFAbsoluteTimeGetCurrent();
    block();
    CFAbsoluteTime endtime = CFAbsoluteTimeGetCurrent();
    NSLog(@"%@ takes %2.5f second", funcNmae, endtime - startime);//可以给个返回值 会不会好点
}

- (IBAction)clickedDele:(UIButton *)sender {
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:@"请输入用户ID" preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入用户ID,多个用户用,号隔开";
    }];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak UIAlertController * wAc = ac;
    [ac addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField * tf = [wAc.textFields firstObject];
        NSString * uidStr = tf.text;
        NSArray * uids = [uidStr componentsSeparatedByString:@","];
        NSMutableArray * ma = @[].mutableCopy;
        for (NSString * uuid in uids) {
            [ma addObject:@(uuid.integerValue)];
        }
        NSLog(@"uids:%@",ma);
        [[SXDBManager shareDBManager] deleteUsers:ma];
        [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
            NSLog(@"new list:%@",list);
        }];
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
