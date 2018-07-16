//
//  CSJSONDataHandle.m
//  JRWallet
//
//  Created by Primeledger on 2018/6/8.
//  Copyright © 2018年 vince_. All rights reserved.
//

#import "CSJSONDataHandle.h"
#import <MJExtension/MJExtension.h>

@implementation CSJSONDataHandle

+ (instancetype)jsonDataHandleWithPath:(NSString *)path
                             ClassName:(NSString *)name{
    CSJSONDataHandle * handle_ = [[[self class] alloc] init];
    handle_.object_Path = path;
    handle_.object_Class = name;
    return handle_;
}

-(NSString *)separateLabel{
    if (!_separateLabel||![_separateLabel isKindOfClass:[NSString class]]) _separateLabel = @"->";
    return _separateLabel;
}

-(id)cs_ObjectWithData:(id)data{
    id result = data;
    if ([data isKindOfClass:[NSDictionary class]]){
        NSArray * pathList_ = [self pathList];
        if (pathList_.count) {
            for (NSString * key_ in pathList_) result = result[key_];
        }
    }
    return [self objectWithParame:result];
}

- (id)objectWithParame:(id)parame{
    if (!self.object_Class.length) return parame;
    Class modelC_ = NSClassFromString(self.object_Class);
    if (!modelC_) return parame;
    
    if ([parame isKindOfClass:[NSArray class]]) {
        return [modelC_ mj_objectArrayWithKeyValuesArray:parame];
    }else if ([parame isKindOfClass:[NSDictionary class]]){
        return [modelC_ mj_objectWithKeyValues:parame];
    }
    return nil;
}

- (NSArray *)pathList{
    NSArray * list_ = [self.object_Path componentsSeparatedByString:self.separateLabel];;
    return list_;
}

@end
