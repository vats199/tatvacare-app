//
//  QNWiFiConfig.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2019/1/27.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNWiFiConfig : NSObject

/** WiFi name */
@property(nonatomic, strong) NSString *ssid;
/** WiFi password */
@property(nonatomic, strong, nullable) NSString *pwd;

/** Data transfer address. WSP device settings are valid, other devices can be set to null*/
@property(nonatomic, strong, nullable) NSString *serveUrl;

/** Check the validity of the WiFi name */
- (BOOL)checkSSIDVail;
/** Check the validity of the WiFi password */
- (BOOL)checkPWDVail;

@end

NS_ASSUME_NONNULL_END
