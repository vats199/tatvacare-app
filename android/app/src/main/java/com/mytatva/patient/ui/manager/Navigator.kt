package com.mytatva.patient.ui.manager

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment


/**
 * Created by hlink21 on 29/5/17.
 */

interface Navigator {

    fun <T : BaseFragment<*>> load(tClass: Class<T>): FragmentActionPerformer<T>

    fun loadActivity(aClass: Class<out BaseActivity>): ActivityBuilder

    fun <T : BaseFragment<*>> loadActivity(
        aClass: Class<out BaseActivity>,
        pageTClass: Class<T>
    ): ActivityBuilder

    fun goBack()

    fun finish()

    fun pickDate(listener: DatePickerDialog.OnDateSetListener, minimumDate: Long, maximumDate: Long)

    fun pickTime(onTimeSetListener: TimePickerDialog.OnTimeSetListener, is24Hour: Boolean)

    fun showAlertDialog(
        message: String,
        neutralText: String = "Ok",
        dialogOkListener: BaseActivity.DialogOkListener? = null
    )

    fun showAlertDialogWithOptions(
        message: String,
        positiveText: String = "Yes",
        negativeText: String = "No",
        dialogYesNoListener: BaseActivity.DialogYesNoListener? = null
    )

    fun showImageViewerDialog(imageLis: ArrayList<String>, position: Int = 0)

    fun openPdfViewer(certificate: String, isLocalFile: Boolean = false)
}