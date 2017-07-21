//
//  JRLocationInfo.m
//  JuMei
//
//  Created by jumei_vince on 2017/6/28.
//  Copyright © 2017年 Jumei Inc. All rights reserved.
//

#import "JRLocationInfo.h"
#import "JRLocationTransform.h"

@interface JRLocationInfoHandle : NSObject<CLLocationManagerDelegate>
@property (nonatomic, copy) void(^updateLocation)(CLLocationCoordinate2D coordinate);
@property (nonatomic, strong) CLLocationManager * locationManager;
@end

@implementation JRLocationInfoHandle

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return _locationManager;
}

- (void)startLocation {
    //    获取授权认证，两个方法：
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark -- CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
    if (self.updateLocation) {
        CLLocation *location = [locations lastObject];
        CLLocationCoordinate2D coordinate = location.coordinate;
        JRLocationTransform * transform = [[JRLocationTransform alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude];
        transform = [transform transformFromGPSToBD];
        self.updateLocation(CLLocationCoordinate2DMake(transform.latitude, transform.longitude));
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
    NSLog(@"--->定位失败:%@",error);
    if (self.updateLocation) {
        self.updateLocation(CLLocationCoordinate2DMake(0, 0));
    }
}

- (void)dealloc
{
    [self.locationManager stopUpdatingLocation];
}

@end

static JRLocationInfoHandle * _locationHandle = nil;

@implementation JRLocationInfo

+ (void)currentLocation:(void(^)(CLLocationCoordinate2D coordinate))block{
    if (!block) return;
    if (!_locationHandle) {
        _locationHandle = [[JRLocationInfoHandle alloc] init];
    }
    _locationHandle.updateLocation = ^(CLLocationCoordinate2D coordinate) {
        _locationHandle = nil;
        block(coordinate);
    };
    [_locationHandle startLocation];
}

@end
