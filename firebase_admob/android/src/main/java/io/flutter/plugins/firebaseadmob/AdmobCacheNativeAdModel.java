package io.flutter.plugins.firebaseadmob;

import com.google.android.gms.ads.formats.UnifiedNativeAd;

/**
 * 缓存的原生广告model
 * @version 1.0
 * <p>
 * Created by mac_Leo on 2019-11-05.
 */
public class AdmobCacheNativeAdModel {

    // 缓存时间
    private long cacheTime;

    // 原生广告数据
    private UnifiedNativeAd nativeAd;

    public AdmobCacheNativeAdModel() {
    }

    public AdmobCacheNativeAdModel(long cacheTime, UnifiedNativeAd nativeAd) {
        this.cacheTime = cacheTime;
        this.nativeAd = nativeAd;
    }

    public long getCacheTime() {
        return cacheTime;
    }

    public void setCacheTime(long cacheTime) {
        this.cacheTime = cacheTime;
    }

    public UnifiedNativeAd getNativeAd() {
        return nativeAd;
    }

    public void setNativeAd(UnifiedNativeAd nativeAd) {
        this.nativeAd = nativeAd;
    }

    @Override
    public String toString() {
        return "AdmobCacheNativeAdModel{" +
                "cacheTime=" + cacheTime +
                ", nativeAd=" + nativeAd +
                '}';
    }
}
