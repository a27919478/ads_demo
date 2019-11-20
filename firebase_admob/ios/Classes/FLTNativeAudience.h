//
//  FLTNativeAudience.h
//  firebase_admob
//
//  Created by nanzeng liu on 2019/6/28.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "GoogleMobileAds/GoogleMobileAds.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLTNativeAudience : NSObject<FlutterPlatformView>

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

/// 根据广告位ID加载广告
- (void)loadWithAdUnitId:(NSString *)adUnitId;

@end

NS_ASSUME_NONNULL_END
