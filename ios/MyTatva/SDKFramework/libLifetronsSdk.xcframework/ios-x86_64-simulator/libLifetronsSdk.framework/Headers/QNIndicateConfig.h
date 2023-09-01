//
//  QNIndicateConfig.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2021/11/17.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNIndicateConfig : NSObject
/// Whether to display the user name
@property(nonatomic, assign) BOOL showUserName;
/// Whether to display BMI
@property(nonatomic, assign) BOOL showBmi;
/// Whether to display bone mass
@property(nonatomic, assign) BOOL showBone;
/// Whether to display body fat rate
@property(nonatomic, assign) BOOL showFat;
/// Whether to show muscle mass
@property(nonatomic, assign) BOOL showMuscle;
/// Whether to display body moisture
@property(nonatomic, assign) BOOL showWater;
/// Whether to display the heart rate
@property(nonatomic, assign) BOOL showHeartRate;
/// Whether to display the weather
@property(nonatomic, assign) BOOL showWeather;
/// Whether to display the weight trend
@property(nonatomic, assign) BOOL weightExtend;
/// Whether to start the sound
@property(nonatomic, assign) BOOL sound;
@end

NS_ASSUME_NONNULL_END
