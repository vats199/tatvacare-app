package com.mytatva.patient.ui

import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.view.LayoutInflater
import android.view.ViewGroup
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactRootView
import com.mytatva.patient.databinding.FragmentGenAIBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.utils.rnbridge.ContextHolder
import com.mytatva.patient.utils.rnbridge.ReactInstanceManagerSingleton
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


class GenAIFragment : BaseFragment<FragmentGenAIBinding>() {
    private var mReactRootView: ReactRootView? = null
    val mainComponentName: String = "TatvacareApp"
    private var mBundle: Bundle? = null

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
    ): FragmentGenAIBinding {
        return FragmentGenAIBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {

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
            ReactInstanceManagerSingleton.getInstance(requireActivity()),
            mainComponentName,
            mBundle
        )

        Handler().postDelayed({
            ContextHolder.reactContext?.let {
                sendEventToRN(
                    it,
                    "chatScreenOpened",
                    ""
                )
            }
        },1000)
        super.onActivityCreated(savedInstanceState)
    }


}