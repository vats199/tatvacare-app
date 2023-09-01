//
//  QNScaleDataProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Lifetrons Software Pvt. Ltd on 2018/1/9.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNScaleData.h"
#import "QNScaleStoreData.h"

typedef NS_ENUM(NSInteger, QNScaleEvent) {
    QNScaleEventWiFiBleStartNetwork = 1, //WiFi Bluetooth dual-mode device starts to configure the network
    QNScaleEventWiFiBleNetworkSuccess = 2, //WiFi Bluetooth dual-mode device successfully connected to the network
    QNScaleEventWiFiBleNetworkFail = 3, //WiFi Bluetooth dual-mode device fails to connect to the network
    QNScaleEventRegistUserSuccess = 4, //WSP scale exclusive, user registered successfully
    QNScaleEventRegistUserFail = 5, //WSP scale exclusive, user registration failed
    QNScaleEventVisitUserSuccess = 6, //Exclusive to WSP scale, successful user access
    QNScaleEventVisitUserFail = 7, //WSP scale exclusive, access user failed
    QNScaleEventDeleteUserSuccess = 8, //WSP scale exclusive, delete user successfully
    QNScaleEventDeleteUserFail = 9, //WSP scale exclusive, user deletion failed
    QNScaleEventSyncUserInfoSuccess = 10, //WSP scale exclusive, successfully synchronized user information
    QNScaleEventSyncUserInfoFail = 11, //WSP scale exclusive, failed to synchronize user information
    
};

@protocol QNScaleDataListener <NSObject>

/**
 Real-time data monitoring
 
 @param device QNBleDevice
 @param weight real-time weight
 */
-(void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight;

/**
 Monitoring of stable data
 
 @param device QNBleDevice
 @param scaleData data result
 */
-(void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData;


/**
 Monitoring of stored data
 
 @param device QNBleDevice
 @param storedDataList result array
 */
-(void)onGetStoredScale:(QNBleDevice *)device data:(NSArray <QNScaleStoreData *> *)storedDataList;

/**
 Monitoring of charging amount
 
 @param electric electric
 @param device QNBleDevice
 */
-(void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device;;

/**
 Scale connection or measurement status change
 
 @param device QNBleDevice
 @param state state
 */
-(void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state;

/**
 Callback of scale event
 
 @param device QNBleDevice
 @param scaleEvent scale event
 */
-(void)onScaleEventChange:(QNBleDevice *)device scaleEvent:(QNScaleEvent)scaleEvent;
@end
