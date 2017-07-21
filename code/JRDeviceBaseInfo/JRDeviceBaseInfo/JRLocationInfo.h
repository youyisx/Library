//
//  JRLocationInfo.h
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JRLocationInfo : NSObject
+ (void)currentLocation:(void(^)(CLLocationCoordinate2D coordinate))block;

@end
