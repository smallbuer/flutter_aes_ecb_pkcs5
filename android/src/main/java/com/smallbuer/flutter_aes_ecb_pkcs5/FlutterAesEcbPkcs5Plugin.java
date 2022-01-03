package com.smallbuer.flutter_aes_ecb_pkcs5;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterAesEcbPkcs5Plugin */
public class FlutterAesEcbPkcs5Plugin implements FlutterPlugin, MethodCallHandler  {

  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aes_ecb_pkcs5");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if (call.method.equals("generateDesKey")) {
      int length = call.argument("length");
      if (length != 0 ) {
        try {
          String encoded = new AesSecurity().generateDesKey(length);
          result.success(encoded);
        } catch (Exception e) {
          e.printStackTrace();
          result.error("UNAVAILABLE", "generateDesKey failure.", null);
        }
      }else{
        result.error("NULL INPUT STRING", "generateDesKey failure.", null);
      }

    }else if(call.method.equals("encrypt")){

      String text = call.argument("input");
      String publicKey = call.argument("key");
      if (text != null && publicKey != null) {
        try {
          String encoded = new AesSecurity().encrypt(text, publicKey);
          result.success(encoded);
        } catch (Exception e) {
          e.printStackTrace();
          result.error("UNAVAILABLE", "Encrypt failure.", null);
        }
      }else{
        result.error("NULL INPUT STRING", "Encrypt failure.", null);
      }
    }else if(call.method.equals("decrypt")){

      String text = call.argument("input");
      String publicKey = call.argument("key");
      if (text != null && publicKey != null) {
        try {
          String decoded = new AesSecurity().decrypt(text, publicKey);
          result.success(decoded);
        } catch (Exception e) {
          e.printStackTrace();
          result.error("UNAVAILABLE", "Decrypt failure.", null);
        }
      }else{
        result.error("NULL INPUT STRING", "Decrypt failure.", null);
      }
    } else {
      result.notImplemented();
    }
  }



  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
