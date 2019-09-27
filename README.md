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

    var data = "{\"username\":\"helloword\"}";
    
    //生成16字节的随机密钥
    var key = await FlutterAesEcbPkcs5.generateDesKey(128);
    
    print(key);
    //加密
    var encryptText = await FlutterAesEcbPkcs5.encryptString(data, key);
    
    print(encryptText);
    //解密
    var decryptText  = await FlutterAesEcbPkcs5.decryptString(encryptText, key);
    
    print(decryptText);
  
}
```