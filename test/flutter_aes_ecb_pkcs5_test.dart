import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  const MethodChannel channel = MethodChannel('flutter_aes_ecb_pkcs5');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
          (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });


}
