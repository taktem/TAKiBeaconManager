//
//  ViewController.m
//  TAKiBeaconManager
//
//  Created by 西村 拓 on 2015/09/16.
//  Copyright (c) 2015年 TakuNishimura. All rights reserved.
//

#import "ViewController.h"

#import "TAKiBeaconConnector.h"
#import "TAKBlueToothManager.h"

@interface ViewController ()

@property (strong, nonatomic) TAKiBeaconConnector *beaconConnector;
@property (strong, nonatomic) TAKBlueToothManager *bleManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkBLEPermission];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)checkBLEPermission {
    self.bleManager = [TAKBlueToothManager new];
    
    __weak typeof(self) weakSelf = self;
    [self.bleManager checkBluetoothAccessWithHandler:^(BOOL result) {
        if (result) {
            [weakSelf initBeacon];
        } else {
            NSLog(@"not allow BLE");
        }
    }];
}

- (void)initBeacon {
    self.beaconConnector = [TAKiBeaconConnector new];
    self.beaconConnector.authType = TAKLocationAuthTypeAlways;
    [self.beaconConnector defaultSetting];
    [self.beaconConnector createBeaconRegionWithUUID:@"541C945B-6655-4621-B388-9EDA0D1294F1"];
    
    __weak typeof(self) weakSelf = self;
    [self.beaconConnector setMonitoringBlockWithSuccess:^(ENCLRegionState response) {
        switch (response) {
            case ENCLRegionStateInside: {
                NSLog(@"RegionStateInside");
                [weakSelf startRanging];

                break;
            }
            case ENCLRegionStateOutside: {
                NSLog(@"RegionStateOutside");
                break;
            }
            case ENCLRegionStateUnknown: {
                NSLog(@"RegionStateUnknown");
                break;
            }
            default: {
                break;
            }
        }
    } failure:^(NSError *error) {
        
    }];
    [self.beaconConnector startMonitoring];
    
}

- (void)startRanging {
    [self.beaconConnector setRanginBlockWithSuccess:^(NSArray<TAKiBeaconModel *> *modelArray) {
        NSLog(@"%lu",modelArray.firstObject.major);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    [self.beaconConnector startRanging];
}

@end
