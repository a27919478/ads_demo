package io.flutter.plugins.firebaseadmob;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.core.content.ContextCompat;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.VideoController;
import com.google.android.gms.ads.VideoOptions;
import com.google.android.gms.ads.formats.MediaView;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.platform.PlatformView;

/**
 * Firebase 自定义原生广告控件
 *
 * @version 1.0
 * <p>
 * Created by mac_Leo on 2019-07-04.
 */
public class AdNativeView implements PlatformView, MethodCallHandler {

    private final String TAG = "AdNativeView";

    private final BinaryMessenger messenger;

    private final MethodChannel methodChannel;

    private Context context;

    private final UnifiedNativeAdView adView;

    private RelativeLayout rlContent;

    private final ImageView ivUser;

    private final TextView tvUser;

    private final MediaView mediaView;

    private final LinearLayout btRemove;

    private final TextView btRemoveStr;

    private final TextView tvTitle;

    private final TextView tvAd;

    private final TextView tvDes;

    private final Button btAction;

    private UnifiedNativeAd nativeAd;

    private String removeStr;

    private String cacheKey;

    // 缓存时间，单位s
    private int cacheTime;

    AdNativeView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {

        Log.e(TAG,"admob");

        this.context = context;
        this.messenger = messenger;

        methodChannel = new MethodChannel(messenger, "plugins.flutter.io/firebase_admob_" + id);
        methodChannel.setMethodCallHandler(this);

        String type = (String) params.get("type");
        if (type != null && type.equals("dark")) {
            adView = (UnifiedNativeAdView)
                    LayoutInflater.from(context).inflate(R.layout.layout_dark_ad, null);
        } else {
            adView = (UnifiedNativeAdView)
                    LayoutInflater.from(context).inflate(R.layout.layout_light_ad, null);
        }

        long primaryColor =  0;

        removeStr = (String) params.get("removeStr");

        List<Long> primaryGradientColor = (List<Long>)
                (params.get("primaryGradientColor") != null ? params.get("primaryGradientColor") : new ArrayList<>());

        rlContent = adView.findViewById(R.id.rl_content);
        ivUser = adView.findViewById(R.id.iv_user);
        tvUser = adView.findViewById(R.id.tv_user);
        mediaView = adView.findViewById(R.id.mediaView);
        btRemove = adView.findViewById(R.id.bt_remove);
        btRemoveStr = adView.findViewById(R.id.bt_remove_str);
        tvTitle = adView.findViewById(R.id.tv_title);
        tvDes = adView.findViewById(R.id.tv_des);
        btAction = adView.findViewById(R.id.bt_action);
        tvAd = adView.findViewById(R.id.tv_ad);

        // 设置关闭的事件
        btRemove.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                methodChannel.invokeMethod("clickRemoveAds", null);
            }
        });

        // 默认不可见
        rlContent.setVisibility(View.INVISIBLE);
        ivUser.setVisibility(View.INVISIBLE);
        tvUser.setVisibility(View.INVISIBLE);
        tvTitle.setVisibility(View.INVISIBLE);
        tvDes.setVisibility(View.INVISIBLE);
        btAction.setVisibility(View.INVISIBLE);
        tvAd.setVisibility(View.INVISIBLE);
        btRemove.setVisibility(View.INVISIBLE);

        String adUnitId = (String) params.get("adUnitId");

        cacheKey = (String) (params.get("cacheKey") == null ? "" : params.get("cacheKey"));

        cacheTime = (int) (params.get("cacheTime") == null ? 0 : params.get("cacheTime"));

        if (!TextUtils.isEmpty(adUnitId))
            loadAd(adUnitId);

        if (primaryColor != 0) {

            if (type != null && type.equals("dark")) {
                // 暗色
                GradientDrawable signDrawable =
                        (GradientDrawable) ContextCompat.getDrawable(context, R.drawable.shape_sign_bg);

                signDrawable.setStroke(1, (int) primaryColor);
                tvAd.setTextColor((int) primaryColor);
                tvAd.setBackground(signDrawable);
                GradientDrawable removeDrawable =
                        (GradientDrawable) ContextCompat.getDrawable(context, R.drawable.shape_remove_bg);
                removeDrawable.setColor((int) primaryColor);
                btRemove.setBackground(removeDrawable);
            }
        }

        if (primaryGradientColor.size() > 0) {
            GradientDrawable buttonDrawable =
                    (GradientDrawable) ContextCompat.getDrawable(context, R.drawable.shape_button_bg);
            int[] colors = new int[primaryGradientColor.size()];
            for (int i = 0; i < primaryGradientColor.size(); i++) {
                colors[i] = primaryGradientColor.get(i).intValue();
            }
            buttonDrawable.setColors(colors);
            buttonDrawable.setGradientType(GradientDrawable.LINEAR_GRADIENT);//设置线性渐变
            buttonDrawable.setOrientation(GradientDrawable.Orientation.LEFT_RIGHT);//设置渐变方向
            btAction.setBackground(buttonDrawable);
        }

    }


    private void loadAd(String adUnitId) {
        // 广告缓存管理
        final NativeAdCacheManager nativeAdCacheManager = NativeAdCacheManager.getInstance();

        AdLoader.Builder builder = new AdLoader.Builder(context, adUnitId);
        builder.forUnifiedNativeAd(new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
            @Override
            public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                if (nativeAd != null) {
                    nativeAd.destroy();
                }
                nativeAd = unifiedNativeAd;
                // 设置缓存
                if (cacheKey != null && unifiedNativeAd != null) {
                    AdmobCacheNativeAdModel cacheNativeAd =
                            new AdmobCacheNativeAdModel(System.currentTimeMillis(), unifiedNativeAd);
                    nativeAdCacheManager.getCacheNativeAdMap().put(cacheKey, cacheNativeAd);
                }
                displayNativeAd(false);
            }
        });

        // 视频配置
        VideoOptions videoOptions = new VideoOptions.Builder()
                .setStartMuted(true)    //开始静音
                .build();

        NativeAdOptions adOptions = new NativeAdOptions.Builder()
                .setVideoOptions(videoOptions)
                .build();

        // 设置配置
        builder.withNativeAdOptions(adOptions);

        // 添加失败时候的回调
        AdLoader adLoader = builder.withAdListener(new AdListener() {
            @Override
            public void onAdFailedToLoad(int errorCode) {
                methodChannel.invokeMethod("loadError", null);
                Log.e(TAG, "onAdFailedToLoad_________:" + errorCode);
            }
        }).build();

        // 先判断缓存在是否存在且过期
        if (cacheTime != 0 && !TextUtils.isEmpty(cacheKey)) {
            nativeAdCacheManager.setCacheTime(cacheTime);
            AdmobCacheNativeAdModel cacheNativeAd =
                    nativeAdCacheManager.getCacheNativeAdMap().get(cacheKey);
            long nowTime = System.currentTimeMillis();
            if (cacheNativeAd != null &&
                    (nowTime <= cacheNativeAd.getCacheTime() + cacheTime * 1000)) {
                // 存在缓存，且没有超过期限
                nativeAd = cacheNativeAd.getNativeAd();
                displayNativeAd(true);
                return;
            }
        }

        // 加载新的广告
        adLoader.loadAd(new AdRequest.Builder().build());
    }

    /**
     * 设置数据
     */
    private void displayNativeAd(boolean isCache) {
        rlContent.setVisibility(View.VISIBLE);
        // 绑定控件
        adView.setMediaView(mediaView);
        adView.setAdvertiserView(tvUser);
        adView.setIconView(ivUser);
        adView.setHeadlineView(tvTitle);
        adView.setBodyView(tvDes);
        adView.setCallToActionView(btAction);

        // 设置数据
        // 广告商ICON
        if (nativeAd.getIcon() == null) {
            adView.getIconView().setVisibility(View.GONE);
        } else {
            ((ImageView) adView.getIconView()).setImageDrawable(
                    nativeAd.getIcon().getDrawable());
            adView.getIconView().setVisibility(View.VISIBLE);
        }

        // 广告商名称
        if (nativeAd.getAdvertiser() == null) {
            adView.getAdvertiserView().setVisibility(View.INVISIBLE);
        } else {
            ((TextView) adView.getAdvertiserView()).setText(nativeAd.getAdvertiser());
            adView.getAdvertiserView().setVisibility(View.VISIBLE);
        }

        // 标题
        if (nativeAd.getHeadline() == null) {
            adView.getHeadlineView().setVisibility(View.INVISIBLE);
        } else {
            ((TextView) adView.getHeadlineView()).setText(nativeAd.getHeadline());
            adView.getHeadlineView().setVisibility(View.VISIBLE);
        }

        // 简介
        if (nativeAd.getBody() == null) {
            adView.getBodyView().setVisibility(View.INVISIBLE);
        } else {
            adView.getBodyView().setVisibility(View.VISIBLE);
            ((TextView) adView.getBodyView()).setText(nativeAd.getBody());
        }

        // 按钮
        if (nativeAd.getCallToAction() == null) {
            adView.getCallToActionView().setVisibility(View.INVISIBLE);
        } else {
            adView.getCallToActionView().setVisibility(View.VISIBLE);
            ((Button) adView.getCallToActionView()).setText(nativeAd.getCallToAction());
        }

        if (removeStr != null && !TextUtils.isEmpty(removeStr)) {
            btRemoveStr.setText(removeStr);
        }

        tvAd.setVisibility(View.VISIBLE);
        btRemove.setVisibility(View.VISIBLE);

        adView.setNativeAd(nativeAd);

        // 发送广播
        adView.postDelayed(new Runnable() {
            @Override
            public void run() {
                methodChannel.invokeMethod("loaded", null);
            }
        }, isCache ? 100 : 0);

        // 设置媒体管理器
        VideoController vc = nativeAd.getVideoController();

        if (vc.hasVideoContent()) {
            Log.e(TAG, String.format(Locale.getDefault(),
                    "Video status: Ad contains a %.2f:1 video asset.",
                    vc.getAspectRatio()));

        } else {
            Log.e(TAG, "Video status: Ad does not contain a video asset.");
        }
    }


    @Override
    public View getView() {
        return adView;
    }

    @Override
    public void dispose() {
        // 做了缓存不销毁广告资源
        /*if (nativeAd != null)
            nativeAd.destroy();*/
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.e(TAG, "onMethodCall:" + call);
    }
}
