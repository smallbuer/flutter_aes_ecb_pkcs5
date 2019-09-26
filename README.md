## AES 128 pkcs5 only support
* Provide generation of AES keys
* Provide encrypt for AES keys  
* Provide decrypt for AES keys  

* Android uses java, iOS uses OC development


## Usage


#### AES

```dart
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';

void main() {

      var dd = "{\"endDate\":\"2019-09-22\",\"startDate\":\"2019-09-22\",\"username\":\"helloword\"}";

      var key = await FlutterAesEcbPkcs5.generateDesKey(128);

      print(key);

      platformVersion = await FlutterAesEcbPkcs5.encryptString(dd, key);

      print(platformVersion);

      String decryptStr  = await FlutterAesEcbPkcs5.decryptString(platformVersion, key);

      print(decryptStr);
  
  
}
```