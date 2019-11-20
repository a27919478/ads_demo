//
//  FLTBannerAudienceFactory.h
//  firebase_admob
//
//  Created by developer on 2019/10/18.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLTBannerAudienceFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager;

@end

NS_ASSUME_NONNULL_END
