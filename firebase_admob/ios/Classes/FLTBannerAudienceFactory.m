//
//  FLTBannerAudienceFactory.m
//  firebase_admob
//
//  Created by developer on 2019/10/18.
//

#import "FLTBannerAudienceFactory.h"
#import "FLTBannerAudience.h"

@interface FLTBannerAudienceFactory ()

@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *messenger;

@end

@implementation FLTBannerAudienceFactory

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
    FLTBannerAudience *bannerAd = [[FLTBannerAudience alloc] initWithWithFrame:frame
                                                                      viewIdentifier:viewId
                                                                           arguments:args
                                                                     binaryMessenger:self.messenger];
    return bannerAd;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
