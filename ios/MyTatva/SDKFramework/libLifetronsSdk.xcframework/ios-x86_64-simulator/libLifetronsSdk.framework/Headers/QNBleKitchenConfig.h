//
//  QNBleKitchenConfig.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2021/11/17.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleKitchenConfig : NSObject

/** The unit displayed on the end*/
@property (nonatomic, assign) QNUnit unit;

/** Set whether the scale end is peeled or not*/
@property (nonatomic, assign) BOOL isPeel;
@end

NS_ASSUME_NONNULL_END
