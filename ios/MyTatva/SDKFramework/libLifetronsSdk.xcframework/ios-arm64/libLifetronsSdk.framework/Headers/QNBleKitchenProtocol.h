//
//  QNBleKitchenProtocol.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2021/11/17.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBleKitchenDevice.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNBleKitchenListener <NSObject>

@required
/**
 Bluetooth kitchen scale measurement data monitoring
 
 @param device QNBleKitchenDevice
 @param weight real-time weight
 */
-(void)onGetBleKitchenWeight:(QNBleKitchenDevice *)device weight:(double)weight;

/**
 Bluetooth kitchen scale connection or measurement status change
 
 @param device QNBleKitchenDevice
 @param state state
 */
-(void)onBleKitchenStateChange:(QNBleKitchenDevice *)device scaleState:(QNScaleState)state;

@optional
/**
 Connecting callback
 
 @param device QNBleKitchenDevice
 */
-(void)onBleKitchenConnecting:(QNBleKitchenDevice *)device;

/**
 Callback for successful connection
 
 @param device QNBleKitchenDevice
 */
-(void)onBleKitchenConnected:(QNBleKitchenDevice *)device;

/**
 Disconnect
 
 @param device QNBleKitchenDevice
 */
-(void)onBleKitchenDisconnected:(QNBleKitchenDevice *)device;

/**
 connection error
 
 @param device QNBleDevice
 @param error error code
 */
- (void)onBleKitchenConnectError:(QNBleKitchenDevice *)device error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
