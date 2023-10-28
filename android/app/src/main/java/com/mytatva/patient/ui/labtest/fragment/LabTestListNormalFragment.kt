package com.mytatva.patient.ui.labtest.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.core.widget.addTextChangedListener
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.gms.maps.model.LatLng
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestFragmentLabtestListNormalBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.location.MyLocationUtil
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.address.dialog.LocationPermissionBottomSheetDialog
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.NormalPackageListAdapter
import com.mytatva.patient.ui.labtest.adapter.NormalTestListAdapter
import com.mytatva.patient.ui.labtest.bottomsheet.ChooseLocationBottomSheetDialog
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import kotlinx.coroutines.*


class LabTestListNormalFragment : BaseFragment<LabtestFragmentLabtestListNormalBinding>() {

    private var pinCode: String? = null

    private val isAll: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_ALL) ?: false
    }

    //var resumedTime = Calendar.getInstance().timeInMillis

    private val testList = arrayListOf<TestPackageData>()
    private val normalTestListAdapter by lazy {
        NormalTestListAdapter(testList,
            object : NormalTestListAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        LabTestDetailsFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.LAB_TEST_ID,
                                testList[position].lab_test_id),
                            Pair(Common.BundleKey.PIN_CODE, pinCode)
                        )).start()
                }
            })
    }

    private val packagesList = arrayListOf<TempDataModel>()
    private val normalPackageListAdapter by lazy {
        NormalPackageListAdapter(packagesList,
            object : NormalPackageListAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    /*navigator.loadActivity(IsolatedFullActivity::class.java,
                        LabTestDetailsFragment::class.java)
                        .start()*/
                }
            })
    }


    //pagination params
    var page = 1
    internal var isLoading = false
    private var isMoreDataAvailable = true
    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null
    //var isLastPage: Boolean = false

    fun resetPagingData() {
        isLoading = false
        page = 1
        previousTotal = 0
        isMoreDataAvailable = true
    }

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
    ): LabtestFragmentLabtestListNormalBinding {
        return LabtestFragmentLabtestListNormalBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AllTestPackageList)
        getCartCountData()
        //resumedTime = Calendar.getInstance().timeInMillis

        Handler(Looper.getMainLooper()).postDelayed({
            resetPagingData()
            testsList(true)
        }, 500)
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        setUpRecyclerView()
        setUpSearch()
        setUpPincode()

       /* if (isAll) {
            Handler(Looper.getMainLooper()).postDelayed({
                binding.editTextSearch.requestFocus()
                showKeyBoard()
            }, 100)
        }*/
    }

    private fun setUpPincode() {
        if (isAdded) {
            locationManager.isPermissionGranted { granted ->
                if (granted) {
                    if (ChooseLocationBottomSheetDialog.currentPinCode.isNotBlank()) {
                        this.pinCode = ChooseLocationBottomSheetDialog.currentPinCode
                        binding.layoutChangeLocation.textViewLocation.text = pinCode
                        resetPagingData()
                        testsList()
                    } else {
                        locationManager.startLocationUpdates {location, exception ->
                            location?.let {
                                val mLatLng = LatLng(location.latitude, location.longitude)
                                locationManager.stopFetchLocationUpdates()
                                Log.d("LatLng", ":: ${mLatLng?.latitude} , ${mLatLng?.longitude}")
                                setPinCodeAndUpdate(mLatLng)
                            }
                            exception?.let {
                                hideLoader()
                                if (it.status == LocationManager.Status.NO_PERMISSION) {
                                    showPermissionExceptionDialog()
                                }
                            }
                        }
                    }
                } else {

                    (requireActivity() as BaseActivity).handleLocationPermissionForChoosePinCode(successCallBack = { location, error ->
                        location?.let {
                            val mLatLng = LatLng(location.latitude, location.longitude)
                            locationManager.stopFetchLocationUpdates()
                            setPinCodeAndUpdate(mLatLng)
                        }
                        // error case will not come here already handled in handleLocationPermissionForChoosePinCode
                    }, manualCallback = {
                        handleChooseLocation()
                    })

                    /*val bottomSheet = LocationPermissionBottomSheetDialog().apply {
                        arguments = this.arguments
                    }

                    bottomSheet.grantPermission = {
                        locationManager.requestPermissionCustom(successCallback = { location, error ->
                            if (isResumed) {
                                location?.let {
                                    val mLatLng = LatLng(location.latitude, location.longitude)
                                    locationManager.stopFetchLocationUpdates()
                                    setPinCodeAndUpdate(mLatLng)
                                    bottomSheet.dismiss()
                                }
                                error?.let {
                                    hideLoader()
                                    if (it.status == LocationManager.Status.NO_PERMISSION) {
                                        showPermissionExceptionDialog()
                                    }
                                }
                            }
                            bottomSheet.dismiss()
                        })
                    }

                    bottomSheet.selectManual = {
                        handleChooseLocation()
                        bottomSheet.dismiss()
                    }

                    bottomSheet.show(requireActivity().supportFragmentManager, LocationPermissionBottomSheetDialog::class.java.simpleName)*/
                }
            }
           /* if (ChooseLocationBottomSheetDialog.currentPinCode.isNotBlank()) {
                this.pinCode = ChooseLocationBottomSheetDialog.currentPinCode
                binding.layoutChangeLocation.textViewLocation.text = pinCode
                resetPagingData()
                testsList()
            } else {
                showLoader()
                locationManager.startLocationUpdates { location, exception ->
                    hideLoader()
                    location?.let {
                        val mLatLng = LatLng(location.latitude, location.longitude)
                        locationManager.stopFetchLocationUpdates()
                        Log.d("LatLng", ":: ${mLatLng?.latitude} , ${mLatLng?.longitude}")
                        if (isAdded) {
                            showLoader()
                            MyLocationUtil.getCurrantLocation(requireContext(),
                                mLatLng,
                                callback = { address ->
                                    hideLoader()
                                    val pinCode = address?.postalCode ?: ""
                                    //val city = address?.locality ?: address?.subAdminArea ?: ""
                                    if (pinCode.isNotBlank()) {
                                        ChooseLocationBottomSheetDialog.currentPinCode = pinCode
                                        this.pinCode = pinCode
                                        binding.layoutChangeLocation.textViewLocation.text = pinCode
                                        resetPagingData()
                                        testsList()
                                    } else {
                                        //showMessage("Location data not found")
                                    }
                                })
                        }
                    }
                    exception?.let {
                        hideLoader()
                        if (it.status == LocationManager.Status.NO_PERMISSION) {
                            it.message?.let { it1 -> showMessage(it1) }
                        }
                    }
                }
            }*/
        }
    }

    private fun setPinCodeAndUpdate(mLatLng:LatLng) {
        if (isAdded) {
            showLoader()
            MyLocationUtil.getCurrantLocation(requireContext(),
                mLatLng,
                callback = { address ->
                    hideLoader()
                    val pinCode = address?.postalCode ?: ""
                    if (pinCode.isNotBlank()) {
                        ChooseLocationBottomSheetDialog.currentPinCode = pinCode
                        this.pinCode = pinCode
                        binding.layoutChangeLocation.textViewLocation.text = pinCode
                        resetPagingData()
                        testsList()
                    }
                })
        }
    }

    private fun showPermissionExceptionDialog() {
        (requireActivity() as BaseActivity).showOpenPermissionSettingDialog(
            arrayListOf(BaseActivity.AndroidPermissions.Location)
        )
    }

    private fun handleChooseLocation() {
        ChooseLocationBottomSheetDialog().apply {
            callback={ pincode ->
                binding.layoutChangeLocation.textViewLocation.text = pincode
                pinCode = pincode
                resetPagingData()
                testsList()
            }
        }.show(requireActivity().supportFragmentManager,
            ChooseLocationBottomSheetDialog::class.java.simpleName)
    }

    var callApiJob: Job? = null

    private fun setUpSearch() {
        with(binding) {
            editTextSearch.addTextChangedListener { text ->
                callApiJob?.cancel()
                callApiJob = GlobalScope.launch(Dispatchers.Main) {
                    delay(300)
                    resetPagingData()
                    testsList()
                }
            }
        }
    }

    private fun setUpTabLayout() {
        /*with(binding) {
            tabLayout.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
                override fun onTabSelected(tab: TabLayout.Tab?) {
                    if (tab?.position == 0) {
                        recyclerViewPopularTest.isVisible = true
                        recyclerViewHealthPackages.isVisible = false
                    } else {
                        recyclerViewPopularTest.isVisible = false
                        recyclerViewHealthPackages.isVisible = true
                    }
                }

                override fun onTabUnselected(tab: TabLayout.Tab?) {

                }

                override fun onTabReselected(tab: TabLayout.Tab?) {

                }
            })
        }*/
    }

    private fun setUpViewListeners() {
        with(binding) {
            layoutChangeLocation.textViewChangeLocation.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        linearLayoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
        binding.recyclerViewPopularTest.apply {
            layoutManager = linearLayoutManager
            adapter = normalTestListAdapter
        }

        binding.nestedScrollView.viewTreeObserver.addOnScrollChangedListener {
            val view: View =
                binding.nestedScrollView.getChildAt(binding.nestedScrollView.childCount - 1) as View
            val diff: Int =
                view.bottom - (binding.nestedScrollView.height + binding.nestedScrollView.scrollY)
            if (diff <= 0 && isMoreDataAvailable && !isLoading) {
                // your pagination code
                isLoading = true
                page++
                testsList()
            }
        }
        /*binding.recyclerViewHealthPackages.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = normalPackageListAdapter
        }*/
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.labtest_list_normal_title)
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
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.textViewChangeLocation -> {
                handleChooseLocation()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun testsList(isToShowLoader: Boolean = false) {
        val apiRequest = ApiRequest().apply {
            type = if (isAll) "all" else "test"
            page = this@LabTestListNormalFragment.page.toString()
            if (binding.editTextSearch.text.toString().trim().isNotBlank()) {
                search = binding.editTextSearch.text.toString().trim()
            }
            pincodeSmall = pinCode
        }
        if (isToShowLoader)
            showLoader()
        doctorViewModel.testsList(apiRequest)
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
        //testsListLiveData
        doctorViewModel.testsListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                isLoading = false
                handleTestListResponse(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                isLoading = false
                isMoreDataAvailable = false
                handleTestListResponse(null, throwable.message ?: "")
                false
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
    private fun handleTestListResponse(list: ArrayList<TestPackageData>?, message: String = "") {
        if (page == 1) {
            testList.clear()
        }
        list?.let { testList.addAll(it) }
        normalTestListAdapter.notifyDataSetChanged()

        with(binding) {
            if (testList.isEmpty()) {
                nestedScrollView.isVisible = false
                textViewNoData.isVisible = true
                textViewNoData.text = message
            } else {
                nestedScrollView.isVisible = true
                textViewNoData.isVisible = false
            }
        }
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