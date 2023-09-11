//
//  QNUser.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2018/1/9.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNCallBackConst.h"
#import "QNIndicateConfig.h"

typedef NS_ENUM(NSUInteger,YLUserShapeType) {
    YLUserShapeNone = 0, //none
    YLUserShapeSlim = 1, // Slim slim, slim
    YLUserShapeNormal = 2, // Normal
    YLUserShapeStrong = 3, // Strong bodybuilding, muscular
    YLUserShapePlim = 4, // full plump, overweight
};

typedef NS_ENUM(NSUInteger,YLUserGoalType) {
    YLUserGoalNone = 0, // none
    YLUserGoalLoseFat = 1, // Fat loss
    YLUserGoalStayHealth = 2, // Stay Health
    YLUserGoalGainMuscle = 3, // Muscle gain
    YLUserGoalPowerOftenExercise = 5, // Several power exercises a week, such as equipment exercises
    YLUserGoalPowerLittleExercise = 6, // Good foundation, but lack of systematic training
    YLUserGoalPowerOftenRun = 7, // aerobic exercise several times a week, such as running
};

typedef NS_ENUM(NSUInteger,YLAthleteType) {
    YLAthleteDefault = 0, // normal mode
    YLAthleteSport, //Athlete mode
};

@interface QNUser : NSObject
/** userID (if the scale supports user name display, the content of this field will be sent to the device) */
@property (nonatomic, strong) NSString *userId;
/** height */
@property (nonatomic, assign) int height;
/** gender: male or female */
@property (nonatomic, strong) NSString *gender;
/** birthday */
@property (nonatomic, strong) NSDate *birthday;
/** clothesWeight */
@property (nonatomic, assign) double clothesWeight;
/**
 Set the type of algorithm used
 1 represents the athlete algorithm, 0 is the normal algorithm
 When the user is younger than 18 years old, the normal mode is used even if it is set to the athlete mode
 */
@property (nonatomic, assign) YLAthleteType athleteType;

/** The figure of the user */
@property (nonatomic, assign) YLUserShapeType shapeType;
/** User goal */
@property (nonatomic, assign) YLUserGoalType goalType;

/** WSP equipment dedicated, the user index on the scale end, this value is returned by the scale end when the user is successfully registered with the scale */
@property (nonatomic, assign) int index;
/** WSP device dedicated, the user's secret key on the scale, the secret key is issued by the server */
@property (nonatomic, assign) int secret;

@property(nonatomic, strong) QNIndicateConfig *indicateConfig;

/**
 Build user model
 
 @param userId user id
 @param height User height
 @param gender user gender male female
 @param birthday User's date of birth age 3~80
 @param callback The callback of the result
 @return QNUser
 */
+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "0.5.2版本开始不必使用指定的构建方法");

/**
 Build user model
 
 @param userId user id
 @param height User height
 @param gender user gender male female
 @param birthday User's date of birth age 3~80
 @param athleteType is athlete mode
 @param callback The callback of the result
 @return QNUser
 */
+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType callback:(QNResultCallback)callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "0.5.2版本开始不必使用指定的构建方法");

/**
 Build user model
 
 @param userId user id
 @param height User height
 @param gender user gender male female
 @param birthday User's date of birth age 3~80
 @param athleteType is it an athlete mode
 @param shapeType User's figure
 @param goalType User goal
 @param callback callback
 @return QNUser
 */
+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType shapeType:(YLUserShapeType)shapeType goalType:(YLUserGoalType)goalType callback:(QNResultCallback)callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "0.5.2版本开始不必使用指定的构建方法");


@end
