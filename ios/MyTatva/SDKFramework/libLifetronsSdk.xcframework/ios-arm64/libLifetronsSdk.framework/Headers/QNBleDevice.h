//
//  QNBleDevice.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd. on 2019/7/11.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QNDeviceType) {
    QNDeviceTypeScaleBleDefault = 100, //Ordinary Bluetooth scale
    QNDeviceTypeScaleBroadcast = 120, //Broadcast scale
    QNDeviceTypeScaleKitchen = 130, //kitchen scale
    QNDeviceTypeScaleWsp = 140, //wsp bluetooth scale
    QNDeviceTypeHeightScale = 160, //Height and weight scale
};

@interface QNBleDevice : NSObject
/** mac address */
@property (nonatomic, readonly, strong) NSString *mac;
/** Device name */
@property (nonatomic, readonly, strong) NSString *name;
/** Model identification */
@property (nonatomic, readonly, strong) NSString *modeId;
/** Bluetooth name */
@property (nonatomic, readonly, strong) NSString *bluetoothName;
/** Signal strength */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
/** Is it powered on */
@property (nonatomic, readonly, getter=isScreenOn, assign) BOOL screenOn;
/** Whether to support WIFI */
@property (nonatomic, readonly, getter=isSupportWifi, assign) BOOL supportWifi;
/** Equipment type */
@property (nonatomic, readonly, assign) QNDeviceType deviceType;
/** (WSP device exclusive) Maximum number of registered users supported by wsp scale */
@property(nonatomic, readonly, assign) int maxUserNum;
/** (WSP device exclusive) Number of registered users of wsp scale */
@property(nonatomic, readonly, assign) int registeredUserNum;
/** (WSP device exclusive) Whether to support eight electrodes */
@property(nonatomic, readonly, assign) BOOL isSupportEightElectrodes;
@end
