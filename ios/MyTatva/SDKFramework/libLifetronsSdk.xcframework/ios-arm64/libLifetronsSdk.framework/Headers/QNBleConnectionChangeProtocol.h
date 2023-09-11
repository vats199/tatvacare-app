//
//  QNBleConnectionChangeProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Lifetrons Software Pvt. Ltd. on 2019/7/11.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import "QNBleDevice.h"

typedef NS_ENUM(NSInteger, QNScaleState) {
    QNScaleStateDisconnected = 0, //not connected
    QNScaleStateLinkLoss = -1, //Loss the connection
    QNScaleStateConnected = 1, //Connected
    QNScaleStateConnecting = 2, //Connecting
    QNScaleStateDisconnecting = 3, //Disconnecting
    QNScaleStateStartMeasure = 4, //is measuring
    QNScaleStateRealTime = 5, //Weight is being measured
    QNScaleStateBodyFat = 7, //Testing bioimpedance
    QNScaleStateHeartRate = 8, //Heart rate is being tested
    QNScaleStateMeasureCompleted = 9, //Measurement completed
    QNScaleStateWiFiBleStartNetwork = 10, //WiFi Bluetooth dual-mode device starts to configure the network
    QNScaleStateWiFiBleNetworkSuccess = 11, //WiFi Bluetooth dual-mode device is successfully connected to the Internet
    QNScaleStateWiFiBleNetworkFail = 12, //WiFi Bluetooth dual-mode device fails to connect to the Internet
    QNScaleStateBleKitchenPeeled = 13, //Bluetooth kitchen scale scale end peeled
};

@protocol QNBleConnectionChangeListener <NSObject>
/**
 Connecting callback
 
 @param device QNBleDevice
 */
-(void)onConnecting:(QNBleDevice *)device;


/**
 Callback for successful connection
 
 @param device QNBleDevice
 */
-(void)onConnected:(QNBleDevice *)device;


/**
 The service search for the device is complete
 
 @param device QNBleDevice
 */
-(void)onServiceSearchComplete:(QNBleDevice *)device;


/**
 Disconnecting
 
 @param device QNBleDevice
 */
-(void)onDisconnecting:(QNBleDevice *)device;

/**
 Device disconnected
 
 @param device QNBleDevice
 */
-(void)onDisconnected:(QNBleDevice *)device;


/**
 connection error
 
 @param device QNBleDevice
 @param error error code
 */
- (void)onConnectError:(QNBleDevice *)device error:(NSError *)error;

@end

