//
//  FLTUnifiedNativeAdView.h
//  firebase_admob
//
//  Created by nanzeng liu on 2019/7/2.
//

#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickRemoveAdsBlock)(void);

@interface FLTUnifiedNativeAdView : GADUnifiedNativeAdView

/// 移出广告按钮(跳转VIP)
@property (weak, nonatomic) IBOutlet UIButton *removeAdsButton;

/// AD标签
@property (weak, nonatomic) IBOutlet UILabel *adLabel;

/// 移出广告按钮(跳转VIP)(亮色主题用)
@property (weak, nonatomic) IBOutlet UIButton *removeAdsLightButton;

@property (nonatomic, copy) ClickRemoveAdsBlock clickRemoveAdsBlock;

/// 广告灰色背景视图
@property (weak, nonatomic) IBOutlet UIView *adGrayBgView;

@end

NS_ASSUME_NONNULL_END
