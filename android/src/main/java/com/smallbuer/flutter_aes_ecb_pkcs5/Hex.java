package com.smallbuer.flutter_aes_ecb_pkcs5;

import java.util.Locale;

public class Hex{

	/**
	 * 将字节数组进行HEX编码.
	 * @param data 待编码的字节数组
	 * @return 编码后的HEX字符串
	 */
	public static String encode(byte[] data) {

		StringBuilder sb = new StringBuilder();
		String stmp;
		for (int n = 0; n < data.length; n++){
			stmp = (Integer.toHexString(data[n] & 0xFF));
			if (stmp.length() == 1)
				sb.append("0");
			sb.append(stmp);
		}
		return sb.toString().toUpperCase(Locale.CHINA);
	}

	/**
	 * 将HEX编码的字符串转换为字节数组.
	 * @param data 待转换的HEX字符串
	 * @return 转换后的字节数组
	 */
	public static byte[] decode(String data) {

		int n = data.length();
		if (n % 2 != 0){
			data = "0" + data;
			n++;
		}
		n = (n / 2);
		byte[] bytes = new byte[n];
		for (int i = 0; i < n; i++){
			bytes[i] = (byte)Integer
					.parseInt(data.substring(i * 2, i * 2 + 2), 16);
		}
		return bytes;
	}

}
