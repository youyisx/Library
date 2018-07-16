//
//  CSAPI.m
//  JRWallet
//
//  Created by Primeledger on 2018/6/14.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "CSAPI.h"

@implementation CSAPI

- (NSMutableDictionary *)commonParameters
{
    NSMutableDictionary * commonDic = [NSMutableDictionary dictionary];
    
    [commonDic setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    [commonDic setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"appcode"];
    [commonDic setValue:@"IOS" forKey:@"os"]; //后台定义成了大写，检测更新用到
    //cmvgdcrnzx4n2ugvirk8th58n6c1rpxmqku9ki0cwh4kuumm0vw5mh0nbraiyfrr
    [commonDic setValue:@"2A4D7A7FE5E044E6BB2C8B9D75F4C6B9" forKey:@"deviceId"];
    
    [commonDic setValue:@"Simulator" forKey:@"deviceModel"];
    
    [commonDic setValue:[UIDevice currentDevice].systemVersion forKey:@"deviceOs"];
    
    [commonDic setValue:@"en-GB" forKey:@"lang"];
    
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    BOOL appStoreSource = [bundleId isEqualToString:@"com.coinsuper.app"];
    commonDic[@"packageCode"] = appStoreSource ? @"AppStore" : @"Enterprise"; //APP安装包标识号
    commonDic[@"marketSource"] = appStoreSource ? @"AppStore" : @"Enterprise";  //市场类型："AppStore" or "Enterprise"
    
    return commonDic;
}

- (NSString *)getUUID
{
    
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    
    NSString * uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
    
    CFRelease(uuidRef);
    
    
    uuidStr = [uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return uuidStr;
}

-(NSDictionary *)commonParam{
   return  @{
      @"common":[self commonParameters],
      @"data":@{},
      };
}

-(NSString *)path{
    return @"/app/v2/member/user/symbol/list";
}

@end
