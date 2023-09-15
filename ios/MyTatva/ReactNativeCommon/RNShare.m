//
//  RNShare.m
//  MyTatva
//
//  Created by Macbook Pro on 13/09/23.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <React/RCTLog.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <React/RCTLog.h>
#import "React/RCTEventEmitter.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTRootView.h>
#import <React/RCTConvert.h>
#import <React/RCTBundleURLProvider.h>

@interface RCT_EXTERN_MODULE(RNShare, NSObject)

RCT_EXTERN_METHOD(getToken: (RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject)

+ (BOOL) requiresMainQueueSetup {
  return YES;
}

@end
