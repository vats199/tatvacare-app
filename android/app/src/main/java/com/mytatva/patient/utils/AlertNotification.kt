package com.mytatva.patient.utils

import android.app.Activity
import android.app.Dialog
import androidx.annotation.ColorRes
import androidx.core.content.res.ResourcesCompat
import androidx.fragment.app.DialogFragment
import com.mytatva.patient.R
import com.mytatva.patient.ui.base.BaseActivity
import com.tapadoo.alerter.Alerter


/**
 *
 */
enum class AppMsgStatus(@ColorRes val color:Int){
    SUCCESS(R.color.colorDarkGreen1),
    ERROR(R.color.redError),
    DEFAULT(R.color.colorPrimary)
}
object AlertNotification {

    fun showAppMessage(activity: Activity, text: String, status:AppMsgStatus=AppMsgStatus.DEFAULT) {
        Alerter.create(activity)
            .setText(text)
            .setDuration(8000)
            .setTextTypeface(ResourcesCompat.getFont(activity, R.font.sf_medium)!!)
            .setBackgroundColorRes(status.color)
            .hideIcon()
            .show()
    }

    fun showAppDialogMessage(dialog: Dialog, text: String, status:AppMsgStatus=AppMsgStatus.DEFAULT) {
        Alerter.create(dialog)
            .setText(text)
            .setDuration(8000)
            .setTextTypeface(ResourcesCompat.getFont(dialog.context, R.font.sf_medium)!!)
            .setBackgroundColorRes(status.color)
            .hideIcon()
            .show()
    }

    /**
     *
     */
    fun showMessage(activity: BaseActivity, text: String) {
        Alerter.create(activity)
            .setText(text)
            .setDuration(8000)
            .setTextTypeface(ResourcesCompat.getFont(activity, R.font.sf_medium)!!)
            .setBackgroundColorRes(R.color.colorPrimary)
            .hideIcon()
            .show()
    }

    /**
     *
     */
    fun showSuccessMessage(activity: DialogFragment, text: String) {
        Alerter.create(activity.requireDialog())
            .setText(text)
            .setDuration(1000)
            .setTextTypeface(ResourcesCompat.getFont(activity.requireActivity(),
                R.font.sf_medium)!!)
            //.setBackgroundColorRes(R.color.colorPrimary)
            .setBackgroundResource(R.drawable.bg_alerter_dialog)
            .hideIcon()
            .show()
    }

}