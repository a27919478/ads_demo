//
//  FLTNativeAudienceFactory.m
//  firebase_admob
//
//  Created by nanzeng liu on 2019/6/28.
//

#import "FLTNativeAudienceFactory.h"
#import "FLTNativeAudience.h"

@interface FLTNativeAudienceFactory ()

@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *messenger;

@end

@implementation FLTNativeAudienceFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager {
    self = [super init];
    if (self) {
        self.messenger = messager;
    }
    return self;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                            viewIdentifier:(int64_t)viewId
                                                 arguments:(id _Nullable)args {
    FLTNativeAudience *nativeAudience = [[FLTNativeAudience alloc] initWithWithFrame:frame
                                                                      viewIdentifier:viewId
                                                                           arguments:args
                                                                     binaryMessenger:self.messenger];
    return nativeAudience;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
