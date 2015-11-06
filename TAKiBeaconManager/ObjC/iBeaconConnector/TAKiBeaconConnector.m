//
//  TAKiBeaconConnector.m
//  TAKiBeaconManager
//
//  Created by 西村 拓 on 2015/03/10.
//  Copyright (c) 2015年 TakuNishimura. All rights reserved.
//

#import "TAKiBeaconConnector.h"

@import CoreLocation;

static TAKiBeaconConnector *sharedInstance_ = nil;

static NSString * const BEACON_IDENTIFIER = @"com.taktem.ibeaconmanager.identifier";

typedef void(^SUCCESS_MONITORING_BLOCK)(ENCLRegionState response);
SUCCESS_MONITORING_BLOCK successMonitoringBlock;

typedef void(^FAILURE_MONITORING_BLOCK)(NSError *error);
FAILURE_MONITORING_BLOCK failureMonitoringBlock;

typedef void(^SUCCESS_RANGING_BLOCK)(id response);
SUCCESS_RANGING_BLOCK successRangingBlock;

typedef void(^FAILURE_RANGING_BLOCK)(NSError *error);
FAILURE_RANGING_BLOCK failureRangingBlock;

@interface TAKiBeaconConnector()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

@end

@implementation TAKiBeaconConnector

#pragma mark Singleton
+ (TAKiBeaconConnector *)sharedInstance {
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[TAKiBeaconConnector alloc] init];
    });
    
    return sharedInstance_;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance_ == nil) {
            sharedInstance_ = [super allocWithZone:zone];
            return sharedInstance_;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

#pragma mark Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    
    return self;
}

#pragma mark iBeacon base
- (void)defaultSetting {
    if (!self.locationManager) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
    }
    
    // 指定がない場合は、起動時のみとみなしてコールしておく
    switch (self.authType) {
        case TAKLocationAuthTypeNone:
        case TAKLocationAuthTypeWhenInUse: {
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        }
        case TAKLocationAuthTypeAlways: {
            if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            break;
        }
    }
    
}

- (void)createBeaconRegionWithUUID:(NSString *)uuid {
    if (self.beaconRegion) {
        return;
    }
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:BEACON_IDENTIFIER];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    NSLog(@"Create region");
}

#pragma mark Monitoring
- (void)startMonitoring {
    /** モニタリング可否を確認 **/
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        NSLog(@"Couldn't monitoring region");
        if (failureMonitoringBlock) {
            failureMonitoringBlock(nil);
        }
        return;
    }
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    NSLog(@"Turned on monitoring");
}

- (void)setMonitoringBlockWithSuccess:(void(^)(ENCLRegionState response))success
                              failure:(void(^)(NSError *error))failure {
    successMonitoringBlock = success;
    failureMonitoringBlock = failure;
}

- (void)stopMonitoring {
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    
    NSLog(@"Turned off monitoring");
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    if (![region.identifier isEqualToString:BEACON_IDENTIFIER]) {
        return;
    }
    
    NSLog(@"didStartMonitoringForRegion");
    [self.locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if (![region.identifier isEqualToString:BEACON_IDENTIFIER]) {
        return;
    }
    
    NSLog(@"Entered region");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if (![region.identifier isEqualToString:BEACON_IDENTIFIER]) {
        return;
    }
    
    NSLog(@"Exited region");
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if (![region.identifier isEqualToString:BEACON_IDENTIFIER]) {
        return;
    }
    
    ENCLRegionState regionState = ENCLRegionStateUnknown;
    
    switch (state) {
        case CLRegionStateInside:
            regionState = ENCLRegionStateInside;
            [self startRanging];
            break;
        case CLRegionStateOutside:
            regionState = ENCLRegionStateOutside;
            [self stopRanging];
            break;
        case CLRegionStateUnknown:
            regionState = ENCLRegionStateUnknown;
            break;
    }
    
    if (successMonitoringBlock) {
        successMonitoringBlock(regionState);
    }
}

#pragma mark Ranging
- (void)startRanging {
    if (![CLLocationManager isRangingAvailable]) {
        NSLog(@"Couldn't Ranging region");
        if (failureRangingBlock) {
            failureRangingBlock(nil);
        }
        return;
    }
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)setRanginBlockWithSuccess:(void (^)(id response))success
                          failure:(void (^)(NSError *error))failure {
    successRangingBlock = success;
    failureRangingBlock = failure;
}

- (void)stopRanging {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    if (![region.identifier isEqualToString:BEACON_IDENTIFIER]) {
        return;
    }
    
    NSMutableArray *modelArray = [NSMutableArray new];
    
    for (CLBeacon *beacon in beacons) {
        
        TAKCLRegionProximity proximity = TAKCLRegionProximityUnknown;
        switch (beacon.proximity) {
            case CLProximityImmediate:
                proximity = TAKCLRegionProximityImmediate;
                break;
                
            case CLProximityNear:
                proximity = TAKCLRegionProximityNear;
                break;
                
            case CLProximityFar:
                proximity = TAKCLRegionProximityFar;
                break;
                
            case CLProximityUnknown:
            default:
                proximity = TAKCLRegionProximityUnknown;
                break;
        }
        
        TAKiBeaconModel *model = [TAKiBeaconModel initWithProximityUUID:beacon.proximityUUID.UUIDString
                                                                  major:[beacon.major integerValue]
                                                                  minor:[beacon.minor integerValue]
                                                                   rssi:beacon.rssi
                                                               accuracy:beacon.accuracy
                                                              proximity:proximity];
        
        [modelArray addObject:model];
    }
    
    successRangingBlock(modelArray);
}

@end
