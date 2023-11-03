package com.mytatva.patient.ui.profile.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.ProfileFragmentMyDevicesBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.profile.adapter.MyDevicesAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit


class MyDevicesFragment : BaseFragment<ProfileFragmentMyDevicesBinding>() {

    private val deviceList = arrayListOf<TempDataModel>()
    var resumedTime = Calendar.getInstance().timeInMillis

    private val myDevicesAdapter by lazy {
        MyDevicesAdapter(deviceList,
            object : MyDevicesAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    openDetails()
                }

                override fun onConnectClick(position: Int) {
                    openDetails()
                    //handleConnectClick(position)
                }
            })
    }

    private fun openDetails() {
        navigator.loadActivity(IsolatedFullActivity::class.java,
            MyDeviceDetailsFragment::class.java)
            .start()
    }

    private fun handleConnectClick(position: Int) {
        if (deviceList[position].isConnected) {

            googleFit.disconnectWithAlert { isSuccess ->
                if (isSuccess) {
                    deviceList[position].isConnected = false
                    myDevicesAdapter.notifyItemChanged(position)
                }
            }

        } else {
            openDetails()
        }
    }

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
    ): ProfileFragmentMyDevicesBinding {
        return ProfileFragmentMyDevicesBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.MyDevices)
        resumedTime = Calendar.getInstance().timeInMillis
        setUpRecyclerView()
    }

    override fun bindData() {
        setUpToolbar()
    }

    private fun setUpRecyclerView() {
        deviceList.clear()
        deviceList.add(TempDataModel(name = getString(R.string.my_devices_label_google_fit),
            image = R.drawable.ic_google_fit_guideline,
            isConnected = googleFit.hasAllPermissions))

        binding.recyclerView.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = myDevicesAdapter
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.my_devices_title)
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
            R.id.imageViewNotification -> {
                openNotificationScreen()
            }
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
    private fun observeLiveData() {

    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_MY_DEVICES, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.MyDevices)
    }
}