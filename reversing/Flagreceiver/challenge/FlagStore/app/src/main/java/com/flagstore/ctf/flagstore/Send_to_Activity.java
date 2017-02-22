package com.flagstore.ctf.flagstore;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

public class Send_to_Activity extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        String msgText = intent.getStringExtra("msg");
        Intent outIntent = null;
        if(msgText.equalsIgnoreCase("OpenSesame")){
            outIntent = new Intent(context, CTFReceiver.class);
            context.startActivity(outIntent);
        }
        else{
            String output = "Ah, ah, ah, you didn't say the magic word!";
            Toast.makeText(context, output, Toast.LENGTH_LONG).show();
        }
    }
}
