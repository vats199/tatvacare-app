package com.mytatva.patient.ui.home.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.core.Common
import com.mytatva.patient.databinding.HomeFragmentAppUnderMaintenenceBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment


class AppUnderMaintenenceFragment : BaseFragment<HomeFragmentAppUnderMaintenenceBinding>() {

    private val title by lazy {
        arguments?.getString(Common.BundleKey.TITLE) ?: ""
    }

    private val description by lazy {
        arguments?.getString(Common.BundleKey.DESCRIPTION) ?: ""
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): HomeFragmentAppUnderMaintenenceBinding {
        return HomeFragmentAppUnderMaintenenceBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    companion object {
        var isOpen = false
    }

    override fun onStart() {
        super.onStart()
        isOpen = true
    }

    override fun onStop() {
        super.onStop()
        isOpen = false
    }

    override fun onResume() {
        super.onResume()
        Handler(Looper.getMainLooper()).postDelayed({
            if (appPreferences.isAppUnderMaintenance().not()) {
                navigator.finish()
            }
        }, 500)
    }

    override fun onBackActionPerform(): Boolean {
        return false
    }

    override fun bindData() {
        with(binding) {
            textViewTitle.text = title
            textViewDescription.text = description
        }
        setViewListeners()
    }

    private fun setViewListeners() {
        binding.apply {

        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {

    }
}