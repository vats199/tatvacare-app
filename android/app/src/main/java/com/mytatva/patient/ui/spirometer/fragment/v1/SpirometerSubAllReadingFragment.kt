package com.mytatva.patient.ui.spirometer.fragment.v1

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.SpirometerTestResData
import com.mytatva.patient.databinding.SpirometerFragmentSubAllReadingsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.spirometer.adapter.SpirometerReadingsAdapter
import com.mytatva.patient.ui.spirometer.fragment.SpirometerAllReadingsFragment
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class SpirometerSubAllReadingFragment : BaseFragment<SpirometerFragmentSubAllReadingsBinding>() {

    //pagination params
    var page = 1
    internal var isLoading = false
    var isLastPage: Boolean = false
    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null
    private var list = ArrayList<SpirometerTestResData>()

    var typeOfReadings: String = ""

    private val spirometerReadingsAdapter by lazy {
        SpirometerReadingsAdapter(list, object : SpirometerReadingsAdapter.AdapterListener {
            override fun onDownloadClick(position: Int) {
                if (list.isNotEmpty()) {

                    analytics.logEvent(
                        analytics.USER_DOWNLOADS_REPORT, Bundle().apply {
                            putString(
                                analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.SPIROMETER
                            )
                        }, screenName = AnalyticsScreenNames.SpirometerAllReadings
                    )

                    val item = list[position]
                    item.document_url?.let {
                        downloadHelper.startDownload(
                            downloadUrl = it,
                            downloadFileName = downloadHelper.getFileNameForSpirometerReport(),
                            downloadDirName = downloadHelper.DIR_REPORTS
                        )
                    }
                }
            }
        })
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    fun resetPagingData() {
        isLoading = true
        page = 1
        previousTotal = 0
        isLastPage = false
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        resetPagingData()
        spirometerTestList()
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): SpirometerFragmentSubAllReadingsBinding {
        return SpirometerFragmentSubAllReadingsBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        linearLayoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
        binding.recyclerViewAllReadings.apply {
            layoutManager = linearLayoutManager
            adapter = spirometerReadingsAdapter
        }

        binding.recyclerViewAllReadings.addOnScrollListener(object :
            PaginationScrollListener(linearLayoutManager!!) {
            override fun isLastPage(): Boolean {
                return isLastPage
            }

            override fun isLoading(): Boolean {
                return isLoading
            }

            override fun loadMoreItems() {
                isLoading = true
                //you have to call load more items to get more data
                page++
                spirometerTestList()
            }

            override fun isScrolledDown(isScrolledDown: Boolean) {

            }
        })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun onTestListResponse(
        spirometerTestResDataArrayList: java.util.ArrayList<SpirometerTestResData>?,
        msg: String = ""
    ) {
        if (isAdded) {
            if (page == 1) list.clear()
            spirometerTestResDataArrayList?.let { list.addAll(it) }
            spirometerReadingsAdapter.notifyDataSetChanged()

            with(binding) {
                if (list.isEmpty()) {
                    textViewNoData.isVisible = true
                    recyclerViewAllReadings.isVisible = false
                    textViewNoData.text = msg
                } else {
                    textViewNoData.isVisible = false
                    recyclerViewAllReadings.isVisible = true
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    fun spirometerTestList() {
        val apiRequest = ApiRequest().apply {
            page = this@SpirometerSubAllReadingFragment.page.toString()
            type = typeOfReadings
        }
        showLoader()
        goalReadingViewModel.spirometerTestList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //spirometerTestListLiveData
        goalReadingViewModel.spirometerTestListLiveData.observe(this, onChange = { responseBody ->
            if (SpirometerAllReadingsFragment.isUpdateAPICalled.not())
                hideLoader()
            isLoading = false
            onTestListResponse(responseBody.data)
        }, onError = { throwable ->
            if (SpirometerAllReadingsFragment.isUpdateAPICalled.not())
                hideLoader()
            isLoading = false
            isLastPage = true
            if (page == 1) {
                onTestListResponse(null, throwable.message ?: "")
            }
            false
        })
    }
}