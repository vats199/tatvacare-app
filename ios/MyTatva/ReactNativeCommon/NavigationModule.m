//
//  NavigationModule.m
//  MyTatva
//
//  Created by Macbook Pro on 14/09/23.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import <React/RCTViewManager.h>
#import <React/RCTLog.h>
#import "React/RCTEventEmitter.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTRootView.h>
#import <React/RCTUtils.h>
#import <React/RCTConvert.h>
#import <React/RCTBundleURLProvider.h>

@interface RCT_EXTERN_MODULE(Navigation, NSObject)
RCT_EXTERN_METHOD(navigateTo: (NSString)destination)
RCT_EXPORT_VIEW_PROPERTY(data, NSDictionary *)
RCT_EXTERN_METHOD(navigateToHistory: (NSString)destination)
RCT_EXTERN_METHOD(navigateToBookmark)
RCT_EXTERN_METHOD(navigateToShareKit)
RCT_EXTERN_METHOD(navigateToPlan: (NSString)destination)
RCT_EXTERN_METHOD(navigateToMedicines: (NSString)destination)
RCT_EXTERN_METHOD(navigateToEngagement: (NSString)destination)
RCT_EXTERN_METHOD(navigateToIncident)
RCT_EXTERN_METHOD(navigateToExercise: (NSArray)destination)
RCT_EXTERN_METHOD(navigateToBookAppointment: (NSString)destination)
RCT_EXTERN_METHOD(openHealthKitSyncView)
//RCT_EXTERN_METHOD(getHomeScreenDataStatus: (RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(openUpdateReading: (NSArray)destination)
RCT_EXTERN_METHOD(openUpdateGoal: (NSArray)destination)
RCT_EXTERN_METHOD(goBack)
@end

//Event Emitter
@interface RCT_EXTERN_MODULE(RNEventEmitter, RCTEventEmitter)
RCT_EXTERN_METHOD(supportedEvents)
@end
