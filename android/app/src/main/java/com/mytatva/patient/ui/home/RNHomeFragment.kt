package com.mytatva.patient.ui.home

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.ViewGroup
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactRootView
import com.mytatva.patient.databinding.FragmentReactBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.fcm.Notification
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.utils.rnbridge.ContextHolder
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch


class RNHomeFragment : BaseFragment<FragmentReactBinding>() {
    private var mReactRootView: ReactRootView? = null
    private var mBundle: Bundle? = null
    val mainComponentName: String = "TatvacareApp"
    var notification: Notification? = null
    lateinit var mReactInstanceManager: ReactInstanceManager
    override fun onAttach(context: Context) {
        super.onAttach(context)
        mReactRootView = ReactRootView(context)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean
    ): FragmentReactBinding {
        return FragmentReactBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        GlobalScope.launch(Dispatchers.Main) {
            delay(250)
            ContextHolder.reactContext?.let {
                sendEventToRN(
                    it,
                    "UserToken",
                    session.user?.token.toString()
                )
            }
        }
    }

    fun setReactInstanceManager(reactInstanceManager: ReactInstanceManager?, bundle: Bundle?) {
        if (reactInstanceManager != null) {
            mReactInstanceManager = reactInstanceManager
        }
        mBundle = bundle
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): ReactRootView? {
        super.onCreate(savedInstanceState)
        return mReactRootView
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        mReactRootView!!.startReactApplication(
            mReactInstanceManager,
            mainComponentName,
            mBundle
        )
        super.onActivityCreated(savedInstanceState)
    }

}