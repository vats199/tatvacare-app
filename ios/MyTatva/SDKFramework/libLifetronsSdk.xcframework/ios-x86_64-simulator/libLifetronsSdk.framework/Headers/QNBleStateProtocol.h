//
//  QNBleStateProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Lifetrons Software Pvt. Ltd on 2018/3/31.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

typedef NS_ENUM(NSUInteger, QNBLEState) {
    QNBLEStateUnknown = 0,
    QNBLEStateResetting = 1,
    QNBLEStateUnsupported = 2,
    QNBLEStateUnauthorized = 3,
    QNBLEStatePoweredOff = 4,
    QNBLEStatePoweredOn = 5,
};

@protocol QNBleStateListener <NSObject>

/**
 Callback of system Bluetooth status
 
 @param state QNBLEState
 */
- (void)onBleSystemState:(QNBLEState)state;

@end
