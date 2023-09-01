//
//  QNBleProtocolDelegate.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2021/11/17.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QNBleProtocolDelegate <NSObject>

/**
 Write characteristic value
 
 @param serviceUUID UUID of the Bluetooth service
 @param characteristicUUID UUID of characteristic value
 @param data The data to be written
 @param device The device that needs to write data
 */
- (void)writeCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data device:(QNBleDevice *)device;

/**
 Read characteristic value
 
 @param serviceUUID UUID of the Bluetooth service
 @param characteristicUUID UUID of characteristic value
 @param device The device that needs to write data
 */
- (void)readCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID  device:(QNBleDevice *)device;
@end

NS_ASSUME_NONNULL_END
