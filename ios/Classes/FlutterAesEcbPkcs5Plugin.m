#import "FlutterAesEcbPkcs5Plugin.h"
#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>


@implementation FlutterAesEcbPkcs5Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aes_ecb_pkcs5"
            binaryMessenger:[registrar messenger]];
  FlutterAesEcbPkcs5Plugin* instance = [[FlutterAesEcbPkcs5Plugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

      NSDictionary *argsMap  = call.arguments;

    if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"generateDesKey" isEqualToString:call.method]) {

        id length = [argsMap objectForKey:@"length"];
        NSLog(@"obj = %@", length);

        NSString *key = [FlutterAesEcbPkcs5Plugin randomlyGeneratedBitString:length];
        //NSLog(@"AES加密的秘钥key=%@",key);

        NSString *hexKey = [FlutterAesEcbPkcs5Plugin hexStringFromString:key];

        //NSLog(@"AES加密的秘钥hexKey=%@",hexKey);

        result(hexKey.uppercaseString);

    }else if ([@"encrypt" isEqualToString:call.method]) {

        id input = [argsMap objectForKey:@"input"];
        //NSLog(@"obj = %@", input);
        id key = [argsMap objectForKey:@"key"];
        //NSLog(@"obj = %@", key);

        NSString *encode = [FlutterAesEcbPkcs5Plugin encyptPKCS5:input WithKey:key];

        //NSLog(@"结果=%@",encode.uppercaseString);
        result(encode.uppercaseString);
    } else if ([@"decrypt" isEqualToString:call.method]) {

        id input = [argsMap objectForKey:@"input"];
        //NSLog(@"obj = %@", input);
        id key = [argsMap objectForKey:@"key"];
        //NSLog(@"obj = %@", key);

        NSString *encode = [FlutterAesEcbPkcs5Plugin decrypPKCS5:input WithKey:key];

        //NSLog(@"结果=%@",encode);
        result(encode);

    } else {
      result(FlutterMethodNotImplemented);
    }

}


+ (NSString *)randomlyGeneratedBitString:(id)length
{
    NSString *string = [[NSString alloc]init];

    NSLog(@"len->%@",length);
    int len = [length intValue] / 8 ;
    NSLog(@"len->%d",len);

    for (int i = 0; i < len; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return  string;
}


//字符串加密(16进制)
+ (NSString *)encyptPKCS5:(NSString *)plainText WithKey:(NSString *)key{

    //把string 转NSData
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];

    //length
    size_t plainTextBufferSize = [data length];

    const void *vplainText = (const void *)[data bytes];


    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    //解密hex加密的密钥
    char *publicKey = [FlutterAesEcbPkcs5Plugin convertHexStrToChar:key];

    NSLog(@"vkey->len->%d",strlen(publicKey));

    //配置CCCrypt
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithmAES128, //3DES
                                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                                       publicKey,    //key
                                       kCCKeySizeAES128,
                                       nil,     //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);

    if (ccStatus == kCCSuccess) {
        NSData *myData = [NSData dataWithBytes:(const char *)bufferPtr length:(NSUInteger)movedBytes];

        //16进制(你也可以换成base64等)
        NSUInteger          len = [myData length];
        char *              chars = (char *)[myData bytes];
        NSMutableString *   hexString = [[NSMutableString alloc] init];

        for(NSUInteger i = 0; i < len; i++ )
            [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
        return hexString;
    }

    free(bufferPtr);
    return nil;

}


//解密
+(NSString *)decrypPKCS5:(NSString *)encryptText WithKey:(NSString *)key
{

    //解密hex加密的密钥
    char *publicKey = [FlutterAesEcbPkcs5Plugin convertHexStrToChar:key];

//    NSLog(@"publicKey->publicKey->%s",publicKey);
//    NSLog(@"vkey->len->%d",strlen(publicKey));

    char *data1 = [FlutterAesEcbPkcs5Plugin convertHexStrToChar:encryptText];

    int plainTextBufferSize = [encryptText length] / 2 ;

    //NSLog(@"data1->plainTextBufferSize->%d",plainTextBufferSize);

    NSData *content=[NSData dataWithBytes:data1 length:plainTextBufferSize];

    //NSLog(@"data1->content->%@",content);

    NSUInteger dataLength = [content length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          publicKey,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [content bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);

    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];

        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

+ (char *)convertHexStrToChar:(NSString *)hexString {

    int mallocLen = [hexString length] / 2 + 1;

    char *myBuffer = (unsigned char *)malloc(mallocLen);

    memset(myBuffer,'\0',mallocLen);

    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    return myBuffer;
}


+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


@end
