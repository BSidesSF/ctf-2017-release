package com.flagstore.ctf.flagstore;


import android.util.Base64;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

public class Utilities {
    public static String doBoth(String input){
        return translate(customEncodeValue(input));
    }
    public static String translate(String input){
        input = input.replace('=','?');
        char inputchars[] = input.toCharArray();
        Map<Integer,Character> table = new HashMap<>();
        int numbers[] = {1,2,3,4,5,6,7,8,9,0};
        char characters[] = {'W','h','a','t','i','s','d','o','n','e'};
        for(int i = 0; i < 10; i++){
            table.put(numbers[i],characters[i]);
        }
        for(int i = 0; i < inputchars.length; i++){
            int charcode = (int)inputchars[i];
            if(charcode > 47 && charcode < 58) {
                charcode -= 48;
                inputchars[i] = table.get(charcode);
            }
        }
        return new String(inputchars);
    }
    public static String customEncodeValue(String input){
        String output = "";
        byte[] input_bytes = input.getBytes();
        MessageDigest md = null;
        try{
                md = MessageDigest.getInstance("SHA-224");
        }
        catch(NoSuchAlgorithmException e){

        }
        md.update(input_bytes,0,input_bytes.length);
        byte[] hash_bytes = md.digest();
        for(int i = 0; i < hash_bytes.length; i++){
            output += String.format("%02x", hash_bytes[i]);
        }
        return Base64.encodeToString(output.getBytes(), Base64.DEFAULT);
    }
}
