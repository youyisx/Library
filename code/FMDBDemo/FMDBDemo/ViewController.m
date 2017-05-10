//
//  ViewController.m
//  FMDBDemo
//
//  Created by jumei_vince on 17/4/27.
//  Copyright © 2017年 vince. All rights reserved.
//

#import "ViewController.h"
#import "SXDBManager+Cache.h"
#import "SXDBLoop.h"
@interface ViewController ()
@property (nonatomic,strong) SXDBLoop * loop;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
//        NSLog(@"list:%@",list);
//    }];
////    "SXUser:uid->SPCGLD_7504 name:SPCGLD_vince des:SPCGLD_des creatDate:2017-05-10 06:45:37 +0000",
////    "SXUser:uid->SPCGLD_1041 name:SPCGLD_vince des:SPCGLD_des creatDate:2017-05-10 06:45:37 +0000",
////    "SXUser:uid->SPCGLD_2853 name:SPCGLD_vince des:SPCGLD_des creatDate:2017-05-10 06:45:37 +0000",
////    "SXUser:uid->SPCGLD_146 name:SPCGLD_vince des:SPCGLD_des creatDate:2017-05-10 06:45:37 +0000",
////    "SXUser:uid->SPCGLD_8972 name:SPCGLD_vince des:SPCGLD_des creatDate:2017-05-10 06:45:37 +0000",
////    "SXUser:uid->SPCGLD_6706 name:SPCGLD_vince des:SPCGLD_des creatDate:2017-05-10 06:45:37 +0000",
////    "SXUser:uid->SPCGLD_1881 name:SPCGLD_vince des:SPCGLD_des creatDate:2017-05-10 06:45:37 +0000",
////    "SXUser:uid->SPCGLD_1601 name:SPCGLD_vince des:SPCGLD_des creatDate:2017-05-10 06:45:37 +0000"
//    [[SXDBManager shareDBManager] deleteUser:@"SPCGLD_1601"];
//    [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
//        NSLog(@"list:%@",list);
//    }];
    

    self.loop = [[SXDBLoop alloc] init];
    self.loop.loopTime = 1.001;

    
    
}

- (void)testActive{
    NSLog(@"来一波...");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self testAdd];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self testAdd];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self testAdd];
    });
}

- (void)testAdd{
    NSArray * list = [self testCreatListWithTag:[self getTag]];
    [[SXDBManager shareDBManager] delayAddUsers:list];
}

- (NSString *)getTag{
    //65 .... 90
    int n1 = arc4random_uniform(25) + 65;
    int n2 = arc4random_uniform(25) + 65;
    int n3 = arc4random_uniform(25) + 65;
    int n4 = arc4random_uniform(25) + 65;
    int n5 = arc4random_uniform(25) + 65;
    int n6 = arc4random_uniform(25) + 65;
    return  [NSString stringWithFormat:@"%c%c%c%c%c%c",n1,n2,n3,n4,n5,n6];
}

- (NSArray *)testCreatListWithTag:(NSString *)tag{
    int count = arc4random_uniform(100) + 1;
    NSMutableArray * list = @[].mutableCopy;
    for (int i = 0 ; i < count ; i ++) {
        SXUser * u = [[SXUser alloc] init];
        u.uid = [NSString stringWithFormat:@"%@_%d",tag,arc4random()%10000];
        u.name = [NSString stringWithFormat:@"%@_vince",tag];
        u.des  = [NSString stringWithFormat:@"%@_des",tag];
        u.creatDate = [NSDate date];
        [list addObject:u];
    }
    return list;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickedAdd:(UIButton *)sender {
   
    
    if (sender.tag == 0) {
        NSLog(@"添加一个用户");
        SXUser * u = [[SXUser alloc] init];
        u.uid = [NSString stringWithFormat:@"%d",arc4random()%1000];
        u.name = @"112vince111";
        u.des  = @"123asdfasdf...";
        u.creatDate = [NSDate date];
        [[SXDBManager shareDBManager] addUser:u];
        
        [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
//            NSLog(@"new list:%@",list);
            NSLog(@"last:%@",[list lastObject]);
        }];
    }else if (sender.tag == 1){
        if (self.loop.isLoop) {
            [self.loop destroyDBLoop];
        }else{
            [self.loop activeDBLoopWithAsyncLoopBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self testActive];
                });
            }];
        }
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
    [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
        NSLog(@"new list:%@",list);
    }];
    
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:@"请输入用户ID" preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入用户ID,多个用户用,号隔开";
        textField.text = [NSString stringWithFormat:@"SPCGLD_"];
    }];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak UIAlertController * wAc = ac;
    [ac addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField * tf = [wAc.textFields firstObject];
        NSString * uidStr = tf.text;
        NSArray * uids = [uidStr componentsSeparatedByString:@","];
        NSLog(@"uids:%@",uids);
        [[SXDBManager shareDBManager] deleteUsers:uids];
        [[SXDBManager shareDBManager] userList:^(NSArray<SXUser *> *list) {
            NSLog(@"new list:%@",list);
        }];
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
