//
//  CSNetWorkManager.h
//  JRWallet
//
//  Created by Primeledger on 2018/6/8.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "CSResponseHandleProtocol.h"
#import "CSRequestHandleProtocol.h"

@interface CSNetWorkManager : NSObject

+ (AFHTTPSessionManager *)sessionManagerWithHost:(NSString *)host;

+ (AFHTTPSessionManager *)sessionManagerWithHost:(NSString *)host
                                   RequestHandle:(id<CSRequestHandleProtocol>)requestHandle
                                  ResponseHandle:(id<CSResponseHandleProtocol>)responseHandle;

@end
