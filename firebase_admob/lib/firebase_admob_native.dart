import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

typedef Callback = void Function(GoogleNativeAdResult result);

const String NativeAd = "nativeAudience";
const String BannerAd = "bannerAudience";

enum GoogleNativeAdType {
  NATIVE_AD,
  BANNER_AD,
}

enum GoogleNativeAdResult {
  /// Native Ad error.
  ERROR,

  /// Native Ad loaded successfully.
  LOADED,

  /// 点击关闭按钮
  CLICK_CLOST,
}

/// 定制原生广告
class AdMobNativeAudience extends StatefulWidget {
  const AdMobNativeAudience({
    Key key,
    this.nativeAdType = GoogleNativeAdType.NATIVE_AD,
    this.bannerAdSize,
    this.adUnitId,
    this.type,
    this.primaryGradientColor,
    this.primaryColor = 0,
    this.callback,
    this.cacheKey = "",
    this.cacheTime = 0,
  }) : super(key: key);

  /// 广告位ID
  final String adUnitId;

  /// 类型 dark light
  final String type;

  /// 默认主色
  final int primaryColor;

  /// 默认渐变色
  final List<int> primaryGradientColor;

  /// 点击移出广告回调
  final Callback callback;

  /// 广告类型
  final GoogleNativeAdType nativeAdType;

  /// banner宽高
  final GoogleBannerAdSize bannerAdSize;

  /// 缓存键
  final String cacheKey;

  /// 缓存时间 为0是关闭缓存功能，默认是0
  final int cacheTime;

  @override
  State<StatefulWidget> createState() => _AdMobNativeAudienceState();
}

class _AdMobNativeAudienceState extends State<AdMobNativeAudience> {
  MethodChannel _channel;

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    var width =
        widget.bannerAdSize?.width == null ? 0 : widget.bannerAdSize?.width;
    var height =
        widget.bannerAdSize?.height == null ? 0 : widget.bannerAdSize?.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        defaultTargetPlatform == TargetPlatform.iOS
            ? UiKitView(
                viewType: GoogleNativeAdType.NATIVE_AD == widget.nativeAdType
                    ? NativeAd
                    : BannerAd,
                creationParams: <String, dynamic>{
                  "adUnitId": widget.adUnitId,
                  "type": widget.type,
                  "primaryColor": widget.primaryColor,
                  "primaryGradientColor": widget.primaryGradientColor == null
                      ? []
                      : widget.primaryGradientColor,
                  "width": width,
                  "height": height,
                  "cacheKey": widget.cacheKey,
                  "cacheTime": widget.cacheTime,
                },
                creationParamsCodec: StandardMessageCodec(),
                onPlatformViewCreated: _onPlatformViewCreated,
              )
            : defaultTargetPlatform == TargetPlatform.android
                ? AndroidView(
                    viewType:
                        GoogleNativeAdType.NATIVE_AD == widget.nativeAdType
                            ? NativeAd
                            : BannerAd,
                    creationParams: <String, dynamic>{
                      "adUnitId": widget.adUnitId,
                      "type": widget.type,
                      "primaryColor": widget.primaryColor,
                      "primaryGradientColor":
                          widget.primaryGradientColor == null
                              ? []
                              : widget.primaryGradientColor,
                      "width": width,
                      "height": height,
                      "cacheKey": widget.cacheKey,
                      "cacheTime": widget.cacheTime,
                    },
                    creationParamsCodec: StandardMessageCodec(),
                    onPlatformViewCreated: _onPlatformViewCreated,
                  )
                : Text('firebase_admob插件尚不支持$defaultTargetPlatform'),
      ],
    );
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('plugins.flutter.io/firebase_admob_$id');
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "clickRemoveAds":
        widget.callback(GoogleNativeAdResult.CLICK_CLOST);
        return null;
      case "loaded":
        widget.callback(GoogleNativeAdResult.LOADED);
        setState(() {
          isLoaded = true;
        });
        return null;
      case "loadError":
        widget.callback(GoogleNativeAdResult.ERROR);
        // setState(() {
        //   isLoaded = true;
        // });
        return null;
      default:
        throw UnsupportedError("Unrecognized method");
    }
  }
}

class GoogleBannerAdSize {
  double width;

  double height;

  GoogleBannerAdSize(this.width, this.height);
}
