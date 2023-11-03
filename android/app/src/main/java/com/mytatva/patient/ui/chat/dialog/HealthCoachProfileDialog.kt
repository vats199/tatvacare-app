package com.mytatva.patient.ui.chat.dialog

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.databinding.ChatDialogHealthcoachProfileBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.imagepicker.loadUrlWithOverride

class HealthCoachProfileDialog(val healthCoachData: HealthCoachData) :
    BaseDialogFragment<ChatDialogHealthcoachProfileBinding>() {

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ChatDialogHealthcoachProfileBinding {
        return ChatDialogHealthcoachProfileBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
    }

    override fun bindData() {
        setViewListener()

        healthCoachData.let {
            with(binding) {
                imageViewProfile.loadUrlWithOverride(it.profile_pic ?: "", 180)
                textViewName.text = it.first_name.plus(" ").plus(it.last_name)
                textViewDescription.text = it.role
                textViewExperience.text = it.years_of_experience.plus(" ").plus(getString(R.string.halthcoach_profile_label_yrs_of_experience))
                textViewHospital.text = it.city
                textViewAddress.text = it.state
                /*textViewHospital.text = it.institute
                textViewAddress.text = it.city.plus(", ").plus(it.state)*/
                textViewContact.text = it.contact_no
                textViewLanguage.text = it.language_spoken
            }
        }
    }

    private fun setViewListener() {
        binding.apply {
            textViewContact.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewContact -> {
                /*if (binding.textViewContact.text.toString().trim().isNotBlank()) {
                    requireActivity().openDialer(binding.textViewContact.text.toString().trim())
                }*/
            }
            R.id.imageViewClose -> {
                dismiss()
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
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {

    }

}