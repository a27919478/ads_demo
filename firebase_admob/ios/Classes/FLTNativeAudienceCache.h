//
//  FLTNativeAudienceCache.h
//  firebase_admob
//
//  Created by developer on 2019/11/1.
//

#import <Foundation/Foundation.h>
#import "GoogleMobileAds/GoogleMobileAds.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLTNativeAudienceCache : NSObject

/// 缓存时间(时间戳，两分钟后失效)
@property (nonatomic, assign) NSInteger cacheTime;

/// 原生广告
@property (nonatomic, strong) GADUnifiedNativeAd *nativeAd;

/// 是否使用缓存
/// cacheTime 缓存时间上限
- (BOOL)isUseCache:(NSInteger)cacheTime;

@end

NS_ASSUME_NONNULL_END
