//
//  TAKiBeaconModel.h
//  TAKiBeaconManager
//
//  Created by 西村 拓 on 2015/09/16.
//  Copyright (c) 2015年 TakuNishimura. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TAKBLEStatus) {
    TAKBLEStatusStateUnknown = 0,
    TAKBLEStatusStateResetting,
    TAKBLEStatusStateUnsupported,
    TAKBLEStatusStateUnauthorized,
    TAKBLEStatusStatePoweredOff,
    TAKBLEStatusStatePoweredOn,
};

typedef NS_ENUM(NSUInteger, TAKCLRegionProximity) {
    TAKCLRegionProximityUnknown = 0,
    TAKCLRegionProximityImmediate,
    TAKCLRegionProximityNear,
    TAKCLRegionProximityFar
};

@interface TAKiBeaconModel : NSObject

/// UUID
@property (copy, nonatomic, readonly) NSString *proximityUUID;

/// Major
@property (nonatomic, readonly) NSUInteger major;

/// minor
@property (nonatomic, readonly) NSUInteger minor;

/// rssi
@property (nonatomic, readonly) double rssi;

/// accuracy
@property (nonatomic, readonly) double accuracy;

/// proximity
@property (nonatomic, readonly) TAKCLRegionProximity proximity;

/**
 *  ビーコンモデル生成
 */
+ (instancetype)initWithProximityUUID:(NSString *)proximityUUID
                                major:(NSUInteger)major
                                minor:(NSUInteger)minor
                                 rssi:(double)rssi
                             accuracy:(double)accuracy
                            proximity:(TAKCLRegionProximity)proximity;

@end
