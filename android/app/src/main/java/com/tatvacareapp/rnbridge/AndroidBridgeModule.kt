package com.tatvacareapp.rnbridge

import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod


class AndroidBridgeModule(var reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(
    reactContext
) {

    init {
        ContextHolder.reactContext = reactContext
    }

    override fun getName(): String {
        return "AndroidBridge"
    }

    @ReactMethod
    fun openTestScreen() {
        Log.d("AndroidBridge===", "AndroidBridge Worked!")
    }

}