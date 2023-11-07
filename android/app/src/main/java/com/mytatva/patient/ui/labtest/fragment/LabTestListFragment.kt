package com.mytatva.patient.ui.labtest.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.TestListSeparateData
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestFragmentLabtestListBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.PopularTestAdapter
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.openDialer


class LabTestListFragment : BaseFragment<LabtestFragmentLabtestListBinding>() {

    //var resumedTime = Calendar.getInstance().timeInMillis
    private val popularTestList = arrayListOf<TestPackageData>()
    private val popularTestAdapter by lazy {
        PopularTestAdapter(popularTestList,
            object : PopularTestAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        LabTestDetailsFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.LAB_TEST_ID,
                                popularTestList[position].lab_test_id)
                        )).start()
                }
            })
    }

    private val popularHealthPackagesList = arrayListOf<TestPackageData>()
    private val popularHealthPackagesAdapter by lazy {
        PopularTestAdapter(popularHealthPackagesList,
            object : PopularTestAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        LabTestDetailsFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.LAB_TEST_ID,
                                popularHealthPackagesList[position].lab_test_id)
                        )).start()
                }
            })
    }

    private var callUsToBookContactNumber: String? = null

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestFragmentLabtestListBinding {
        return LabtestFragmentLabtestListBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LabtestList)
        //resumedTime = Calendar.getInstance().timeInMillis
        analytics.logEvent(analytics.USER_OPEN_POPULAR_LABTESTS,
            screenName = AnalyticsScreenNames.LabtestList)
        setUpRecyclerView()
        getCartCountData()
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        testsListSeparate()
    }

    private fun setUpViewListeners() {
        with(binding) {
            editTextSearch.setOnClickListener { onViewClick(it) }
            textViewCallUs.setOnClickListener { onViewClick(it) }
            textViewViewAllPopularTest.setOnClickListener { onViewClick(it) }
            textViewViewAllHealthPackages.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewPopularTest.apply {
            layoutManager = GridLayoutManager(requireContext(), 2, RecyclerView.VERTICAL, false)
            adapter = popularTestAdapter
        }

        binding.recyclerViewHealthPackages.apply {
            layoutManager = GridLayoutManager(requireContext(), 2, RecyclerView.VERTICAL, false)
            adapter = popularHealthPackagesAdapter
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.labtest_list_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }

            imageViewToolbarCart.visibility = View.VISIBLE
            imageViewToolbarCart.setOnClickListener {
                openCart()
            }
            updateToolbarCartUI()
        }
    }

    private fun updateToolbarCartUI() {
        with(binding.layoutHeader) {
            session.cart?.let {
                if (it.totalCartCount > 0) {
                    textViewCartBadgeCount.visibility = View.VISIBLE
                    textViewCartBadgeCount.text = it.totalCartCount.toString()
                } else {
                    textViewCartBadgeCount.visibility = View.GONE
                }
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.editTextSearch -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LabTestListNormalFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.IS_ALL, true)
                    )).start()
            }
            R.id.textViewCallUs -> {
                analytics.logEvent(analytics.CALL_US_TO_BOOK_TEST_CLICKED,
                    screenName = AnalyticsScreenNames.LabtestList)
                callUsToBookContactNumber?.let { requireActivity().openDialer(it) }
            }
            R.id.textViewViewAllPopularTest -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LabTestListNormalFragment::class.java)
                    .start()
            }
            R.id.textViewViewAllHealthPackages -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    HealthPackageListFragment::class.java)
                    .start()
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun testsListSeparate() {
        showLoader()
        doctorViewModel.testsListSeparate()
    }

    private fun getCartCountData() {
        doctorViewModel.getCartInfo()
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //testsListSeparateLiveData
        doctorViewModel.testsListSeparateLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                handleTestListResponse(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                handleTestListResponse(null)
                true
            })

        //getCartCountDataLiveData
        doctorViewModel.getCartInfoLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                updateToolbarCartUI()
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleTestListResponse(testListSeparateData: TestListSeparateData?) {
        testListSeparateData?.let {
            popularTestList.clear()
            it.tests?.let { it1 -> popularTestList.addAll(it1) }
            popularHealthPackagesList.clear()
            it.packages?.let { it1 -> popularHealthPackagesList.addAll(it1) }

            callUsToBookContactNumber = it.call?.mobile
        }
        popularTestAdapter.notifyDataSetChanged()
        popularHealthPackagesAdapter.notifyDataSetChanged()
    }

    override fun onPause() {
        super.onPause()
        //updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        /*val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_MY_DEVICES, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        })*/
    }
}