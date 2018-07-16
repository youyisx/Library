//
//  CSJSONRequestSerializer.h
//  JRWallet
//
//  Created by Primeledger on 2018/6/8.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "AFURLRequestSerialization.h"
#import "CSRequestHandleProtocol.h"

@interface CSJSONRequestSerializer : AFJSONRequestSerializer

@property (nonatomic,strong)id<CSRequestHandleProtocol> requestHandle;

@end
