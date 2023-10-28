package com.mytatva.patient.ui.labtest.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.LabtestFragmentAddPatientDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class AddPatientDetailsFragment : BaseFragment<LabtestFragmentAddPatientDetailsBinding>() {

    //var resumedTime = Calendar.getInstance().timeInMillis

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextName)
                        .checkEmpty().errorMessage(getString(R.string.common_validation_empty_name))
                        .matchPatter(Common.NAME_PATTERN)
                        .errorMessage(getString(R.string.validation_valid_name))
                        .check()

                    validator.submit(editTextEmail)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_email))
                        .checkValidEmail()
                        .errorMessage(getString(R.string.common_validation_invalid_email))
                        .check()

                    validator.submit(editTextAge)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_age))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
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
    ): LabtestFragmentAddPatientDetailsBinding {
        return LabtestFragmentAddPatientDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AddPatientDetails)
        //resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        setUpUI()
    }

    private fun setUpUI() {
        with(binding) {
            textViewLabelRelationDisclaimer.text =
                getString(R.string.add_patient_label_relation_disclaimer)
                    .plus(" ").plus(session.user?.name ?: "")
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            editTextRelation.setOnClickListener { onViewClick(it) }
            buttonSave.setOnClickListener { onViewClick(it) }
            //editTextName.dontAllowAsPrefix(".")
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.add_patient_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.editTextRelation -> {
                showRelationSelection()
            }
            R.id.buttonSave -> {
                if (isValid) {
                    updatePatientMembers()
                }
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    private fun showRelationSelection() {
        BottomSheet<String>().showBottomSheetDialog(requireActivity(),
            ArrayList(resources.getStringArray(R.array.relations).toList()), "",
            object : BottomSheetAdapter.ItemListener<String> {
                override fun onItemClick(item: String, position: Int) {
                    binding.editTextRelation.setText(item)
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<String>.MyViewHolder,
                    position: Int,
                    item: String,
                ) {
                    holder.textView.text = item
                }
            })
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updatePatientMembers() {
        val apiRequest = ApiRequest().apply {
            member_id = null //for edit
            name = binding.editTextName.text.toString().trim()
            email = binding.editTextEmail.text.toString().trim()
            relation = binding.editTextRelation.text.toString().trim()
            age = binding.editTextAge.text.toString().trim()
            gender =
                if (binding.radioMale.isChecked)
                    getString(R.string.add_patient_label_male)
                else if (binding.radioFemale.isChecked)
                    getString(R.string.add_patient_label_female)
                else
                    getString(R.string.add_patient_label_other)
            indication = null // optional
        }
        showLoader()
        doctorViewModel.updatePatientMembers(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //updatePatientMembersLiveData
        doctorViewModel.updatePatientMembersLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.LABTEST_PATIENT_ADDED,
                    screenName = AnalyticsScreenNames.AddPatientDetails)
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
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