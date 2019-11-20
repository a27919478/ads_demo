import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestLoadAds extends StatefulWidget {
  // 0-native 1-banner
  final int type;

  TestLoadAds({this.type = 0});

  @override
  State<StatefulWidget> createState() => StateTestLoadAds();
}

class StateTestLoadAds extends State<TestLoadAds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 0 ? "native" : "banner"),
      ),
      body: Center(
        child: widget.type == 0 ? loadNativeAdMob() : loadBannerAdMob(),
      ),
      // refresh
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  /// 加载谷歌banner广告
  Widget loadBannerAdMob() {
    return AdMobNativeAudience(
        // 谷歌
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        nativeAdType: GoogleNativeAdType.BANNER_AD,
        bannerAdSize:
            GoogleBannerAdSize(MediaQuery.of(context).size.width, 100),
        callback: (result) {
          if (!mounted) {
            return;
          }
        });
  }

  /// 加载谷歌原生广告
  Widget loadNativeAdMob() {
    return AdMobNativeAudience(
        // 谷歌
        adUnitId: "ca-app-pub-3940256099942544/1044960115",
        nativeAdType: GoogleNativeAdType.NATIVE_AD,
        type: "dark",
        callback: (result) {
          if (!mounted) {
            return;
          }
        });
  }
}
