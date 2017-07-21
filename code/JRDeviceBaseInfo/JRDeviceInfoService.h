//
//  JRDeviceInfoService.h
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,JRAnalyzeEvent){
    JRAnalyzeEvent_Start_Hot,//热启动
    JRAnalyzeEvent_Start_Cold,//冷启动
};

@interface JRDeviceInfoService : NSObject

+(void)trackEventDataAnalyze:(JRAnalyzeEvent)event;

@end
