package com.mytatva.patient.ui.auth.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.LanguageData
import com.mytatva.patient.databinding.AuthFragmentSelectLanguageListBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.auth.adapter.LanguageAdapter
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class SelectLanguageListFragment : BaseFragment<AuthFragmentSelectLanguageListBinding>() {

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val languageList = arrayListOf<LanguageData>()

    private val languageAdapter by lazy {
        LanguageAdapter(languageList)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean
    ): AuthFragmentSelectLanguageListBinding {
        return AuthFragmentSelectLanguageListBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LanguageList)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()
        getLanguageList()
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewLanguage.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = languageAdapter
        }
    }

    private fun setViewListeners() {
        binding.apply {
            layoutHeader.apply {
                textViewToolbarTitle.text = getString(R.string.select_language_title)
                imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            }
            buttonSubmit.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.buttonSubmit -> {
                if (languageList.isNotEmpty()) {
                    val intent = Intent().apply {
                        putExtra(
                            Common.BundleKey.LANGUAGE_DATA,
                            languageList[languageAdapter.selectedPosition]
                        )
                    }
                    activity?.setResult(Activity.RESULT_OK, intent)
                }
                activity?.finish()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getLanguageList() {
        showLoader()
        val apiRequest = ApiRequest()
        authViewModel.getLanguageList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.getLanguageListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                languageList.clear()
                responseBody.data?.let { languageList.addAll(it) }
                languageAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}