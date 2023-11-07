package com.mytatva.patient.ui.profile.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.ProfileFragmentDeleteMyAccountBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class DeleteMyAccountFragment : BaseFragment<ProfileFragmentDeleteMyAccountBinding>() {

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ProfileFragmentDeleteMyAccountBinding {
        return ProfileFragmentDeleteMyAccountBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
    }

    override fun bindData() {
        setUpToolbar()
        setupViewListeners()
        setUpRecyclerView()
    }

    private fun setupViewListeners() {
        with(binding) {
            buttonDelete.setOnClickListener { onViewClick(it) }
            textViewCancel.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        /*binding.recyclerView.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = myDevicesAdapter
        }*/
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.delete_my_account_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.buttonDelete -> {
                navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_delete),
                    dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                        override fun onYesClick() {
                            deleteAccount()
                        }

                        override fun onNoClick() {

                        }
                    })
            }
            R.id.textViewCancel -> {
                navigator.goBack()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun deleteAccount() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.deleteAccount(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.deleteAccountLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                logout(AnalyticsScreenNames.AccountDelete)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}