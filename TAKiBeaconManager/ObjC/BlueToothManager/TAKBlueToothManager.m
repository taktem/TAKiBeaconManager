//
//  TAKBlueToothManager.m
//  TAKiBeaconManager
//
//  Created by TakuNishimura on 2014/11/28.
//  Copyright (c) 2014年 TakuNishimura. All rights reserved.
//

#import "TAKBlueToothManager.h"

TAKBlueToothBoolHandler boolHandler;

@import CoreBluetooth;

@interface TAKBlueToothManager()<CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;

@end

@implementation TAKBlueToothManager

/** Bluetoothの使用可否確認 **/
- (void)checkBluetoothAccessWithHandler:(TAKBlueToothBoolHandler)handler {
    boolHandler = handler;
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            boolHandler(YES);
            break;
            
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStatePoweredOff:
        case CBCentralManagerStateResetting:
        case CBCentralManagerStateUnsupported:
        case CBCentralManagerStateUnknown:
            boolHandler(NO);
            break;
    }
}

@end
