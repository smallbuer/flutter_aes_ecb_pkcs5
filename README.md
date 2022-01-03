## AES 128 pkcs5 only support
* Provide generation of AES keys
* Provide encrypt for AES keys  
* Provide decrypt for AES keys  

* Android uses java, iOS uses OC development


## Usage

Use this package as a library
1. Depend on it
Add this to your package's pubspec.yaml file:

```
dependencies:
  flutter_aes_ecb_pkcs5: ^0.1.2
```

2. Install it You can install packages from the command line:

with Flutter:

```
$ flutter pub get
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

3. Import it Now in your Dart code, you can use:

```
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
```



#### AES Use Example



```dart
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';

void main() {

    var data = "{\"username\":\"helloword\"}";
    
    //generate a 16-byte random key
    var key = await FlutterAesEcbPkcs5.generateDesKey(128);
    
    print(key);
    //encrypt
    var encryptText = await FlutterAesEcbPkcs5.encryptString(data, key);
    
    print(encryptText);
    //decrypt
    var decryptText  = await FlutterAesEcbPkcs5.decryptString(encryptText, key);
    
    print(decryptText);
  
}
```

#### Run Example Result
```
data:{"username":"helloword"}
create key:DA8FD2693B652D587EEE51E7ADD9DBB8
encryptText :851544E224F6C1C7F560AB82889DE0DF66EEB6762AB836F4EE13E31100F0EA16
decryptText :{"username":"helloword"}
```

#### License

The MIT License(http://opensource.org/licenses/MIT)

Please feel free to use and contribute to the development.


