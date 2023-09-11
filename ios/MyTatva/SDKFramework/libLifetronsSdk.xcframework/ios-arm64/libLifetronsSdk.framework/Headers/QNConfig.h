//
//  QNConfig.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2018/3/27.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Display of the weight unit on the scale
 
 -QNUnitKG: All devices support the display of this unit
 -QNUnitLB: If the device does not support the display of the unit, the "QNUnitKG" type will be displayed even if it is set to the "QNUnitLB" type
 -QNUnitJIN: If the device does not support the display of the unit, the "QNUnitKG" type will be displayed even if it is set to the "QNUnitJIN" type
 -QNUnitSt: If the device does not support the display of the unit, but supports the display of "QNUnitLB", it will display "QNUnitLB"
 -QNUnitStLb: If the device does not support the display of the unit, but supports the display of "QNUnitLB", it will display "QNUnitLB"
 */
typedef NS_ENUM(NSUInteger, QNUnit) {
    QNUnitKG = 0,
    QNUnitLB = 1,
    QNUnitJIN = 2,
    QNUnitStLb = 3,
    QNUnitSt = 4,
    
    QNUnitG = 10, //Exclusive to kitchen scale
    QNUnitML = 11, //Exclusive to kitchen scale
    QNUnitOZ = 12, //Exclusive to kitchen scale
    QNUnitLBOZ = 13, //Exclusive to kitchen scale
    QNUnitMilkML = 14, // Exclusive for Bluetooth kitchen scale
};


typedef NS_ENUM(NSUInteger,YLAreaType) {
    YLAreaTypeOther = 0, //Other
    YLAreaTypeAsia = 1, // Asia
};

/**
 The QNConfig class, after the user sets it, the SDK will automatically save the setting information, and when the setting information in the class is used again, the information set by the user last time will be used
 */
@interface QNConfig : NSObject

/** Whether to return only the devices that have been turned on (bright screen), the default is false */
@property (nonatomic, assign) BOOL onlyScreenOn;

/** Whether the same device returns multiple times, the default is false, this setting is invalid for broadcast scales*/
@property (nonatomic, assign) BOOL allowDuplicates;

/**
 Scan duration, the unit is ms, the default is 0, that is, always scan, unless the APP calls stopBleDeviceDiscovery
 When it is not 0, the minimum value is 3000ms, after a delay of duration ms, the scan will stop automatically
 */
@property (nonatomic, assign) int duration;

/** If the unit displayed on the terminal is not set, the SDK defaults to kg, and it will be saved locally after setting. If the device is currently connected, the unit display on the scale will be updated in real time as much as possible. This setting is invalid for broadcast scales. To modify the unit of broadcast scales, please go to【QNBleBroadcastDevice 】*/
@property (nonatomic, assign) QNUnit unit;

/**
 This setting is valid only when the "- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback" method is called. This setting is automatically configured when the SDK is restarted.
 For details on the role of this attribute, please refer to Apple Developer Documenttation => CoreBluetooth => CBCentralManager => Central Manager Initialization Options
 */
@property (nonatomic, assign) BOOL showPowerAlertKey;

/**
 Strengthen the broadcast scale signal
 */
@property (nonatomic, assign) BOOL enhanceBleBoradcast;

/// Save setting information
- (BOOL)save;

- (instancetype)init NS_UNAVAILABLE;

@end
