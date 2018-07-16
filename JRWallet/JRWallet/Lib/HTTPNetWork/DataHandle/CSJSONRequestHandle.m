//
//  CSJSONRequestHandle.m
//  JRWallet
//
//  Created by Primeledger on 2018/6/14.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "CSJSONRequestHandle.h"

@implementation CSJSONRequestHandle

-(NSTimeInterval)timeoutInterval{
    return 60.f;
}

-(NSDictionary *)headerFields{
    NSString * randomNum = [self getRandomNumber:1000000000000000 to:9999999999999999];

    return @{@"AUTHTOKEN":@"cmvgdcrnzx4n2ugvirk8th58n6c1rpxmqku9ki0cwh4kuumm0vw5mh0nbraiyfrr",
             @"DEVICEID":@"2A4D7A7FE5E044E6BB2C8B9D75F4C6B9",
             @"Lang":@"en-GB",
             @"X-B3-Traceid":randomNum,
             @"X-B3-Spanid":randomNum,
             };
}

- (NSString *)getRandomNumber:(long long)from to:(long long)to
{
    long long randomNum = (long long)(from + (arc4random() % (to - from + 1)));
    
    return [NSString stringWithFormat:@"%lld", randomNum];
}


@end
