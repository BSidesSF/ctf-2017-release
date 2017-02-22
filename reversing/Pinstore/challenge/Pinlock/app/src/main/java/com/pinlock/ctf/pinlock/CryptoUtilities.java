package com.pinlock.ctf.pinlock;

import android.util.Log;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.security.MessageDigest;
import java.security.spec.KeySpec;
import java.util.Arrays;
import android.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;


import static java.security.MessageDigest.*;


public class CryptoUtilities {
    private SecretKeySpec key;
    private Cipher cipher;
    private String pin;
    public CryptoUtilities(String version, String pin) throws Exception{
        this.pin = pin;
        key = getKey(version);
        cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
    }

    public SecretKeySpec getKey(String version) throws Exception{
        byte[] keyBytes = null;
        MessageDigest md;
        SecretKeySpec keySpec;
        if(version.equalsIgnoreCase("v1")){
            Log.d("Version",version);
            keyBytes = ("t0ps3kr3tk3y").getBytes("UTF-8");
            md = MessageDigest.getInstance("SHA-1");
            keyBytes = md.digest(keyBytes);
            keyBytes = Arrays.copyOf(keyBytes, 16);
            keySpec = new SecretKeySpec(keyBytes, "AES");
        }
        else{
            Log.d("Version",version);
            int iterations = 1000;
            byte[] salt = "SampleSalt".getBytes();
            char[] pinArray = pin.toCharArray();
            SecretKeyFactory secretKeyFactory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
            KeySpec ks = new PBEKeySpec(pinArray, salt, iterations, 128);
            SecretKey secretKey = secretKeyFactory.generateSecret(ks);
            keySpec = new SecretKeySpec(secretKey.getEncoded(),"AES");

        }
        return keySpec;
    }

    public String encrypt (String plaintext) throws Exception{
        byte[] plaintextBytes = plaintext.getBytes();
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] ciphertext =  cipher.doFinal(plaintextBytes);
        Log.d("Status",Base64.encodeToString(ciphertext,Base64.NO_WRAP));
        return Base64.encodeToString(ciphertext,Base64.NO_WRAP);
    }

    public String decrypt (String ciphertext) throws Exception{
        byte[] ciphertextBytes = Base64.decode(ciphertext.getBytes(),Base64.NO_WRAP);
        Log.d("Status",ciphertextBytes.toString());
        cipher.init(Cipher.DECRYPT_MODE, key);
        byte[] plaintext = cipher.doFinal(ciphertextBytes);
        return new String (plaintext, "UTF-8");
    }
    public static String getHash(String input) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        String output = "";
        byte[] input_bytes = input.getBytes();
        MessageDigest md = null;
        try{
            md = MessageDigest.getInstance("SHA-1");
            }
        catch(NoSuchAlgorithmException e){
                // do nothing
            }
        md.update(input_bytes,0,input_bytes.length);
        byte[] hash_bytes = md.digest();
        output = getHex(hash_bytes);
        return output;
        }
    public static String getHex(byte[] input)
    {   String output = "";
        for(int i = 0; i < input.length; i++){
            output += String.format("%02x", input[i]);
        }
        return output;
    }

    }
