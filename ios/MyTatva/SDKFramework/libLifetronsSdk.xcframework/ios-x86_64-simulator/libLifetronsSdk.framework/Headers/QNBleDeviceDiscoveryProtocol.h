//
//  QNBleDeviceDiscoveryProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Lifetrons Software Pvt. Ltd on 2018/3/31.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNBleBroadcastDevice.h"
#import "QNBleKitchenDevice.h"

@protocol QNBleDeviceDiscoveryListener <NSObject>
@optional
/**
 This method will call back after successfully starting the scan method
 */
- (void)onStartScan;


/**
 This method will call back after the device is discovered
 
 @param device QNBleDevice
 */
- (void)onDeviceDiscover:(QNBleDevice *)device;

/**
 Device callback after receiving the broadcast scale
  
 @param device QNBleDevice
 */
- (void)onBroadcastDeviceDiscover:(QNBleBroadcastDevice *)device;


/**
 Equipment callback after receiving the kitchen scale

@param device QNBleDevice
*/
- (void)onKitchenDeviceDiscover:(QNBleKitchenDevice *)device;

/**
 This method will call the user "- (void)stopBleDeviceDiscorvery:(QNResultCallback)callback" method or set the scan time, and call back after the scan is over
 */
- (void)onStopScan;

@end
