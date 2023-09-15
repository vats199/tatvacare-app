//
//  QNWspConfig.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2019/1/27.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNWiFiConfig.h"
#import "QNUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNWspConfig : NSObject
/// wifi configuration object
@property (nullable, nonatomic, strong) QNWiFiConfig *wifiConfig;
/// Indx collection of users to be deleted
@property (nullable, nonatomic, strong) NSArray<NSNumber *> *deleteUsers;
/// Current measurement user (if you only need to configure the network and do not need to measure, you do not need to set up a user)
@property (nullable, nonatomic, strong) QNUser *curUser;
/// Do you need to register a user? With the isChange attribute, only one of them is allowed to be true
@property (nonatomic, assign) BOOL isRegist;
/// Do you need to modify the user information, and the isRegist attribute, only allow one of them to be true
@property (nonatomic, assign) BOOL isChange;
/// Whether it is in the guest mode, when the guest mode is used, it is not necessary to set the index and secret in the user object
@property (nonatomic, assign) BOOL isVisitor;
/// Data transmission address, only works when wifiConfig has a value
@property (nullable, nonatomic, strong) NSString *dataUrl;
/// OTA upgrade address
@property (nullable, nonatomic, strong) NSString *otaUrl;
/// Communication key
@property (nullable, nonatomic, strong) NSString *encryption;
/// Whether to read the sn code, it is not read by default
@property(nonatomic, assign) BOOL isReadSN;
/// Longitude, such as "123.4", "-22", "+0.5"
@property(nonatomic, strong) NSString *longitude;
/// Latitude, same as above
@property(nonatomic, strong) NSString *latitude;
/// Whether to delay the screen off time (about 60s delay), the default is false
@property(nonatomic, assign) BOOL isDelayScreenOff;
@end

NS_ASSUME_NONNULL_END
