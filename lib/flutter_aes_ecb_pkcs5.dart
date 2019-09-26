import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAesEcbPkcs5 {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aes_ecb_pkcs5');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> generateDesKey(int length) async {
    try {
      final String result = await _channel.invokeMethod('generateDesKey', {"length": length});
      return result;
    } on PlatformException catch (e) {
      throw "Failed to get string encoded: '${e.message}'.";
    }
  }


  static Future<String> encryptString(String txt, String key) async {
    try {
      final String result = await _channel.invokeMethod('encrypt', {"input": txt, "key": key});
      return result;
    } on PlatformException catch (e) {
      throw "Failed to get string encoded: '${e.message}'.";
    }
  }


  static Future<String> decryptString(String txt, String key) async {
    try {
      final String result = await _channel.invokeMethod('decrypt', {"input": txt, "key": key});
      return result;
    } on PlatformException catch (e) {
      throw "Failed to get string encoded: '${e.message}'.";
    }
  }
}
