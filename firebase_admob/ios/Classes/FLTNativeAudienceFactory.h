//
//  FLTNativeAudienceFactory.h
//  firebase_admob
//
//  Created by nanzeng liu on 2019/6/28.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLTNativeAudienceFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager;

@end

NS_ASSUME_NONNULL_END
