package com.mytatva.patient.ui.home

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.view.KeyEvent
import android.view.View
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction
import com.facebook.react.PackageList
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactPackage
import com.facebook.react.ReactRootView
import com.facebook.react.common.LifecycleState
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler
import com.facebook.soloader.SoLoader
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.databinding.HomeActivityBinding
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.di.module.AndroidBridgeReactPackage
import com.mytatva.patient.ui.base.BaseActivity


class RNHomeActivity : BaseActivity(), DefaultHardwareBackBtnHandler {
    private lateinit var reactRootView: ReactRootView
    private lateinit var reactInstanceManager: ReactInstanceManager

    companion object {

        const val OVERLAY_PERMISSION_REQ_CODE = 1
    }

    lateinit var binding: HomeActivityBinding


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        /*if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package: $packageName")
            )
            startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE)
            return
        }*/

        initRN()
    }

    private fun initRN() {
        SoLoader.init(this, false)
        reactRootView = ReactRootView(this)
        val packages: List<ReactPackage> = PackageList(application).packages
        // Packages that cannot be autolinked yet can be added manually here, for example:
        // packages.add(MyReactNativePackage())
        // Remember to include them in `settings.gradle` and `app/build.gradle` too.
        reactInstanceManager = ReactInstanceManager.builder()
            .setApplication(application)
            .setCurrentActivity(this)
            .setBundleAssetName("index.android.bundle")
            .setJSMainModulePath("index")
            .addPackages(packages)
            .addPackage(AndroidBridgeReactPackage())
            .setUseDeveloperSupport(BuildConfig.DEBUG)
            .setInitialLifecycleState(LifecycleState.BEFORE_RESUME)
            .build()

        reactInstanceManager.createReactContextInBackground()
        // The string here (e.g. "MyReactNativeApp") has to match
        // the string in AppRegistry.registerComponent() in index.js
        openHomeFragment()
    }

    private fun openHomeFragment() {
        val fragment = RNHomeFragment()
        fragment.setReactInstanceManager(reactInstanceManager, null)
        val fragmentManager: FragmentManager = supportFragmentManager
        val fragmentTransaction: FragmentTransaction = fragmentManager.beginTransaction()
        if (fragment.isAdded) {
            fragmentTransaction.show(fragment)
        } else {
            fragmentTransaction.add(R.id.placeHolder, fragment).show(fragment)
        }
        fragmentTransaction.commit()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
            if (!Settings.canDrawOverlays(this)) {

            } else {
                initRN()
            }
        }
        reactInstanceManager.onActivityResult(this, requestCode, resultCode, data);
    }

    override fun findFragmentPlaceHolder(): Int = R.id.placeHolder

    override fun createViewBinding(): View {
        binding = HomeActivityBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun inject(activityComponent: ActivityComponent) {
        activityComponent.inject(this)
    }

    override fun invokeDefaultOnBackPressed() {
        reactInstanceManager.onBackPressed()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (reactInstanceManager != null) {
            reactInstanceManager.onHostDestroy(this)
        }
        if (reactRootView != null) {
            reactRootView.unmountReactApplication()
        }
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_MENU) {
            reactInstanceManager.showDevOptionsDialog()
            return true
        }
        return super.onKeyUp(keyCode, event)
    }


    override fun onResume() {
        super.onResume()
        if (reactInstanceManager != null && this::reactInstanceManager.isInitialized) {
            reactInstanceManager.onHostResume(this, this);
        }
    }


    override fun onPause() {
        super.onPause()
        if (reactInstanceManager != null) {
            reactInstanceManager.onHostPause(this)
        }
    }

    override fun onBackPressed() {
        reactInstanceManager.onBackPressed()
    }

}