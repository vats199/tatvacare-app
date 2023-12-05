package com.mytatva.patient.ui.home

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.ViewGroup
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactRootView
import com.mytatva.patient.databinding.FragmentReactBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment


class RNHomeFragment : BaseFragment<FragmentReactBinding>() {
    private var mReactRootView: ReactRootView? = null
    private var mBundle: Bundle? = null
    val mainComponentName: String = "TatvacareApp"
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