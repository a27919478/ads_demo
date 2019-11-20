//
//  FLTNativeAudienceManager.m
//  firebase_admob
//
//  Created by developer on 2019/11/1.
//

#import "FLTNativeAudienceManager.h"

@implementation FLTNativeAudienceManager

+ (FLTNativeAudienceManager *)sharedManager {
    static FLTNativeAudienceManager *nativeAudienceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nativeAudienceManager = [[FLTNativeAudienceManager alloc] init];
    });
    return nativeAudienceManager;
}

- (NSMutableDictionary<NSString *,FLTNativeAudienceCache *> *)nativeAdDictionary {
    if (!_nativeAdDictionary) {
        _nativeAdDictionary = [[NSMutableDictionary alloc] init];
    }
    return _nativeAdDictionary;
}

@end
