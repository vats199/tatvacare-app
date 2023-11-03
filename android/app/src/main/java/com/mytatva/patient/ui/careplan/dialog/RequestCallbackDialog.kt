package com.mytatva.patient.ui.careplan.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.CarePlanDialogRequestCallbackBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.ui.profile.fragment.MyProfileFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.textdecorator.TextDecorator

class RequestCallbackDialog(val callback: () -> Unit) :
    BaseDialogFragment<CarePlanDialogRequestCallbackBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanDialogRequestCallbackBinding {
        return CarePlanDialogRequestCallbackBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.RequestCallBack)
    }

    override fun bindData() {
        setViewListener()
        setUpUI()
    }

    private fun setUpUI() {
        TextDecorator.decorate(binding.textViewHospital,
            "For Ahmedabad based users, check out lab at Zydus Hospital")
            .underline(0, binding.textViewHospital.text.toString().length)
            .build()
    }

    private fun setViewListener() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonRequestCallback.setOnClickListener { onViewClick(it) }
            textViewHospital.setOnClickListener { onViewClick(it) }
            textViewChangeAddress.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewHospital -> {
                RequestCallbackHospitalInfoDialog()
                    .show(requireActivity().supportFragmentManager,
                        RequestCallbackHospitalInfoDialog::class.java.simpleName)
            }
            R.id.buttonRequestCallback -> {
                callback.invoke()
                dismiss()
            }
            R.id.textViewChangeAddress -> {
                (requireActivity() as BaseActivity).loadActivity(IsolatedFullActivity::class.java,
                    MyProfileFragment::class.java)
                    .start()
                dismiss()
            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}