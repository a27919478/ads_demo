//
//  FLTNativeAudienceManager.h
//  firebase_admob
//
//  Created by developer on 2019/11/1.
//

#import <Foundation/Foundation.h>
#import "FLTNativeAudienceCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLTNativeAudienceManager : NSObject

+ (FLTNativeAudienceManager *)sharedManager;

@property (nonatomic, strong) NSMutableDictionary<NSString *, FLTNativeAudienceCache *> *nativeAdDictionary;

@end

NS_ASSUME_NONNULL_END
