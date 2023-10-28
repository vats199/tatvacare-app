package com.mytatva.patient.ui.activity

import android.os.Bundle
import android.view.View
import android.view.ViewTreeObserver
import com.mytatva.patient.R
import com.mytatva.patient.databinding.TransparentAcitivtyBinding
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.manager.ActivityStarter

class TransparentActivity : BaseActivity() {

    lateinit var transparentAcitivtyBinding: TransparentAcitivtyBinding

    override fun findFragmentPlaceHolder(): Int {
        return R.id.placeHolder
    }

    override fun createViewBinding(): View {
        transparentAcitivtyBinding = TransparentAcitivtyBinding.inflate(layoutInflater)
        return transparentAcitivtyBinding.root
    }

    override fun inject(activityComponent: ActivityComponent) {
        activityComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //ActivityCompat.postponeEnterTransition(this)
        if (savedInstanceState == null && intent.hasExtra(ActivityStarter.ACTIVITY_FIRST_PAGE)) {
            val page =
                intent.getSerializableExtra(ActivityStarter.ACTIVITY_FIRST_PAGE) as Class<BaseFragment<*>>
            load(page)
                .setBundle(intent.extras!!)
                .replace(false)
        }
    }

    fun scheduleStartPostponedTransition(sharedElement: View) {
        sharedElement.viewTreeObserver.addOnPreDrawListener(
            object : ViewTreeObserver.OnPreDrawListener {
                override fun onPreDraw(): Boolean {
                    sharedElement.viewTreeObserver.removeOnPreDrawListener(this)
                    startPostponedEnterTransition()
                    return true
                }
            })
    }
}