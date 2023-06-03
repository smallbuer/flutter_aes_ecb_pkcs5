package com.smallbuer.flutter_aes_ecb_pkcs5;

import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

/**
 * aes加密算法
 * AES/ECB/PKCS5Padding
 */
public class AesSecurity {

	private static final String ALGORITHM = "AES";
	private static final String TRANSFORMATION = "AES/ECB/PKCS5Padding";
	private static final String DEFUALT_ENCODING = "UTF8";


	public  String generateDesKey(int length)  {
		//实例化
		KeyGenerator kgen = null;
		try {
			kgen = KeyGenerator.getInstance("AES");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		//设置密钥长度
		kgen.init(length);
		//生成密钥
		SecretKey skey = kgen.generateKey();
		//返回密钥的二进制编码
		return Hex.encode(skey.getEncoded());
	}


	/**
	 * 加密
     * @param  input 加密的字符串
     * @param  key   解密的key ,十六进制表示
	 * @return HexString
     */
	 
	public String encrypt(String input, String key){

		byte[] decodeKey = Hex.decode(key);

		byte[] crypted = null;
		try{
			SecretKeySpec skey = new SecretKeySpec(decodeKey, ALGORITHM);
			Cipher cipher = Cipher.getInstance(TRANSFORMATION);
			cipher.init(Cipher.ENCRYPT_MODE, skey);
			crypted = cipher.doFinal(input.getBytes());
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return parseByte2HexStr(crypted);

	}

	/**
	 * 将二进制转换成16进制
     * @param buf
     * @return
     */
    private static String parseByte2HexStr(byte buf[]) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < buf.length; i++) {
            String hex = Integer.toHexString(buf[i] & 0xFF);
            if (hex.length() == 1) {
                hex = '0' + hex;
            }
            sb.append(hex.toUpperCase());
        }
        return sb.toString();
    }
	
	/**
	 * 将16进制转换为二进制
     * @param hexStr
     * @return
     */
    private static byte[] parseHexStr2Byte(String hexStr) {
		
        if (hexStr.length() < 1)
            return null;
        byte[] result = new byte[hexStr.length()/2];
        for (int i = 0;i< hexStr.length()/2; i++) {
            int high = Integer.parseInt(hexStr.substring(i*2, i*2+1), 16);
            int low = Integer.parseInt(hexStr.substring(i*2+1, i*2+2), 16);
            result[i] = (byte) (high * 16 + low);
        }
        return result;
		
    }
	
	/**
	 * 解密
     * @param  input 解密的字符串
     * @param  key   解密的key
	 * @return String
     */
	public String decrypt(String input, String key){
		byte[] decodeKey = Hex.decode(key);
		byte[] output = null;
		try{
			SecretKeySpec skey = new SecretKeySpec(decodeKey, ALGORITHM);
			Cipher cipher = Cipher.getInstance(TRANSFORMATION);
			cipher.init(Cipher.DECRYPT_MODE, skey);
			output = cipher.doFinal(parseHexStr2Byte(input));
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return new String(output);
	}
}
