//
//  QNBleApi.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd. on 2019/7/11.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "QNBleStateProtocol.h"
#import "QNBleDeviceDiscoveryProtocol.h"
#import "QNBleConnectionChangeProtocol.h"
#import "QNScaleDataProtocol.h"
#import "QNBleKitchenProtocol.h"
#import "QNLogProtocol.h"
#import "QNUser.h"
#import "QNConfig.h"
#import "QNWiFiConfig.h"
#import "QNBleProtocolDelegate.h"
#import "QNBleProtocolHandler.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "QNWspConfig.h"
#import "QNBleKitchenConfig.h"

/**
 This SDK is a static library of Lifetrons's device connection tool. When using it, you need to obtain the "appId" from the Lifetrons official, otherwise the SDK cannot be used normally
 
 Current version【 2.5.6】
 
 SDK minimum configuration 8.0 system
 
 Configuration instructions of the project:
 1. Apple officially stipulates that after iOS10.0 (including 10.0), the "Privacy-Bluetooth Peripheral Usage Description" key must be used in the Info.plist for Bluetooth instructions, otherwise the system Bluetooth cannot be used
 2. Introduce the SDK path [TARGETS] -> [Build Setting] -> [Search Paths] -> [LibrarySearch Paths] to add the SDK path
 3. Configure the linker [TARGETS] -> [Build Setting] -> [Linking] -> [Other Linker Flags] add one of "-ObjC", "-all_load", "-force_load [SDK path]"
 
 
 Description of scale measurement method:
 1. It must be measured with bare feet to measure the bio-impedance of the human body
 
 
 Explanation about scale data:
 1. Measure when connected to the scale, and the data will be uploaded immediately after the measurement is completed
 2. When measuring when the scale is not connected, the measurement data will be automatically stored on the scale. For details, please refer to the "QNScaleStoreData" storage data category
 
 There are two situations for broadcasting:
 1. When the scale is on, it will broadcast
 2. When the scale has stored data, it will broadcast even if the scale is off the screen
 
 */

@interface QNBleApi : NSObject

/** Whether to turn on the debugging switch The default is NO (it is recommended to set it to NO when the version is released) */
@property (nonatomic, assign, class) BOOL debug;

/**
 Discovery of device monitoring, the monitoring must be implemented, otherwise the searched device information cannot be obtained
 Details can be viewed in QNBleDeviceDiscorveryProtocol.h
 
 */
@property (nonatomic, weak) id<QNBleDeviceDiscoveryListener> discoveryListener;

/**
 Monitoring of device status
 Details can be viewed in QNBleConnectionChangeProtocol.h
 
 */
@property (nonatomic, weak) id<QNBleConnectionChangeListener> connectionChangeListener;


/**
 Log information monitoring
 When you don’t need to collect logs, you can ignore the monitoring
 The callbacks monitored here are not controlled by the debug switch
 */
@property(nonatomic, weak) id<QNLogProtocol> logListener;

/**
 Monitoring of measurement data, the monitoring must be implemented
 Details can be viewed in QNScaleDataProtocol.h
 
 */
@property (nonatomic, weak) id<QNScaleDataListener> dataListener;

/**
 Monitoring of measurement data of bluetooth kitchen scale
 Details can be viewed in QNBleKitchenDataProtocol.h
 
 */
@property (nonatomic, weak) id<QNBleKitchenListener> bleKitchenListener;

/**
 Monitor the Bluetooth status of the system
 Details can be viewed in QNBleStateProtocol.h
 
 */
@property (nonatomic, weak) id<QNBleStateListener> bleStateListener;

/**
 Initialize SDK
 
 @return QNBleApi
 */
+ (QNBleApi *)sharedBleApi;


/**
 Register SDK
 You must register the SDK before using other operations
 Appid and initial configuration files, please discuss with Lifetrons official
 
 @param appId needs to obtain the correct appid from the official
 @param dataFile configuration file path
 @param callback result callback
 */
-(void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback;

/**
 Register SDK
 You must register the SDK before using other operations
 Appid and initial configuration files, please discuss with Lifetrons official
 
 @param appId needs to obtain the correct appid from the official
 @param dataFileContent configuration file content
 @param callback result callback
 */
-(void)initSdk:(NSString *)appId dataFileContent:(NSString *)dataFileContent callback:(QNResultCallback)callback;

/**
 
 Get the current system bluetooth turntable
 
 @return QNUser
 */
-(QNBLEState)getCurSystemBleState;

/**
 Scanning device
 
 @param callback result callback
 */
-(void)startBleDeviceDiscovery:(QNResultCallback)callback;


/**
 Stop scanning
 
 @param callback result callback
 */
-(void)stopBleDeviceDiscorvery:(QNResultCallback)callback;


/**
 Connect the device
 
 @param device connected device (the device object must be the device object returned by the search)
 @param user user information
 @param callback result callback
 */
-(void)connectDevice:(QNBleDevice *)device user:(QNUser *)user callback:(QNResultCallback)callback;

/**
 Connect Lifetrons Wsp device
 
 @param device Bluetooth device to be connected
 @param config Configuration items when connecting wsp device
 @param callback result callback
 */
- (void)connectWspDevice:(QNBleDevice *)device config:(QNWspConfig *)config callback:(QNResultCallback)callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "2.4.2版本开始废弃connectWspDevice:改为使用connectDevice:");

