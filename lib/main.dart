import 'dart:io';

import 'package:ads_demo/test_load_ads.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MyApp() {
    FirebaseAdMob.instance.initialize(
      appId: Platform.isIOS
          ? "ca-app-pub-3940256099942544~1458002511"
          : "ca-app-pub-3940256099942544~3347511713",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ads Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return TestLoadAds(type: 0);
                }));
              },
              child: Container(
                color: Colors.blue,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  "jump load native ads",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return TestLoadAds(type: 1);
                }));
              },
              child: Container(
                color: Colors.blue,
                padding: EdgeInsets.all(10),
                child: Text(
                  "jump load banner ads",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
