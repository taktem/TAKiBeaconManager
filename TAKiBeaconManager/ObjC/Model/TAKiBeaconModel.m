//
//  TAKiBeaconModel.m
//  TAKiBeaconManager
//
//  Created by 西村 拓 on 2015/09/16.
//  Copyright (c) 2015年 TakuNishimura. All rights reserved.
//

#import "TAKiBeaconModel.h"

@interface TAKiBeaconModel()

@property (copy, nonatomic, readwrite) NSString *proximityUUID;
@property (nonatomic, readwrite) NSUInteger major;
@property (nonatomic, readwrite) NSUInteger minor;
@property (nonatomic, readwrite) double rssi;
@property (nonatomic, readwrite) double accuracy;
@property (nonatomic, readwrite) TAKCLRegionProximity proximity;

@end

@implementation TAKiBeaconModel

+ (instancetype)initWithProximityUUID:(NSString *)proximityUUID
                                major:(NSUInteger)major
                                minor:(NSUInteger)minor
                                 rssi:(double)rssi
                             accuracy:(double)accuracy
                            proximity:(TAKCLRegionProximity)proximity {
    TAKiBeaconModel *model = [TAKiBeaconModel new];
    model.proximityUUID = proximityUUID;
    model.major = major;
    model.minor = minor;
    model.rssi = rssi;
    model.accuracy = accuracy;
    model.proximity = proximity;
    
    return model;
}

@end
