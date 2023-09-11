//
//  QNScaleData.h
//  QNDeviceSDK
//
//  Created by Lifetrons Software Pvt. Ltd on 2018/1/9.
//  Copyright © 2023 Lifetrons Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUser.h"
#import "QNScaleItemData.h"

typedef NS_ENUM(NSUInteger, QNHeightWeightMode) {
    QNHeightWeightModeWeight = 0,
    QNHeightWeightModeBodyfat = 1,
};

@interface QNScaleData : NSObject

/** Owner of measurement data */
@property (nonatomic, strong, readonly) QNUser *user;

/** Measurement data measurement time */
@property (nonatomic, strong, readonly) NSDate *measureTime;

/** Data identification */
@property (nonatomic, strong, readonly) NSString *hmac;

/** Height (exclusive for height and weight scale) */
@property (nonatomic, assign, readonly) double height;

/** Mode (exclusive for height and weight scale) */
@property (nonatomic, assign, readonly) QNHeightWeightMode heightMode;

@property(nonatomic, assign, readonly) double weight;

@property(nonatomic, assign, readonly) NSInteger resistance50;

@property(nonatomic, assign, readonly) NSInteger resistance500;


- (instancetype)init NS_UNAVAILABLE;

/**
 Get the details of the current indicator by calling this method
 
 @param type QNScaleType
 @return QNScaleItemData
 */
- (QNScaleItemData *)getItem:(QNScaleType)type;

/**
 Get the value of the current indicator
 
 @param type QNScaleType
 @return indicator value
 */
- (double)getItemValue:(QNScaleType)type;

/**
 Get the indicator details after this measurement
 
 @return A collection of indicator details
 */
- (NSArray <QNScaleItemData *> *)getAllItem;

/**
 Body fat change control
 
 @param threshold controls the range of changes
 @param hmac Last measured data identifier
 @param callback Whether to control the successful callback
 */
- (void)setFatThreshold:(double)threshold hmac:(NSString *)hmac callBlock:(QNResultCallback)callback;

@end
