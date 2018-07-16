//
//  CSUploadAPI.h
//  JRWallet
//
//  Created by Primeledger on 2018/6/14.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRBaseAPI.h"

@interface CSUploadAPI : JRBaseAPI

@property (nonatomic, copy) NSString * filename;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * mimeType;
@property (nonatomic, strong) NSData * data;

@property (nonatomic, assign, readonly) CGFloat progress;


@end
