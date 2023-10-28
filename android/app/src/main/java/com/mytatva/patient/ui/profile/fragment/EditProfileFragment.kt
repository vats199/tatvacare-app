package com.mytatva.patient.ui.profile.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.ProfileFragmentEditProfileBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.azure.UploadToAzureStorage
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.ImageAndVideoPicker
import com.mytatva.patient.utils.imagepicker.loadCircle
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*


class EditProfileFragment : BaseFragment<ProfileFragmentEditProfileBinding>() {

    companion object {
        var isProfilePicUpdated = false
    }

    var calDob: Calendar? = null
    var selectedProfileImage: String? = null

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
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
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
    ): ProfileFragmentEditProfileBinding {
        return ProfileFragmentEditProfileBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.EditProfile)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpToolbar()
        setViewListeners()
        setUserData()
    }

    private fun setUserData() {
        with(binding) {
            session.user?.let {
                imageViewProfile.loadCircle(it.profile_pic ?: "")
                editTextName.setText(it.name)
                editTextEmail.setText(it.email)
                try {
                    editTextDOB.setText(DateTimeFormatter
                        .date(it.dob, DateTimeFormatter.FORMAT_yyyyMMdd)
                        .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE))
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.edit_profile_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewEditPhoto.setOnClickListener { onViewClick(it) }
            imageViewProfile.setOnClickListener { onViewClick(it) }
            /*editTextDOB.setOnClickListener { onViewClick(it) }*/
            buttonUpdate.setOnClickListener { onViewClick(it) }

            //editTextName.dontAllowAsPrefix(".")
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.imageViewProfile -> {
                showImagePicker()
            }
            R.id.imageViewEditPhoto -> {
                showImagePicker()
            }
            R.id.editTextDOB -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->
                    calDob = Calendar.getInstance()
                    calDob?.set(year, month, dayOfMonth)
                    binding.editTextDOB.setText(
                        DateTimeFormatter.date(calDob!!.time)
                            .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
                    )
                }, 0L, Calendar.getInstance().apply { add(Calendar.YEAR, -18) }.timeInMillis)
            }
            R.id.buttonUpdate -> {
                if (isValid) {
                    if (selectedProfileImage.isNullOrBlank()) {
                        updateProfile()
                    } else {
                        uploadImageAndCallAPI()
                    }
                }
            }
        }
    }

    private fun showImagePicker() {
        ImageAndVideoPicker.newInstance()
            .pickImage(true) // set true to pick image, default false
            .pickVideo(false) // set true to pick video, default false
            .pickDocument(false) // set true to pick docs, default false
            //.allowMultiple() // to allow multiple selection, default single selection
            .setResult(imagePickerResult = object : ImageAndVideoPicker.ImageVideoPickerResult() {
                override fun onFail(message: String) {
                    showMessage(message)
                }

                override fun onImagesSelected(list: ArrayList<String>) {
                    if (ImageAndVideoPicker.isValidFileSize(list.first())) {
                        selectedProfileImage = list.first()
                        binding.imageViewProfile.loadCircle(list.first())
                    } else {
                        showMessage(getString(R.string.validation_invalid_file_size))
                    }
                }
            }).show(childFragmentManager, ImageAndVideoPicker::class.java.name)
    }

    private fun uploadImageAndCallAPI() {
        val fileName = UploadToAzureStorage.PREFIX_USER + "$createFileName.jpg"
        showLoader()
        UploadToAzureStorage().uploadImage(
            this,
            selectedProfileImage!!,
            UploadToAzureStorage.AZURE_CONTAINER,
            fileName,
            success = {
                //hideLoader()
                updateProfile(fileName)
                //showMessage("Uploaded")
            },
            failure = {
                hideLoader()
                showMessage(it)
            })
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateProfile(imageName: String? = null) {
        if (imageName.isNullOrBlank().not()) {
            isProfilePicUpdated = true
        }else{
            showLoader()
        }
        val apiRequest = ApiRequest().apply {
            profile_pic = imageName
            calDob?.let {
                dob = DateTimeFormatter.date(it.time)
                    .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
            }
            email = binding.editTextEmail.text.toString().trim()
            name = binding.editTextName.text.toString().trim()
        }
        authViewModel.updateProfile(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updateProfileLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                showMessage(responseBody.message)
                ContextHolder.reactContext?.let { sendEventToRN(it,"profileUpdatedSuccess","") }
                Handler(Looper.getMainLooper()).postDelayed({
                    navigator.goBack()
                },1000)
                /*navigator.showAlertDialog(responseBody.message,
                    dialogOkListener = object : BaseActivity.DialogOkListener {
                        override fun onClick() {
                            navigator.goBack()
                        }
                    })*/
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}