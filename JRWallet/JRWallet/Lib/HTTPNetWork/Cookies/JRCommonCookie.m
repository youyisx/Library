//
//  JRCommonCookie.m
//  JRWallet
//
//  Created by jumei_vince on 2018/3/29.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "JRCommonCookie.h"
#import "JRHelper.h"

@interface JRCommonCookie()

@property (nonatomic, copy, readwrite) NSString * cookies;
@property (nonatomic, strong) NSMutableDictionary * totalCookise;

@property (nonatomic, copy) NSString * domain;
@end

@implementation JRCommonCookie

+ (instancetype)commonCookieWithDomain:(NSString *)domain{
    JRCommonCookie * cookie_ = [JRCommonCookie new];
    cookie_.domain = domain;
    return cookie_;
}

-(NSDictionary *)totalCookise{
    if (_totalCookise == nil) _totalCookise = [self commonCookis].mutableCopy;
    return _totalCookise;
}

-(NSString *)cookies{
    if (_cookies == nil) _cookies = [self updateCookies];
    return _cookies;
}

- (NSDictionary *)commonCookis{
    NSString * idfa_ = [JRHelper idfa];
    NSString * idfv_ = [JRHelper idfv];
    NSString * ip_ = [JRHelper ipAddress:YES];
    NSString * model_ = [JRHelper deviceModel];
    NSString * platform_ = [JRHelper platform];
    NSString * clientVersion_ = [JRHelper clientVersion];
    NSString * network = [JRHelper networkType];
    NSMutableDictionary * md_ = @{}.mutableCopy;
    if (idfa_.length >0) md_[@"idfa"] = idfa_;
    if (idfv_.length >0) md_[@"idfv"] = idfv_;
    if (ip_.length > 0) md_[@"ip"] = ip_;
    if (model_.length > 0) md_[@"model"] = model_;
    if (platform_.length >0) md_[@"platform"] = platform_;
    if (clientVersion_.length>0) md_[@"client_v"] = clientVersion_;
    if (network.length > 0) md_[@"network"] = network;
    return md_.copy;
}

- (void)appendCookies:(NSDictionary *)cookies{
    self.cookies = nil;
    [self.totalCookise addEntriesFromDictionary:cookies];
}

- (NSString *)updateCookies{
    NSMutableString * cookieString_ = [JRCommonCookie cookiesWithParam:self.totalCookise].mutableCopy;
    
    if ([self.domain isKindOfClass:[NSString class]]&&self.domain.length > 0) {
        NSHTTPCookieStorage *sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies_ = [sharedCookieStorage cookies];
        for (NSHTTPCookie *cookie_ in cookies_) {
            if ([cookie_.domain rangeOfString:self.domain].location != NSNotFound) {
                [cookieString_ appendFormat:@"%@=%@; ",cookie_.name,cookie_.value];
            }
        }
    }
   
    return cookieString_.copy;
}

- (NSString *)description
{
    return self.cookies;
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark ---

+ (NSString *)cookiesWithParam:(NSDictionary *)param{
    
    if (![param isKindOfClass:[NSDictionary class]]) return @"";
    
    NSMutableString * cookieString_ = @"".mutableCopy;
    for (NSString * key_ in param.allKeys) {
        NSString * values_ = [param[key_] description];
        if (values_.length > 0) [cookieString_ appendFormat:@"%@=%@; ", key_,values_];
    }
    return cookieString_.copy;
}
@end
