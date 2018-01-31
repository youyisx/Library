//
//  TestViewController.h
//  RACDemo
//
//  Created by jumei_vince on 2018/1/30.
//  Copyright © 2018年 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TestProtocal <NSObject>

- (void)test:(NSString *)t action:(NSString *)a;

@end

@interface TestViewController : UIViewController

@property (nonatomic, weak) id<TestProtocal> delegate;

@end
