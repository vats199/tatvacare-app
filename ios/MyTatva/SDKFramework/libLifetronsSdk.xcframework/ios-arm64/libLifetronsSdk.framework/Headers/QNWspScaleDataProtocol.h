//
//  QNWspScaleDataProtocol.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2020/3/6.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import "QNScaleDataProtocol.h"
#import "QNBleDevice.h"
#import "QNUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNWspScaleDataListener <QNScaleDataListener>

- (void)wspRegisterUserComplete:(QNBleDevice *)device user:(QNUser *)user;

- (void)wspLocationSyncStatus:(QNBleDevice *)device suceess:(BOOL)suceess;

- (void)wspReadSnComplete:(QNBleDevice *)device sn:(NSString *)sn;

@end

NS_ASSUME_NONNULL_END
