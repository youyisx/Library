//
//  CSUploadAPI.m
//  JRWallet
//
//  Created by Primeledger on 2018/6/14.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "CSUploadAPI.h"
#import "AFHTTPSessionManager+JR_RACSupport.h"

@interface CSUploadAPI()
@property (nonatomic, assign, readwrite) CGFloat progress;
@end

@implementation CSUploadAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.path = @"/app/v1/common/file/upload";
    }
    return self;
}

-(NSString *)name{
    if (!_name) _name = @"file";
    return _name;
}

-(NSString *)mimeType{
    if (!_mimeType) _mimeType = @"image/jpeg";
    return _mimeType;
}

-(NSString *)filename{
    if (!_filename) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        _filename = [NSString stringWithFormat:@"%@.png", str];
    }
    return _filename;
}

-(RACSignal *)request:(NSDictionary *)param
            takeUntil:(RACSignal *)cancel{
    NSMutableDictionary * totalParam_ = [self commonParam].mutableCopy;
    if ([param isKindOfClass:[NSDictionary class]]) [totalParam_ addEntriesFromDictionary:param];
    NSDictionary * lastParam_ = [self adjustTotalParam:totalParam_];
    @weakify(self)
    RACSignal * signal = [self.sessionManager jr_rac_POSTUpload:[self path]
                                                     parameters:lastParam_
                                                           data:self.data
                                                           name:self.name
                                                       fileName:self.filename
                                                       mimeType:self.mimeType
                                                       progress:^(CGFloat pro) {
                                                           @strongify(self)
                                                           self.progress = pro;
                                                       }];
    signal = [signal takeUntil:self.rac_willDeallocSignal];
    signal = [signal map:^id(id value) {
        return [self resolvingResultWithRespone:value];
    }];
    
    RACSignal * packageSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
//        if ([self.requestUIHandle respondsToSelector:@selector(cs_showReuqestLoading)]) [self.requestUIHandle cs_showReuqestLoading];
        RACDisposable * disposable_ =
        [signal subscribeNext:^(id x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
//            if ([self.requestUIHandle respondsToSelector:@selector(cs_hideReuqestLoading)]) [self.requestUIHandle cs_hideReuqestLoading];
            
        } error:^(NSError *error) {
            [subscriber sendError:error];
//            if ([self.requestUIHandle respondsToSelector:@selector(cs_showError:)]) [self.requestUIHandle cs_showError:error];
//            if ([self.requestUIHandle respondsToSelector:@selector(cs_hideReuqestLoading)]) [self.requestUIHandle cs_hideReuqestLoading];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"释放请求信息");
            [disposable_ dispose];
        }];
    }];
    return packageSignal;
}


-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end

 

 
 

