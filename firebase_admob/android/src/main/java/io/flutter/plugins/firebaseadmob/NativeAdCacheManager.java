package io.flutter.plugins.firebaseadmob;

import java.util.HashMap;
import java.util.Map;

/**
 * 原生广告的管理类
 *
 * @version 1.0
 * <p>
 * Created by mac_Leo on 2019-11-05.
 */
public class NativeAdCacheManager {

    // 缓存的Map类
    private Map<String, AdmobCacheNativeAdModel> cacheNativeAdMap = new HashMap<>();

    // 过期的阈值 ms
    private long cacheTime;

    // 单例
    private volatile static NativeAdCacheManager nativeAdManager;

    private NativeAdCacheManager() {
    }

    public static NativeAdCacheManager getInstance() {
        if (nativeAdManager == null) {
            synchronized (NativeAdCacheManager.class) {
                if (nativeAdManager == null) {
                    nativeAdManager = new NativeAdCacheManager();
                }
            }
        }
        return nativeAdManager;
    }


    public Map<String, AdmobCacheNativeAdModel> getCacheNativeAdMap() {
        return cacheNativeAdMap == null ?
                new HashMap<String, AdmobCacheNativeAdModel>() : cacheNativeAdMap;
    }

    public long getCacheTime() {
        return cacheTime;
    }

    public void setCacheTime(long cacheTime) {
        this.cacheTime = cacheTime;
    }


}
