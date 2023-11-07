package com.mytatva.patient.ui.labtest.fragment

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.RequiresApi
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.transition.TransitionManager
import com.google.android.gms.maps.model.LatLng
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.google.android.material.tabs.TabLayout
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.ChildData
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestFragmentTestDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.location.MyLocationUtil
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.labtest.adapter.ShowAllTestsAdapter
import com.mytatva.patient.ui.labtest.bottomsheet.ChooseLocationBottomSheetDialog
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.load


class LabTestDetailsFragment : BaseFragment<LabtestFragmentTestDetailsBinding>() {

    /*private val isToSetCallbackResult: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_TO_SET_CALLBACK_RESULT) ?: false
    }*/

    private var isToUpdateCartStatusOnly: Boolean = false

    //private var pinCode: String? = null

    private var testPackageData: TestPackageData? = null
    private val labTestId: String? by lazy {
        arguments?.getString(Common.BundleKey.LAB_TEST_ID)
    }

    private val subTestList = arrayListOf<ChildData>()
    private val showAllTestsAdapter by lazy {
        ShowAllTestsAdapter(subTestList)
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
    ): LabtestFragmentTestDetailsBinding {
        return LabtestFragmentTestDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    private var isLocationAskedOnce = false

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LabtestDetails)
    }

    override fun bindData() {
        //pinCode = arguments?.getString(Common.BundleKey.PIN_CODE)
        binding.layoutChangeLocation.textViewLocation.text =
            ChooseLocationBottomSheetDialog.currentPinCode
        Handler(Looper.getMainLooper()).postDelayed({
            testDetail()
            setUpPincode()
        }, 200)
        setViewListeners()
        setUpToolbar()
        setUpRecyclerView()
    }

    private fun setUpPincode() {
        locationManager.isPermissionGranted { granted ->
            if (granted) {
                if (isLocationAskedOnce || ChooseLocationBottomSheetDialog.currentPinCode.isNotBlank()) {
                    binding.layoutChangeLocation.textViewLocation.text =
                        ChooseLocationBottomSheetDialog.currentPinCode
                    testDetail()
                } else {
                    locationManager.startLocationUpdates({ location, exception ->
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
                    }, true)
                }
            } else {

                (requireActivity() as BaseActivity).handleLocationPermissionForChoosePinCode(
                    successCallBack = { location, error ->
                        location?.let {
                            val mLatLng = LatLng(location.latitude, location.longitude)
                            locationManager.stopFetchLocationUpdates()
                            setPinCodeAndUpdate(mLatLng)
                        }
                        // error case will not come here already handled in handleLocationPermissionForChoosePinCode
                    },
                    manualCallback = {
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

        /*if (isLocationAskedOnce || ChooseLocationBottomSheetDialog.currentPinCode.isNotBlank()) {
            binding.layoutChangeLocation.textViewLocation.text =
                ChooseLocationBottomSheetDialog.currentPinCode
            testDetail()
        } else {
            showLoader()
            isLocationAskedOnce = true
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
                                if (pinCode.isNotBlank()) {
                                    ChooseLocationBottomSheetDialog.currentPinCode = pinCode
                                    binding.layoutChangeLocation.textViewLocation.text = pinCode
                                }
                                testDetail()
                            })
                    }
                }
                exception?.let {
                    hideLoader()
                    testDetail()
                    if (it.status == LocationManager.Status.NO_PERMISSION) {
                        //it.message?.let { it1 -> showMessage(it1) }
                    }
                }
            }
        }*/
    }

    /*override fun onBackActionPerform(): Boolean {
        if (isToSetCallbackResult) {
            val intent = Intent()
            intent.putExtra(Common.BundleKey.LAB_TEST_DATA, testPackageData)
            requireActivity().setResult(Activity.RESULT_OK, intent)
            requireActivity().finish()
            return false
        } else {
            return super.onBackActionPerform()
        }
    }*/

    private fun showPermissionExceptionDialog() {
        (requireActivity() as BaseActivity).showOpenPermissionSettingDialog(
            arrayListOf(BaseActivity.AndroidPermissions.Location)
        )
    }

    private fun setPinCodeAndUpdate(mLatLng: LatLng) {
        if (isAdded) {
            showLoader()
            MyLocationUtil.getCurrantLocation(requireContext(),
                mLatLng,
                callback = { address ->
                    hideLoader()
                    val pinCode = address?.postalCode ?: ""
                    if (pinCode.isNotBlank()) {
                        ChooseLocationBottomSheetDialog.currentPinCode = pinCode
                        binding.layoutChangeLocation.textViewLocation.text = pinCode
                    }
                    testDetail()
                })
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewAllTests.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = showAllTestsAdapter
            }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.test_details_title)
            imageViewNotification.visibility = View.GONE
            imageViewSearch.visibility = View.GONE
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }

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

    private fun setViewListeners() {
        with(binding) {
            textViewRemove.setOnClickListener { onViewClick(it) }
            buttonAddToCart.setOnClickListener { onViewClick(it) }
            //buttonViewCart.setOnClickListener { onViewClick(it) }
            layoutChangeLocation.textViewChangeLocation.setOnClickListener { onViewClick(it) }
            textViewLabelIncludeNoOfTests.setOnClickListener { onViewClick(it) }
            buttonViewMoreTest.setOnClickListener { onViewClick(it) }

            tabLayout.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
                override fun onTabSelected(tab: TabLayout.Tab?) {
                    if (tab?.position == 0) {
                        layoutTestRequirements.isVisible = false
                        textViewDescription.isVisible = true
                    } else {
                        layoutTestRequirements.isVisible = true
                        textViewDescription.isVisible = false
                    }
                }

                override fun onTabUnselected(tab: TabLayout.Tab?) {
                }

                override fun onTabReselected(tab: TabLayout.Tab?) {
                }
            })
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewLabelIncludeNoOfTests -> {
                with(binding) {
                    TransitionManager.beginDelayedTransition(root)
                    if (recyclerViewAllTests.isVisible) {
                        recyclerViewAllTests.isVisible = false
                        imageViewUpDown.rotation = 0F
                    } else {
                        recyclerViewAllTests.isVisible = true
                        imageViewUpDown.rotation = 180F
                    }
                }
            }

            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.textViewRemove -> {
                removeFromCart()
            }

            R.id.buttonAddToCart -> {
                addToCart()
            }
            /*R.id.buttonViewCart -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LabtestCartFragment::class.java).start()
            }*/
            R.id.textViewChangeLocation -> {
                handleChooseLocation()
            }

            R.id.buttonViewMoreTest -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    LabTestListFragment::class.java
                ).start()
            }
        }
    }

    private fun handleChooseLocation() {
        ChooseLocationBottomSheetDialog().apply {
            callback = { pincode ->
                binding.layoutChangeLocation.textViewLocation.text = pincode
                testDetail()
            }
        }.show(
            requireActivity().supportFragmentManager,
            ChooseLocationBottomSheetDialog::class.java.simpleName
        )
    }

    private fun handleOnClickAddToCart() {
        with(binding) {
            TransitionManager.beginDelayedTransition(layoutContent)
            buttonAddToCart.isVisible = false
            textViewRemove.isVisible = false
            //layoutCart.isVisible = true
        }
    }

    private fun handleOnClickRemoveFromCart() {
        with(binding) {
            TransitionManager.beginDelayedTransition(layoutContent)
            buttonAddToCart.isVisible = true
            textViewRemove.isVisible = false
            //layoutCart.isVisible = false
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun testDetail(needToUpdateCartOnly: Boolean = false) {
        isToUpdateCartStatusOnly = needToUpdateCartOnly
        val apiRequest = ApiRequest().apply {
            lab_test_id = labTestId
            Pincode = ChooseLocationBottomSheetDialog.currentPinCode
        }
        showLoader()
        doctorViewModel.testDetail(apiRequest)
    }

    private fun addToCart() {
        testPackageData?.let {
            val apiRequest = ApiRequest().apply {
                code = it.code
            }
            showLoader()
            doctorViewModel.addToCart(
                apiRequest,
                labTestId ?: "",
                screenName = AnalyticsScreenNames.LabtestDetails
            )
        }
    }

    private fun removeFromCart() {
        testPackageData?.let {
            val apiRequest = ApiRequest().apply {
                code = it.code
            }
            showLoader()
            doctorViewModel.removeFromCart(
                apiRequest,
                labTestId ?: "",
                screenName = AnalyticsScreenNames.LabtestDetails
            )
        }
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val fragment =
            requireActivity().supportFragmentManager.fragments.find { it is BaseBottomSheetDialogFragment<*> }
        Log.d("onActivityResult", "$fragment")
        if (fragment != null) {
            (fragment as BottomSheetDialogFragment)
                .onActivityResult(requestCode, resultCode, data)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        Log.e("onRequestPermissionsResult", "$requestCode")
        val fragment =
            requireActivity().supportFragmentManager.fragments.find { it is BaseBottomSheetDialogFragment<*> }
        Log.d("onRequestPermissionsResult", "$fragment")

        if (fragment != null) {
            (fragment as BottomSheetDialogFragment)
                .onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //testDetailLiveData
        doctorViewModel.testDetailLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { setDetails(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //addToCartLiveData
        doctorViewModel.addToCartLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                testDetail(true)
                //handleOnClickAddToCart()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //removeFromCartLiveData
        doctorViewModel.removeFromCartLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                testDetail(true)
                //handleOnClickRemoveFromCart()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun setDetails(testPackageData: TestPackageData) {//
        this.testPackageData = testPackageData
        with(binding) {
            testPackageData.let {

                if (!isToUpdateCartStatusOnly) {
                    imageViewIcon.load(it.imageLocation ?: "", isCenterCrop = false)
                    textViewTitle.text = it.name
                    textViewPriceNew.text =
                        getString(R.string.symbol_rupee).plus(it.discount_price ?: "")
                    textViewPriceOld.text = getString(R.string.symbol_rupee).plus(it.price ?: "")
                    textViewLabelOnwards.text = it.discount_percent.plus("% OFF")
                    textViewLabelOnwards.isVisible = it.discountPercent > 0
                    textViewPriceOld.isVisible = it.discountPercent > 0
                    textViewDescription.text = it.description ?: ""

                    textViewSampleType.text = ": ".plus(it.specimenType ?: "")
                    textViewFastingRequired.text = ": ".plus(it.fasting ?: "")

                    imageViewLabIcon.load(it.lab?.image ?: "", isCenterCrop = false)
                    textViewLabName.text = it.lab?.name ?: ""

                    subTestList.clear()
                    subTestList.addAll(it.childs ?: arrayListOf())
                    showAllTestsAdapter.notifyDataSetChanged()

                    textViewLabelIncludeNoOfTests.text = "Includes ${subTestList.size} tests"
                }

                /*if (it.available != "Y") {
                    textViewUnavailable.isVisible = true
                } else {*/
                textViewUnavailable.isVisible = false

                if (it.in_cart != "Y") {
                    handleOnClickRemoveFromCart()
                } else {
                    handleOnClickAddToCart()
                }
                /*}*/
                session.cart = it.cart
                updateToolbarCartUI()

                // layoutCart - bottom cart layout removed
                /*layoutCart.isVisible = (it.cart?.totalCartCount ?: 0) > 0
                textViewCartBadge.text = it.cart?.total_test
                textViewPrice.text = getString(R.string.symbol_rupee).plus(it.cart?.total_price)*/

                layoutShowAllTests.isVisible = subTestList.isNotEmpty()

                //tabLayout.isVisible = it.isPackage.not()
                //textViewDescription.isVisible = it.isPackage.not()

            }
        }
    }
}