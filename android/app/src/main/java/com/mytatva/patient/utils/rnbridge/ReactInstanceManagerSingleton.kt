package com.mytatva.patient.utils.rnbridge

import android.app.Activity
import com.facebook.react.PackageList
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactPackage
import com.facebook.react.common.LifecycleState
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.di.module.AndroidBridgeReactPackage

object ReactInstanceManagerSingleton {
    private var instance: ReactInstanceManager? = null

    fun getInstance(mContext: Activity): ReactInstanceManager {
        instance = createReactInstanceManager(mContext)

        return instance!!
    }

    private fun createReactInstanceManager(mContext: Activity): ReactInstanceManager {
        val packages: List<ReactPackage> = PackageList(mContext.application).packages

        val builder = ReactInstanceManager.builder()
            .setApplication(mContext.application)
            .setCurrentActivity(mContext)
            .setBundleAssetName("index.android.bundle")
            .setJSMainModulePath("index")
            .addPackages(packages)
            .addPackage(AndroidBridgeReactPackage())
            .setUseDeveloperSupport(BuildConfig.DEBUG)
            .setInitialLifecycleState(LifecycleState.RESUMED)
        return builder.build()
    }
}

