//
//  FLTNativeAudienceCache.m
//  firebase_admob
//
//  Created by developer on 2019/11/1.
//

#import "FLTNativeAudienceCache.h"

@implementation FLTNativeAudienceCache

- (BOOL)isUseCache:(NSInteger)cacheTime {
    NSInteger leftTime = [[NSDate date] timeIntervalSince1970] - self.cacheTime;
    return leftTime < cacheTime;
}

@end
