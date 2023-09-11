//
//  QNBleBroadcastDevice.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd. on 2019/7/11.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import "QNUser.h"
#import "QNConfig.h"
#import "QNScaleData.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleBroadcastDevice : NSObject

/** mac address */
@property (nonatomic, readonly, strong) NSString *mac;
/** Equipment name */
@property (nonatomic, readonly, strong) NSString *name;
/** Model identification */
@property (nonatomic, readonly, strong) NSString *modeId;
/** Bluetooth name*/
@property (nonatomic, readonly, strong) NSString *bluetoothName;
/** Signal strength */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
/** Whether to support the modification of the unit through agreement */
@property(nonatomic, readonly, assign) BOOL supportUnitChange;
/** The unit currently displayed on the scale */
@property(nonatomic, readonly, assign) QNUnit unit;
/** Current weight*/
@property(nonatomic, readonly, assign) double weight;
/** Whether to complete the measurement */
@property(nonatomic, readonly, assign) BOOL isComplete;
/** Data encoding when the measurement is completed */
@property(nonatomic, readonly, assign) int measureCode;

- (QNScaleData *)generateScaleDataWithUser:(QNUser *)user callback:(QNResultCallback)callback;

- (void)syncUnitCallback:(QNResultCallback)callback;

@end

NS_ASSUME_NONNULL_END
