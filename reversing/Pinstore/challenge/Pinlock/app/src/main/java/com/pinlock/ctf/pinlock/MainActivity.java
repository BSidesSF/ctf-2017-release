package com.pinlock.ctf.pinlock;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;

public class MainActivity extends AppCompatActivity {
    EditText pinEditText;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Button button = (Button) findViewById(R.id.loginbutton);
        pinEditText = (EditText) findViewById(R.id.pinedittext);
        button.setOnClickListener(
                new View.OnClickListener()
                {
                    public void onClick(View view){
                        String enteredPin = pinEditText.getText().toString();
                        String pinFromDB = null;
                        String hashOfEnteredPin = null;
                        try {
                            DatabaseUtilities dbUtil = new DatabaseUtilities(getApplicationContext());
                            pinFromDB = dbUtil.fetchPin();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        try {
                            hashOfEnteredPin = CryptoUtilities.getHash(enteredPin);
                        } catch (NoSuchAlgorithmException e) {
                            e.printStackTrace();
                        } catch (UnsupportedEncodingException e) {
                            e.printStackTrace();
                        }
                        if(pinFromDB.equalsIgnoreCase(hashOfEnteredPin)){
                            Intent intent = new Intent(MainActivity.this, SecretDisplay.class);
                            intent.putExtra("pin",enteredPin);
                            startActivity(intent);
                        }
                    }
                }
        );
    }
}
