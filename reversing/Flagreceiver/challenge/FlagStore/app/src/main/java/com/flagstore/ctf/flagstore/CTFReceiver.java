package com.flagstore.ctf.flagstore;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Button;
import android.view.View;

public class CTFReceiver extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView tv = new TextView(this);
        tv.setText("Clever Person!");
        Button button = new Button(this);
        setContentView(button);
        button.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                Intent intent = new Intent();
                intent.setAction("com.flagstore.ctf.OUTGOING_INTENT");
                String a = getResources().getString(R.string.str3) + "";
                String b = Utilities.doBoth(getResources().getString(R.string.passphrase));
                String c = Utilities.doBoth(this.getClass().getName());
                intent.putExtra("msg", getPhrase(a,b,c));
                sendBroadcast(intent, "ctf.permission._MSG");
            }
        });
    }
    public native String getPhrase(String str1, String str2, String str3);
    public native String getFlag(String str1, String str2, String str3);
    static {
        System.loadLibrary("native-lib");
    }
}
