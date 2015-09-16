//
//  TAKBlueToothManager.h
//  TAKiBeaconManager
//
//  Created by TakuNishimura on 2014/11/28.
//  Copyright (c) 2014年 TakuNishimura. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TAKBlueToothBoolHandler)(BOOL result);

@interface TAKBlueToothManager : NSObject

/** ブルートゥースの使用可否確認 **/
- (void)checkBluetoothAccessWithHandler:(TAKBlueToothBoolHandler)handler;

@end
