package com.mytatva.patient.ui.payment.bottomsheet

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import android.view.ContextThemeWrapper
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.PopupWindow
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.gms.maps.model.LatLng
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.LayoutPopUpWindowBinding
import com.mytatva.patient.databinding.PaymentBottomsheetSelectAddressListBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.address.fragment.AddressConfirmLocationFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.labtest.fragment.v1.SelectLabtestAppointmentDateTimeFragmentV1
import com.mytatva.patient.ui.payment.adapter.SelectAddressAdapter
import com.mytatva.patient.ui.payment.fragment.v1.BcpOrderReviewFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.SafeClickListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.dpToPx


class SelectAddressBottomSheetDialog :
    BaseBottomSheetDialogFragment<PaymentBottomsheetSelectAddressListBinding>() {

    private lateinit var linearLayoutManager: LinearLayoutManager
    private var callback: (item: String) -> Unit = {}
    private var currentClickPos = -1

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val addressUpdateIntentFilter: IntentFilter = IntentFilter(ACTION_ADDRESS_UPDATED)
        LocalBroadcastManager.getInstance(requireContext())
            .registerReceiver(addressEventReceiver, addressUpdateIntentFilter)

        observeLiveData()
    }

    override fun onDestroy() {
        LocalBroadcastManager.getInstance(requireContext()).unregisterReceiver(addressEventReceiver)
        super.onDestroy()
    }

    fun setCallback(callback: (item: String) -> Unit): SelectAddressBottomSheetDialog {
        this.callback = callback
        return this
    }

    private val addressList: ArrayList<TestAddressData> = arrayListOf()

    private val selectAddressAdapter by lazy {
        SelectAddressAdapter(addressList, itemSelected = {
            if (arguments?.containsKey(Common.BundleKey.LIST_CART_DATA) == true) {
                //for labtest flow select address event
                analytics.logEvent(analytics.LABTEST_ADDRESS_SELECTED, Bundle().apply {
                    putString(analytics.PARAM_ADDRESS_ID, addressList[it].patient_address_rel_id)
                }, screenName = AnalyticsScreenNames.SelectAddress)

            } else {
                //for other(BCP) flow select address event
                analytics.logEvent(
                    analytics.SELECT_ADDRESS,
                    Bundle().apply {
                        putString(analytics.PARAM_BOTTOM_SHEET_NAME, "select address")
                        putString(analytics.PARAM_ADDRESS_NUMBER, (it + 1).toString())
                        putString(analytics.PARAM_ADDRESS_TYPE, addressList[it].address_type)
                    },
                    screenName = AnalyticsScreenNames.SelectAddressBottomSheet
                )

            }
            this.buttonChange(it)

            // directly call button on click as button is hidden when address list is not empty
            binding.buttonAddSaveAddress.callOnClick()

        }, onMoreClick = { view, position ->
            view.showSortPopup(position) { isEdit ->
                handleEditDeleteNavigation(isEdit, position)
            }
        })
    }

    companion object {
        val ACTION_ADDRESS_UPDATED = "ACTION_ADDRESS_UPDATED"
    }

    private val addressEventReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            Log.d("action", "Name : ${intent?.action}")
            if (intent?.action == ACTION_ADDRESS_UPDATED) {
                addressList()
            }
        }
    }

    private fun handleEditDeleteNavigation(isEdit: Boolean, position: Int) {
        if (isEdit) {
            openAddAddress(addressList[position])
        } else {
            currentClickPos = position
            addressList[position].patient_address_rel_id?.let { deleteAddress(it) }
        }
    }

    lateinit var changeSortPopUp: PopupWindow
    private fun View.showSortPopup(position: Int, onEditClick: (Boolean) -> Unit) {
        // Inflate the layout_pop_up_window.xml
        val contextThemeWrapper = ContextThemeWrapper(this.context, R.style.popupOverflowMenu)
        val layout = LayoutPopUpWindowBinding.inflate(
            LayoutInflater.from(this.context),
            this.rootView as ViewGroup?, false
        )

        // Creating the PopupWindow
        changeSortPopUp = PopupWindow(contextThemeWrapper)
        changeSortPopUp.contentView = layout.root
        changeSortPopUp.width = dpToPx(75) //LinearLayoutCompat.LayoutParams.WRAP_CONTENT
        changeSortPopUp.height = LinearLayoutCompat.LayoutParams.WRAP_CONTENT
        changeSortPopUp.isFocusable = true

        val OFFSET_X = dpToPx(-50)
        val OFFSET_Y = if (position == addressList.lastIndex) dpToPx(0) else dpToPx(25)

        // Clear the default translucent background
        changeSortPopUp.setBackgroundDrawable(ContextCompat.getDrawable(requireContext(), R.drawable.bg_pop_up_menu_white))

        // Displaying the popup at the specified location, + offsets.
        changeSortPopUp.showAsDropDown(this, OFFSET_X, OFFSET_Y, Gravity.NO_GRAVITY)

        /*layout.layoutDelete.isVisible = addressList[position].bcp_address != "Y"
        layout.viewLine.isVisible = addressList[position].bcp_address != "Y"*/

        layout.layoutDelete.setOnClickListener {
            (requireActivity() as BaseActivity).showAlertDialogWithOptions(getString(R.string.alert_msg_delete),
                dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                    override fun onYesClick() {
                        onEditClick.invoke(false)
                        changeSortPopUp.dismiss()
                    }

                    override fun onNoClick() {

                    }
                })
        }
        layout.layoutEdit.setOnClickListener {
            onEditClick.invoke(true)
            changeSortPopUp.dismiss()
        }
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentBottomsheetSelectAddressListBinding {
        return PaymentBottomsheetSelectAddressListBinding.inflate(
            inflater,
            container,
            attachToRoot
        )
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleOnAddressListResponse(
        list: ArrayList<TestAddressData>?,
        message: String = "",
    ) {
        addressList.clear()
        list?.let { addressList.addAll(it) }
        selectAddressAdapter.notifyDataSetChanged()
        with(binding) {
            if (list.isNullOrEmpty()) {
                linearLayoutNoAddressaaListing.isVisible = true
//                textViewNoDataText.text = message
                textViewAddNew.isVisible = false
                recyclerViewAddressList.isVisible = false
                buttonAddSaveAddress.text = getString(R.string.payment_header_label_add_address)
            } else {
                linearLayoutNoAddressaaListing.isVisible = false
                recyclerViewAddressList.isVisible = true
                buttonAddSaveAddress.text = getString(R.string.payment_buttom_save_and_next)
                textViewAddNew.isVisible = true
                setUpRecyclerView()
                buttonChange(selectAddressAdapter.selectionPos)

                // hide button visibility on address list appear, button click flow handled on item click directly
                buttonAddSaveAddress.isVisible = false
            }
        }
    }

    override fun bindData() {
        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
        }
        binding.buttonAddSaveAddress.setOnClickListener(SafeClickListener { onViewClick(it) })
        binding.textViewAddNew.setOnClickListener(SafeClickListener { onViewClick(it) })
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SelectAddressBottomSheet)

        analytics.logEvent(
            analytics.SHOW_BOTTOM_SHEET,
            Bundle().apply {
                putString(analytics.PARAM_BOTTOM_SHEET_NAME, "select address")
            }, screenName = AnalyticsScreenNames.SelectAddressBottomSheet
        )

        addressList()
    }

    private fun setUpRecyclerView() = with(binding) {
        linearLayoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
        recyclerViewAddressList.apply {
            layoutManager = linearLayoutManager
            adapter = selectAddressAdapter
        }
    }

    private fun buttonChange(selectedPosition: Int) = with(binding) {
        if (selectedPosition == -1) {
            buttonAddSaveAddress.isEnabled = false
//            buttonAddSaveAddress.backgroundTintList =
//                ColorStateList.valueOf(requireContext().getColor(R.color.background_dark_gray))
        } else {
            buttonAddSaveAddress.isEnabled = true
//            buttonAddSaveAddress.backgroundTintList =
//                ColorStateList.valueOf(requireContext().getColor(R.color.colorPrimary))
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewAddNew -> {
                analytics.logEvent(
                    analytics.TAP_ADD_NEW,
                    Bundle().apply {
                        putString(analytics.PARAM_BOTTOM_SHEET_NAME, "select address")
                    },
                    screenName = AnalyticsScreenNames.SelectAddressBottomSheet
                )
                openAddAddress()
            }

            R.id.buttonAddSaveAddress -> {
                if (binding.buttonAddSaveAddress.text.equals(getString(R.string.payment_header_label_add_address))) {
                    analytics.logEvent(
                        analytics.ADD_ADDRESS,
                        Bundle().apply {
                            putString(analytics.PARAM_BOTTOM_SHEET_NAME, "address list")
                        },
                        screenName = AnalyticsScreenNames.SelectAddressBottomSheet
                    )

                    openAddAddress()
                } else {
                    analytics.logEvent(
                        analytics.TAP_SAVE_AND_NEXT,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_ADDRESS_NUMBER,
                                (selectAddressAdapter.selectionPos + 1).toString()
                            )
                            putString(
                                analytics.PARAM_ADDRESS_TYPE,
                                addressList[selectAddressAdapter.selectionPos].address_type
                            )
                        },
                        screenName = AnalyticsScreenNames.SelectAddressBottomSheet
                    )

                    if (arguments?.containsKey(Common.BundleKey.LIST_CART_DATA) == true) {
                        handleLabTestNavigationOnAddress()
                    } else {
                        handleBCPNavigationOnAddress()
                    }
                }
            }
        }
    }


    private fun handleBCPNavigationOnAddress() {

        val bundle = arguments ?: Bundle()
        bundle.putParcelable(
            Common.BundleKey.TEST_ADDRESS_DATA,
            addressList[selectAddressAdapter.selectionPos]
        )
        (requireActivity() as BaseActivity).loadActivity(
            IsolatedFullActivity::class.java,
            BcpOrderReviewFragment::class.java
        ).addBundle(bundle).start()
    }

    private fun handleLabTestNavigationOnAddress() {
        val bundle = arguments ?: Bundle()
        bundle.putParcelable(
            Common.BundleKey.TEST_ADDRESS_DATA,
            addressList[selectAddressAdapter.selectionPos]
        )
        (requireActivity() as BaseActivity).loadActivity(
            IsolatedFullActivity::class.java,
            SelectLabtestAppointmentDateTimeFragmentV1::class.java
        ).addBundle(bundle).start()

    }

    private fun openAddAddress(testAddressData: TestAddressData? = null) {
        /*arguments?.let {
            (requireActivity() as BaseActivity)
                .loadActivity(
                    IsolatedFullActivity::class.java,
                    AddAddressFragment::class.java
                ).addBundle(it).start()
        }*/

        if (testAddressData == null) {// for add new address flow remove argument, if added from edit once
            arguments?.remove(Common.BundleKey.TEST_ADDRESS_DATA)
        } else {// for edit address flow add addressData to arguments
            testAddressData.let {
                if (arguments == null) {
                    arguments = Bundle()
                }
                arguments?.putParcelable(Common.BundleKey.TEST_ADDRESS_DATA, it)
            }
        }

        if (isVisible) {
            (requireActivity() as BaseActivity).handleLocationPermission(
                successCallBack = { location, error ->
                    hideLoader()
                    location?.let {
                        //Current Location get
                        locationManager.stopFetchLocationUpdates()
                        val mLatLng = LatLng(location.latitude, location.longitude)
                        Log.d("LatLng", ":: ${mLatLng?.latitude} , ${mLatLng?.longitude}")
                        arguments?.let {
                            val bundle = it
//                        bundle.putParcelable(Common.MapKey.LATLONG, mLatLng)

                            val data = testAddressData?.apply {
                                if (this.latitude == null)
                                    this.latitude = mLatLng.latitude.toString()

                                if (this.longitude == null)
                                    this.longitude = mLatLng.longitude.toString()
                            }
                                ?: TestAddressData().apply {
                                    this.latitude = mLatLng.latitude.toString()
                                    this.longitude = mLatLng.longitude.toString()
                                }

                            bundle.putParcelable(Common.BundleKey.TEST_ADDRESS_DATA, data)

                            (requireActivity() as BaseActivity)
                                .loadActivity(
                                    IsolatedFullActivity::class.java,
                                    AddressConfirmLocationFragment::class.java
                                )
                                .addBundle(bundle)
                                .start()
                        }
                    }
                }, bundle = arguments
            )
        }
    }

    /** *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun addressList() {
        val apiRequest = ApiRequest()
        showLoader()
        doctorViewModel.addressList(apiRequest)
    }

    private fun deleteAddress(addressId: String) {
        val apiRequest = ApiRequest().apply {
            address_id = addressId
        }
        showLoader()
        doctorViewModel.deleteAddress(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //addressListLiveData
        doctorViewModel.addressListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                handleOnAddressListResponse(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                handleOnAddressListResponse(null, throwable.message ?: "")
                false
            })

        //deleteAddressLiveData
        doctorViewModel.deleteAddressLiveData.observe(this,
            onChange = { responseBody ->
                analytics.logEvent(analytics.LABTEST_ADDRESS_DELETED, Bundle().apply {
                    putString(
                        analytics.PARAM_ADDRESS_ID,
                        addressList[currentClickPos].patient_address_rel_id
                    )
                }, screenName = AnalyticsScreenNames.SelectAddress)
                if (selectAddressAdapter.selectionPos == currentClickPos) {
                    selectAddressAdapter.selectionPos = -1
                }
                addressList()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}