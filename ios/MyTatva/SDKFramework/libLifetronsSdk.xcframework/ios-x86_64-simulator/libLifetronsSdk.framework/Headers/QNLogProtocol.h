//
//  QNLogProtocol.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2019/7/1.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QNLogProtocol <NSObject>

- (void)onLog:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
