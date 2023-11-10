package com.mytatva.patient.ui

import android.content.Context
import android.os.Bundle
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.facebook.react.PackageList
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactPackage
import com.facebook.react.ReactRootView
import com.facebook.react.common.LifecycleState
import com.facebook.soloader.SoLoader
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.databinding.ActivityGenAiactivityBinding
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.di.module.AndroidBridgeReactPackage
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.rnbridge.ContextHolder
import com.mytatva.patient.utils.rnbridge.ReactInstanceManagerSingleton
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class GenAIActivity : BaseActivity() {
    private lateinit var reactRootView: ReactRootView
    private lateinit var reactInstanceManager: ReactInstanceManager
    lateinit var binding: ActivityGenAiactivityBinding
    val mainComponentName: String = "TatvacareApp"
    private var mBundle: Bundle? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GlobalScope.launch(Dispatchers.Main) {
            SoLoader.init(this@GenAIActivity, false)
            reactRootView = ReactRootView(this@GenAIActivity)
            reactInstanceManager = ReactInstanceManagerSingleton.getInstance(this@GenAIActivity)
            reactRootView.startReactApplication(reactInstanceManager, mainComponentName, mBundle)
            setContentView(reactRootView)

            delay(1000)

            ContextHolder.reactContext?.let {
                sendEventToRN(
                    it,
                    "chatScreenOpened",
                    ""
                )
            }
        }
    }

    override fun findFragmentPlaceHolder(): Int = R.id.placeHolder

    override fun createViewBinding(): View {
        binding = ActivityGenAiactivityBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun inject(activityComponent: ActivityComponent) {
        activityComponent.inject(this)
    }

}