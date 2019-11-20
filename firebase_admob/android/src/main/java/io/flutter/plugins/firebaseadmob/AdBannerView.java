package io.flutter.plugins.firebaseadmob;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.platform.PlatformView;

/**
 * Firebase banner广告控件(可调整位置)
 *
 * @version 1.0
 * <p>
 * Created by mac_Leo on 2019-10-17.
 */
public class AdBannerView extends AdListener implements PlatformView, MethodCallHandler {

    private final String TAG = "AdBannerView";

    private final BinaryMessenger messenger;

    private final MethodChannel methodChannel;

    private Context context;

    private AdView adView;

    private AdSize adSize;

    AdBannerView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
        this.context = context;
        this.messenger = messenger;
        methodChannel = new MethodChannel(messenger, "plugins.flutter.io/firebase_admob_" + id);
        methodChannel.setMethodCallHandler(this);

        adView = new AdView(context);

        String adUnitId = (String) params.get("adUnitId");

        double width = (double) params.get("width");
        double height = (double) params.get("height");

        Log.e(TAG, "width:" + width + ", height:" + height);

        if (width == 0 || height == 0) {
            adView.setAdSize(AdSize.LARGE_BANNER);
        } else {
            adView.setAdSize(new AdSize((int) width, (int) height));
        }

        adView.setBackgroundColor(Color.WHITE);

        Map<String, Object> targetingInfo = (Map<String, Object>) params.get("targetingInfo");

        if (!TextUtils.isEmpty(adUnitId)) {
            loadAd(adUnitId, targetingInfo);
        }


    }

    private void loadAd(String adUnitId, Map<String, Object> targetingInfo) {
        adView.setAdUnitId(adUnitId);
        adView.setAdListener(new AdListener() {

            public void onAdFailedToLoad(int errorCode) {
                methodChannel.invokeMethod("loadError", null);
                Log.e(TAG, "onAdFailedToLoad_________:" + errorCode);
            }

            public void onAdLoaded() {
                methodChannel.invokeMethod("loaded", null);
                Log.e(TAG, "onAdLoaded_________");
            }
        });

        // targetingInfo为广告数据，如果为空 factory = new AdRequest.Builder()
        AdRequestBuilderFactory factory = new AdRequestBuilderFactory(targetingInfo);
        adView.loadAd(factory.createAdRequestBuilder().build());
    }


    @Override
    public View getView() {
        return adView;
    }

    @Override
    public void dispose() {
        if (adView != null)
            adView.destroy();
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.e(TAG, "onMethodCall:" + call);
    }
}
