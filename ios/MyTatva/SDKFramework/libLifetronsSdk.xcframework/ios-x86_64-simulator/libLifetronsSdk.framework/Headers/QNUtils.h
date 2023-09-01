//
//  QNUtils.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2019/1/27.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUser.h"
#import "QNScaleData.h"

NS_ASSUME_NONNULL_BEGIN


@interface QNShareData : NSObject

@property (nullable, nonatomic, strong, readonly) NSString *sn;

@property (nullable, nonatomic, strong, readonly) QNScaleData *scaleData;

@end


@interface QNUtils : NSObject

+ (nullable QNShareData *)decodeShareDataWithCode:(NSString *)qnCode user:(QNUser *)user callblock:(QNResultCallback)callblock;

+ (nullable QNShareData *)decodeShareDataWithCode:(NSString *)qnCode user:(QNUser *)user validTime:(long)validTime callblock:(QNResultCallback)callblock;


@end

NS_ASSUME_NONNULL_END
