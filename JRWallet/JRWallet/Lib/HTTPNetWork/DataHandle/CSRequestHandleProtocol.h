//
//  CSRequestHandleProtocol.h
//  JRWallet
//
//  Created by xxx on 2018/6/14.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSRequestHandleProtocol <NSObject>
@optional
- (NSTimeInterval)timeoutInterval;

- (NSDictionary *)headerFields;

@end
