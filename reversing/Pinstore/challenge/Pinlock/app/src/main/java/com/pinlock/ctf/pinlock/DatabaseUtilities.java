package com.pinlock.ctf.pinlock;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import android.widget.Toast;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


public class DatabaseUtilities extends SQLiteOpenHelper {
    private static String pathToDB = "/data/data/com.pinlock.ctf.pinlock/databases/";
    private static String dbName = "pinlock.db";
    private SQLiteDatabase db;
    private final Context appcontext;

    public DatabaseUtilities(Context context) throws IOException {

        super(context, dbName, null, 1);
        this.appcontext = context;
        this.createDB();
    }
    public String fetchSecret() throws IOException{
        this.openDB();
        String query = "SELECT entry FROM secretsDBv1";
        Cursor cursor = db.rawQuery(query, null);
        String secret = "";
        if(cursor.moveToFirst()){
            secret = cursor.getString(0);
        }
        Log.d("secret",secret);
        cursor.close();
        return secret;
    }
    public String fetchPin() throws IOException {
        this.openDB();
        String query = "SELECT pin FROM pinDB";
        Cursor cursor = db.rawQuery(query, null);
        String pin = "";
        if(cursor.moveToFirst()){
            pin = cursor.getString(0);
        }
        cursor.close();
        return pin;
    }
    public void createDB() throws IOException {
        SQLiteDatabase test = null;
        try {
            test = SQLiteDatabase.openDatabase(pathToDB + dbName, null, SQLiteDatabase.OPEN_READONLY);
        }
        catch (SQLiteException e){}
        if (test == null){
            this.getReadableDatabase();
            InputStream input = appcontext.getAssets().open(dbName);
            OutputStream output = new FileOutputStream(pathToDB + dbName);
            byte[] buffer = new byte[1024];
            int length;
            while((length = input.read(buffer))>0){
                output.write(buffer,0,length);
            }
            input.close();
            output.flush();
            output.close();
        }
    }
    public void openDB(){
        db = SQLiteDatabase.openDatabase(pathToDB + dbName, null, SQLiteDatabase.OPEN_READONLY);
    }
    @Override
    public synchronized void close(){
        if(db != null)
        {
            db.close();
        }
        super.close();
    }
    @Override
    public void onCreate(SQLiteDatabase db) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
