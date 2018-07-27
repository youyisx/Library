//
//  CSJSONDataHandle.h
//  JRWallet
//
//  Created by xxx on 2018/6/8.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDataHandleProtocol.h"
@interface CSJSONDataHandle : NSObject<CSDataHandleProtocol>

@property (nonatomic, copy) NSString * object_Path;// xxx->xxx->xxx->xxx->xxx
@property (nonatomic, copy) NSString * separateLabel;//默认路径隔离标识为 "->"

@property (nonatomic, copy) NSString * object_Class;


+ (instancetype)jsonDataHandleWithPath:(NSString *)path
                             ClassName:(NSString *)name;

@end