/**
 Disconnect the device
 
 @param device currently connected device
 @param callback result callback
 */
-(void)disconnectDevice:(QNBleDevice *)device callback:(QNResultCallback)callback;

/**
 Disconnect the device
 @param mac The currently connected device mac
 @param callback result callback
 */
-(void)disconnectDeviceWithMac:(NSString *)mac callback:(QNResultCallback)callback;

/**
 
 Network configuration for WiFi dual-mode devices
 
 @param device Need to configure the network equipment
 @param user user information
 @param wifiConfig WiFi information of the network configuration
 @param callback Return of the network configuration operation You can obtain the result of the network configuration by monitoring the "- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state" method
 */
-(void)connectDeviceSetWiFiWithDevice:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNWiFiConfig *)wifiConfig callback:(QNResultCallback)callback;

/**
 Register WiFi Bluetooth dual-mode scale with Lifetrons Cloud
 
 Currently only allows to register WiFi Bluetooth dual-mode scales
 
 @param device QNBleDevice
 @param callback registration result
 */
-(void)registerWiFiBleDevice:(QNBleDevice *)device callback:(QNResultCallback)callback;

/**
 Get the current settings of the SDK
 
 @return QNConfig
 */
-(QNConfig *)getConfig;

/**
 The weight according to the provided kg value is converted into a value in the specified unit
 
 @param weight Default unit weight (body fat scale is KG, kitchen scale is G)
 @param unit KG, LB, JIN, ST, STLB are body fat scale units (ST conversion is not supported, query documents for related conversion methods) G, ML, OZ, LBOZ are kitchen scale units (LBOZ conversion query documents are not supported Get relevant conversion methods)
 @return result callback
 */
-(double)convertWeightWithTargetUnit:(double)weight unit:(QNUnit)unit;

/**
 Build user model
 
 @param userId user id
 @param height User height
 @param gender user gender male female
 @param birthday user's date of birth
 @param callback The callback of the result
 @return QNUser
 */
-(QNUser *)buildUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback;

/**
 Create SDK Bluetooth Object
 
 @param peripheral peripheral object
 @param rssi signal strength
 @param advertisementData Bluetooth broadcast data
 @param callback The callback of the result
 @return QNBleDevice
 */
-(QNBleDevice *)buildDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback;

/**
 Create Lifetrons Broadcasting Bluetooth Scale Device Object
 
 @param peripheral peripheral object
 @param rssi signal strength
 @param advertisementData Bluetooth broadcast data
 @param callback The callback of the result
 @return QNBleBroadcastDevice
 */
-(QNBleBroadcastDevice *)buildBroadcastDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback;

/**
 Create Lifetrons Kitchen Broadcasting Bluetooth Scale Device Object
 
 @param peripheral peripheral object
 @param rssi signal strength
 @param advertisementData Bluetooth broadcast data
 @param callback The callback of the result
 @return QNBleKitchenDevice
 */
-(QNBleKitchenDevice *)buildKitchenDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback;

/**
 Create a Bluetooth protocol handler
 
 @param device device
 @param user user model
 @param delegate protocol processing class
 @param callback The callback of the result
 @return QNBleProtocolHandler
 */
-(QNBleProtocolHandler *)buildProtocolHandler:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNWiFiConfig *)wifiConfig delegate:(id<QNBleProtocolDelegate>)delegate callback:(QNResultCallback)callback;

/**
 Method of generating measurement data (this method only supports wsp equipment)
 
 @param user The user of the data
 @param modeId model ID
 @param weight weight. The unit is kg
 @param measureDate measuring time
 @param resistance 50 impedance
 @param secResistance 500 impedance
 @param hmac encrypted field
 @param heartRate heart rate value, if not, assign a value of 0
 @return QNScaleData
 */
- (QNScaleData *)generateScaleData:(QNUser *)user modeId:(NSString *)modeId weight:(double)weight date:(NSDate *)measureDate resistance:(int)resistance secResistance:(int)secResistance hmac:(NSString *)hmac heartRate:(int)heartRate;

/**
 Physical fitness calculation method
 
 @param user The user of the data
 @param area area
 @param weight weight. The unit is kg
 @param measureDate measuring time
 @return QNScaleData
 */
-(nullable QNScaleData *)physiqueCalculation:(nonnull QNUser *)user area:(YLAreaType)area weight:(double)weight date:(nonnull NSDate *)measureDate;

/**
 Connect a Bluetooth kitchen scale
 
 @param device connected device (the device object must be the Bluetooth kitchen scale device object returned by the search)
 @param callback result callback
 */
-(void)connectBleKitchenDevice:(QNBleKitchenDevice *)device callback:(QNResultCallback)callback;

/**
 Set Bluetooth kitchen scale information
 
 @param config setting information
 */
- (void)setBleKitchenDeviceConfig:(QNBleKitchenConfig *)config;

@end

