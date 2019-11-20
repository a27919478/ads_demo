//
//  FLTNativeAudience.m
//  firebase_admob
//
//  Created by nanzeng liu on 2019/6/28.
//

#import "FLTNativeAudience.h"
#import "FLTUnifiedNativeAdView.h"
#import "FLTNativeAudienceManager.h"

@interface FLTNativeAudience ()<GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate>

@property (nonatomic, assign) int64_t viewId;
@property (nonatomic, strong) FlutterMethodChannel *channel;

/// 广告加载器
@property(nonatomic, strong) GADAdLoader *adLoader;
/// 原生广告视图
@property(nonatomic, strong) FLTUnifiedNativeAdView *nativeAdView;
/// 类型 dark light
@property (nonatomic, copy) NSString *type;
/// 移除广告文案
@property (nonatomic, copy) NSString *removeAdsText;
/// 引导点击按钮颜色数组(十进制数字)
@property (nonatomic, strong) NSArray *primaryGradientColor;
/// 引导点击按钮颜色数组(十进制数字)
@property (nonatomic, strong) NSNumber *primaryColor;
/// 缓存键
@property (nonatomic, copy) NSString *cacheKey;
/// 缓存时间
@property (nonatomic, assign) NSInteger cacheTime;

@end

@implementation FLTNativeAudience

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    if ([super init]) {
        NSDictionary *dic = args;
        NSString *adUnitId = dic[@"adUnitId"];
        self.type = dic[@"type"];
        self.removeAdsText = dic[@"removeStr"];
        self.cacheKey = dic[@"cacheKey"];
        self.cacheTime = [dic[@"cacheTime"] integerValue];
        [self loadWithAdUnitId:adUnitId];
        self.viewId = viewId;
        
        NSString *channelName = [NSString stringWithFormat:@"plugins.flutter.io/firebase_admob_%lld", self.viewId];
        self.channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        self.primaryGradientColor = dic[@"primaryGradientColor"];
        self.primaryColor = dic[@"primaryColor"];

//        __weak __typeof__(self) weakSelf = self;
        [self.channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
            
        }];
    }
    return self;
}

- (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

- (nonnull UIView *)view {
    [self.nativeAdView removeFromSuperview];
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[FLTUnifiedNativeAdView class]] pathForResource:@"firebase_admob" ofType:@"bundle"]];
    if ([self.type isEqualToString:@"dark"]) {
        self.nativeAdView = [bundle loadNibNamed:@"FLTUnifiedNativeAdView" owner:nil options:nil].firstObject;
    } else {
        self.nativeAdView = [bundle loadNibNamed:@"FLTUnifiedNativeAdView" owner:nil options:nil].lastObject;
        self.nativeAdView.adLabel.layer.borderWidth = 0;
    }
    if ([FLTNativeAudienceManager.sharedManager.nativeAdDictionary[self.cacheKey] isUseCache:self.cacheTime]) {
        [self showNaviveAd:FLTNativeAudienceManager.sharedManager.nativeAdDictionary[self.cacheKey].nativeAd];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.channel invokeMethod:@"loaded" arguments:nil];
        });
    }
    return self.nativeAdView;
}

- (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (void)loadWithAdUnitId:(NSString *)adUnitId {
    if ([FLTNativeAudienceManager.sharedManager.nativeAdDictionary[self.cacheKey] isUseCache:self.cacheTime]) {
        return;
    }
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = YES;
    GADNativeAdMediaAdLoaderOptions *nativeAdMediaAdLoaderOptions = [[GADNativeAdMediaAdLoaderOptions alloc] init];
    nativeAdMediaAdLoaderOptions.mediaAspectRatio = GADMediaAspectRatioLandscape;
    GADMultipleAdsAdLoaderOptions *multipleAdsOptions = [[GADMultipleAdsAdLoaderOptions alloc] init];
    multipleAdsOptions.numberOfAds = 1;
    GADRequest *request = [GADRequest request];
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:adUnitId
                                       rootViewController:[self rootViewController]
                                                  adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                                                  options:@[ videoOptions,
                                                             nativeAdMediaAdLoaderOptions,
                                                              ]];
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:request];
}

- (void)clickRemoveAds {
    [self.channel invokeMethod:@"clickRemoveAds" arguments:nil];
}

