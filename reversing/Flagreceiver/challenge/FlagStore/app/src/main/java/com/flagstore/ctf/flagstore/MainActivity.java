package com.flagstore.ctf.flagstore;

import android.os.Bundle;
import android.widget.TextView;
import android.content.IntentFilter;
import android.app.Activity;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    TextView tv = new TextView(getApplicationContext());
    tv.setText("To-do: UI pending");
        IntentFilter filter = new IntentFilter();
        filter.addAction("com.flagstore.ctf.INCOMING_INTENT");
        Send_to_Activity receiver = new Send_to_Activity();
        registerReceiver(receiver, filter, "ctf.permissions._MSG", null);
    }


}
