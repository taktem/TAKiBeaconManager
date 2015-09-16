//
//  TAKiBeaconConnector.h
//  TAKiBeaconManager
//
//  Created by 西村 拓 on 2015/03/10.
//  Copyright (c) 2015年 TakuNishimura. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TAKiBeaconModel.h"

typedef NS_ENUM(NSUInteger, ENCLRegionState) {
    ENCLRegionStateInside,
    ENCLRegionStateOutside,
    ENCLRegionStateUnknown,
};


typedef NS_ENUM(NSUInteger, TAKLocationAuthType) {
    TAKLocationAuthTypeNone = 0,
    TAKLocationAuthTypeWhenInUse,
    TAKLocationAuthTypeAlways
};

@interface TAKiBeaconConnector : NSObject

/// iOS8で使用する際の認証タイプを選択
@property (nonatomic) TAKLocationAuthType authType;

#pragma mark - Singleton
+ (TAKiBeaconConnector *)sharedInstance;

#pragma mark - Cycle
- (void)defaultSetting;
- (void)createBeaconRegionWithUUID:(NSString *)uuid;

#pragma mark Monitoring
- (void)startMonitoring;
- (void)setMonitoringBlockWithSuccess:(void(^)(ENCLRegionState response))success
                              failure:(void(^)(NSError *error))failure;
- (void)stopMonitoring;

#pragma mark Ranging
- (void)startRanging;
- (void)setRanginBlockWithSuccess:(void (^)(id response))success
                          failure:(void (^)(NSError *error))failure;
- (void)stopRanging;

@end