//
//  FLTUnifiedNativeAdView.m
//  firebase_admob
//
//  Created by nanzeng liu on 2019/7/2.
//

#import "FLTUnifiedNativeAdView.h"

@implementation FLTUnifiedNativeAdView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.callToActionView.layer.cornerRadius = 22;
    self.callToActionView.layer.masksToBounds = YES;
    
    self.removeAdsButton.layer.cornerRadius = 2;
    self.removeAdsButton.layer.masksToBounds = YES;
    
    self.adLabel.layer.borderWidth = 1;
    self.adLabel.layer.borderColor = [UIColor colorWithRed:125.0/255.0
                                                             green:104.0/255.0
                                                              blue:255.0/255.0
                                                             alpha:1.0].CGColor;
    self.adLabel.layer.cornerRadius = 2;
    self.adLabel.layer.masksToBounds = YES;
    
    [self.removeAdsButton addTarget:self
                             action:@selector(clickRemoveAds)
                   forControlEvents:UIControlEventTouchUpInside];
    
    self.iconView.layer.cornerRadius = 8;
    self.iconView.layer.masksToBounds = YES;
    
    self.removeAdsLightButton.layer.cornerRadius = 16;
    self.removeAdsLightButton.layer.masksToBounds = YES;
    [self.removeAdsLightButton addTarget:self
                                  action:@selector(clickRemoveAds)
                        forControlEvents:UIControlEventTouchUpInside];
    
    self.adGrayBgView.layer.cornerRadius = 16;
    self.adGrayBgView.layer.masksToBounds = YES;
}

- (void)clickRemoveAds {
    if (self.clickRemoveAdsBlock) {
        self.clickRemoveAdsBlock();
    }
}

@end
