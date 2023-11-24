package com.tatvacareapp.rnbridge;

import android.content.Context;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class AndroidBridgeModule extends ReactContextBaseJavaModule {
    Context mContext;

    public AndroidBridgeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
    }

    @Override
    public String getName() {
        return "AndroidBridge";
    }

    @ReactMethod
    public void openTestScreen() {

    }
}
