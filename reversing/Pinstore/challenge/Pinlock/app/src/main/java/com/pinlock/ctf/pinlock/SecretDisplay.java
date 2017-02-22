package com.pinlock.ctf.pinlock;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;

public class SecretDisplay extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_secret_display);
        Context context = getApplicationContext();
        TextView tv = (TextView) findViewById(R.id.secretTextView);

        String pin = getIntent().getStringExtra("pin");
        try {
            DatabaseUtilities dbUtils = new DatabaseUtilities(getApplicationContext());
            CryptoUtilities cryptoUtils = new CryptoUtilities("v1", pin);
            tv.setText(cryptoUtils.decrypt(dbUtils.fetchSecret()));
            /* Version 2 support pending */

        }
        catch(Exception e){
            Log.e("Pinlock","exception",e);
        }

        Toast toast = Toast.makeText(context,pin,Toast.LENGTH_LONG);
    }
}
