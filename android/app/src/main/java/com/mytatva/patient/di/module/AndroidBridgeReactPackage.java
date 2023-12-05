package com.mytatva.patient.di.module;

import androidx.annotation.NonNull;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.mytatva.patient.utils.rnbridge.AndroidBridgeModule;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class AndroidBridgeReactPackage implements ReactPackage {


    @Override
    public List<NativeModule> createNativeModules(@NonNull ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new AndroidBridgeModule(reactContext));
        return modules;
    }

    @Override
    public List<ViewManager> createViewManagers(@NonNull ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
}