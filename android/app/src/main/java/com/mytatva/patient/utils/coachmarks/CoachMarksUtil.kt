package com.mytatva.patient.utils.coachmarks

import android.content.Context
import com.mytatva.patient.core.Session
import com.mytatva.patient.ui.base.BaseActivity
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class CoachMarksUtil @Inject constructor(val context: Context, val session: Session) {

    companion object {

    }

    var activity: BaseActivity? = null
    private val TAG = CoachMarksUtil::class.java.simpleName

    /*fun start(callbackNext: (() -> Unit)? = null) {
        (activity as HomeActivity).apply {
            StartCoachMarkDialog { isSkip ->
                if (isSkip.not()) {
                    *//*callbackNext.invoke()*//*
                    if (homeHandler?.homeFragment?.isAdded == true && homeHandler?.homeFragment?.isVisible == true) {
                        homeHandler?.homeFragment?.showCoachMark {
                            goToCarePlan()
                        }
                    }
                }
            }.show(activity?.supportFragmentManager!!, StartCoachMarkDialog::class.java.simpleName)
        }
    }

    private fun goToCarePlan() {
        (activity as HomeActivity).apply {
            binding.layoutCarePlan.callOnClick()
            if (homeHandler?.carePlanFragment?.isAdded == true && homeHandler?.carePlanFragment?.isVisible == true) {
                homeHandler?.carePlanFragment?.showCoachMark {
                }
            }
        }
    }*/

}