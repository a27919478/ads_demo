//
//  FLTBannerAd.m
//  firebase_admob
//
//  Created by developer on 2019/10/18.
//

#import "FLTBannerAudience.h"
#import "FLTRequestFactory.h"

@interface FLTBannerAudience ()<GADBannerViewDelegate>

@property (nonatomic, assign) int64_t viewId;
@property (nonatomic, strong) FlutterMethodChannel *channel;

@property (nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end

@implementation FLTBannerAudience

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    if ([super init]) {
        NSDictionary *dic = args;
        NSString *adUnitId = dic[@"adUnitId"];
        self.width = [dic[@"width"] integerValue];
        self.height = [dic[@"height"] integerValue];
        if (self.width == 0 && self.height == 0) {
            self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
        } else {
            self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(self.width, self.height))];
        }
        self.bannerView.autoloadEnabled = YES;
        self.bannerView.delegate = self;
        [self loadWithAdUnitId:adUnitId];
        self.viewId = viewId;
        
        NSString *channelName = [NSString stringWithFormat:@"plugins.flutter.io/firebase_admob_%lld", self.viewId];
        self.channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
        [self.channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
            
        }];
    }
    return self;
}

- (UIView *)view {
    UIView *view = [[UIView alloc] init];
    self.bannerView.frame = CGRectMake(0, 0, self.width, self.height);
    [view addSubview:self.bannerView];
    return view;
}

- (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (void)loadWithAdUnitId:(NSString *)adUnitId {
    self.bannerView.adUnitID = adUnitId;
    self.bannerView.rootViewController = [self rootViewController];
    FLTRequestFactory *factory = [[FLTRequestFactory alloc] initWithTargetingInfo:@{}];
    [self.bannerView loadRequest:[factory createRequest]];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [_channel invokeMethod:@"loaded" arguments:nil];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    [_channel invokeMethod:@"loadError" arguments:nil];
}

@end
