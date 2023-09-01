//
//  QNBleKitchenDevice.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2019/10/22.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleKitchenDevice : NSObject
/** mac address */
@property (nonatomic, readonly, strong) NSString *mac;
/** name */
@property (nonatomic, readonly, strong) NSString *name;
/** name */
@property (nonatomic, readonly, strong) NSString *modeId;
/** Signal strength */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
/** The unit currently displayed on the scale (G, ml, oz, lb:oz) */
@property(nonatomic, readonly, assign) QNUnit unit;
/** Current weight in g*/
@property(nonatomic, readonly, assign) double weight;
/** Has it been peeled */
@property(nonatomic, readonly, assign) BOOL isPeel;
/** Whether to carry weight */
@property(nonatomic, readonly, assign) BOOL isNegative;
/** Whether overloaded*/
@property(nonatomic, readonly, assign) BOOL isOverload;
/** Is it a Bluetooth kitchen scale */
@property(nonatomic, readonly, assign) BOOL isBluetooth;
/** Measure whether the weight is stable, valid for Bluetooth kitchen scales */
@property(nonatomic, readonly, assign) BOOL isStable;
/** Bluetooth name, valid for Bluetooth kitchen scale */
@property (nonatomic, readonly, strong) NSString *bluetoothName;

@end

NS_ASSUME_NONNULL_END