#pragma mark GADAdLoaderDelegate implementation
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
    [self.channel invokeMethod:@"loaded" arguments:nil];
    FLTNativeAudienceCache *cacheAd = [[FLTNativeAudienceCache alloc] init];
    cacheAd.cacheTime = [[NSDate date] timeIntervalSince1970];
    cacheAd.nativeAd = nativeAd;
    FLTNativeAudienceManager.sharedManager.nativeAdDictionary[self.cacheKey] = cacheAd;
    [self showNaviveAd:nativeAd];
}

- (void)showNaviveAd:(GADUnifiedNativeAd *)nativeAd {
    FLTUnifiedNativeAdView *nativeAdView = self.nativeAdView;
    
    nativeAdView.adLabel.hidden = NO;
    nativeAdView.removeAdsButton.hidden = NO;
    if (![self.removeAdsText isKindOfClass:[NSNull class]]
        && ((NSString *)self.removeAdsText).length) {
        [nativeAdView.removeAdsButton setTitle:[NSString stringWithFormat:@"  %@  ",self.removeAdsText]
                                      forState:UIControlStateNormal];
        [nativeAdView.removeAdsLightButton setTitle:[NSString stringWithFormat:@"  %@  ",self.removeAdsText]
        forState:UIControlStateNormal];
    }
    nativeAdView.removeAdsLightButton.hidden = NO;
    nativeAdView.adGrayBgView.hidden = NO;
    __weak __typeof__(self) weakSelf = self;
    nativeAdView.clickRemoveAdsBlock = ^{
        [weakSelf clickRemoveAds];
    };
    
    nativeAdView.nativeAd = nativeAd;
    // Set ourselves as the ad delegate to be notified of native ad events.
    nativeAd.delegate = self;
    
    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
    nativeAdView.headlineView.hidden = nativeAd.headline ? NO : YES;
    nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;
    
    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
    nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;
    
    [((UIButton *)nativeAdView.callToActionView) setTitle:nativeAd.callToAction
                                                 forState:UIControlStateNormal];
    nativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;
    
    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;
    
    ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
    nativeAdView.storeView.hidden = nativeAd.store ? NO : YES;
    
    ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
    nativeAdView.priceView.hidden = nativeAd.price ? NO : YES;
    
    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
    nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;
    
    if (![self.primaryColor isKindOfClass:[NSNull class]]
        && [((NSNumber *)self.primaryColor) integerValue] > 0
        && [self.type isEqualToString:@"dark"]) {
        // 设置广告标签颜色
        nativeAdView.adLabel.layer.borderColor = [self colorWithHex:self.primaryColor.integerValue alpha:1].CGColor;
        nativeAdView.adLabel.textColor = [self colorWithHex:self.primaryColor.integerValue alpha:1];
        
        // 设置移除广告颜色按钮颜色
        nativeAdView.removeAdsButton.backgroundColor = [self colorWithHex:self.primaryColor.integerValue alpha:1];
    }
    
    // 设置按钮颜色渐变
    if (![self.primaryGradientColor isKindOfClass:[NSNull class]] && ((NSArray *)self.primaryGradientColor).count > 0) {
        CAGradientLayer *primaryGradientLayer = [CAGradientLayer layer];
        primaryGradientLayer.frame = ((UIButton *)nativeAdView.callToActionView).bounds;
        primaryGradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
        primaryGradientLayer.endPoint = CGPointMake(1.0f, 0.0f);
        NSMutableArray *colors = [NSMutableArray array];
        for (NSInteger i = 0; i < self.primaryGradientColor.count; i++) {
            NSNumber *colorNumber = self.primaryGradientColor[i];
            [colors addObject:(__bridge id)[self colorWithHex:colorNumber.integerValue alpha:1].CGColor];
        }
        primaryGradientLayer.colors = colors;
        primaryGradientLayer.type = kCAGradientLayerAxial;
        [((UIButton *)nativeAdView.callToActionView).layer insertSublayer:primaryGradientLayer atIndex:0];
    }
    
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    nativeAdView.callToActionView.userInteractionEnabled = NO;
    nativeAdView.removeAdsLightButton.userInteractionEnabled = YES;
    nativeAdView.removeAdsButton.userInteractionEnabled = YES;
}

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader {
    
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ failed with error: %@", adLoader, error);
    [self.channel invokeMethod:@"loadError" arguments:nil];
}

#pragma mark GADUnifiedNativeAdDelegate
- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
