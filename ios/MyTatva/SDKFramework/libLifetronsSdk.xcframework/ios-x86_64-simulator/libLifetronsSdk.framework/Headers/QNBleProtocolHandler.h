//
//  QNBleProtocolHandler.h
//  QNDeviceSDKDemo
//
//  Created by Lifetrons Software Pvt. Ltd on 2019/8/26.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBleProtocolHandler : NSObject

/** Peripheral equipment */
@property (nonatomic, strong) CBPeripheral *peripheral;

/**
 Notification protocol handler initialization
 
 @param serviceUUID UUID of the main service
 */
- (void)prepare:(NSString *)serviceUUID;

/**
 Get Bluetooth data
  
  @param serviceUUID UUID of the Bluetooth service
  @param characteristicUUID UUID of characteristic value
  @param data Bluetooth data returned
 */
- (void)onGetBleData:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
