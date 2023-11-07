package com.mytatva.patient.ui.profile.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.databinding.ProfileFragmentDoctorProfileBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class DoctorProfileFragment : BaseFragment<ProfileFragmentDoctorProfileBinding>() {

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
        attachToRoot: Boolean
    ): ProfileFragmentDoctorProfileBinding {
        return ProfileFragmentDoctorProfileBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.DoctorProfile)
    }

    override fun bindData() {
        setUpToolbar()
        setViewListeners()
        setDoctorDetails()
    }

    private fun setDoctorDetails() {
        with(binding) {
//            imageViewProfile.loadCircle()
//            textViewName.text=""
//            textViewDegree.text=""
//            textViewExperience.text=""
//            textViewMobileNumber.text=""
//            textViewLanguagesSpoken.text=""
//            textViewLabelHospitalName.text=""
//            textViewHospitalAddress.text=""
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            buttonBookAppointment.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.buttonBookAppointment -> {
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
}