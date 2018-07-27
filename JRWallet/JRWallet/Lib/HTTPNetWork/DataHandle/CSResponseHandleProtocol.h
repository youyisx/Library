//
//  CSResponseHandleProtocol.h
//  JRWallet
//
//  Created by xxx on 2018/6/11.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSResponseHandleProtocol <NSObject>

/**
 http response数据初次解析
 @param data response原始数据
 @return 解析出的data或者error <返回erro，则认为本次请求数据异常，其它都认为正常>
 */
- (id)cs_responseWithResponse:(id)data;

/**
 捕获到fail，此处可做业务逻辑

 @param error response-error
 */
- (void)cs_responseFail:(NSError *)error;


@end
