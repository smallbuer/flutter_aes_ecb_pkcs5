import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    int count = 0;
    for(int i=0;i<100;i++){

      var dd = "{\"endDate\":\"2019-09-22\",\"startDate\":\"2019-09-22\",\"username\":\"helloword\"}";

      var key = await FlutterAesEcbPkcs5.generateDesKey(128);

      print(key);

      platformVersion = await FlutterAesEcbPkcs5.encryptString(dd, key);

      print(platformVersion);

      String decryptStr  = await FlutterAesEcbPkcs5.decryptString(platformVersion, key);

      print(decryptStr);

      if(decryptStr == dd){
        count ++;
      }

    }
    platformVersion = count.toString()+"\n";
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
