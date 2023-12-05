package com.mytatva.patient.ui.auth.fragment.v2

import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayout.OnTabSelectedListener
import com.google.android.material.tabs.TabLayoutMediator
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.SignUpOnboardingData
import com.mytatva.patient.databinding.AuthV2FragmentWalkThroughBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.auth.adapter.v2.WalkThroughItemAdapter
import com.mytatva.patient.ui.auth.bottomsheet.v2.LoginWithOtpBottomSheet
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.Timer
import java.util.TimerTask

class WalkThroughFragment : BaseFragment<AuthV2FragmentWalkThroughBinding>() {

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private var arrayList: ArrayList<SignUpOnboardingData> = arrayListOf()
    private var timer: Timer? = null

    private val DELAY_MS: Long = 5000 //delay in milliseconds before task is to be executed
    private val PERIOD_MS: Long = 5000 // time in milliseconds between successive task executions.

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthV2FragmentWalkThroughBinding {
        return AuthV2FragmentWalkThroughBinding.inflate(layoutInflater)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.Walkthrough)
        startAutoScrollTimer()
    }

    override fun bindData() {
        if (appPreferences.onBoardingList.isNullOrEmpty().not()) {
            appPreferences.onBoardingList?.let {
                arrayList.clear()
                arrayList.addAll(it)
                setViewPagerTabLayout()
            }
        } else {
            authViewModel.onBordingSignUp()
        }

        if (appPreferences.isToOpenLoginStep()) {
            openLoginDialog()
        }
        //setAdjustPan()
        setupViewListeners()
    }

    private fun setupViewListeners() {
        binding.buttonGetStart.setOnClickListener {
            onViewClick(it)
        }
    }

    private fun openLoginDialog() {
        val loginBottomSheet = LoginWithOtpBottomSheet().setCallback(onClick = {}, onShow = {
            if (timer != null) {
                timer?.cancel()
                timer?.purge()
                timer = null
            }
        }, onDismiss = {
            startAutoScrollTimer()
        })
        loginBottomSheet.show(
            requireActivity().supportFragmentManager,
            LoginWithOtpBottomSheet::class.java.simpleName
        )
    }

    override fun onViewClick(view: View) {
        super.onViewClick(view)
        when (view.id) {
            R.id.buttonGetStart -> {
                analytics.logEvent(
                    analytics.NEW_USER_SIGNUP_ATTEMPT,
                    Bundle().apply {
                        putInt(analytics.PARAM_CAROUSEL_NUMBER, binding.viewPager2.currentItem + 1)
                        putString(
                            analytics.PARAM_AUTO_FLAG,
                            if (isTabAutoScrolledLast) "on" else "off"
                        )
                    },
                    screenName = AnalyticsScreenNames.Walkthrough
                )
                openLoginDialog()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            (requireActivity() as BaseActivity).checkNotificationPermission()
        }
    }

    private var isTabAutoScrolledLast = false // to indicate last scrolled was auto or manually
    private var currentTabPosition = 0
    private fun setViewPagerTabLayout() = with(binding)
    {
        groupOfWalkThrough.isVisible = true
        imageViewLogo.isVisible = false
        viewPager2.adapter = WalkThroughItemAdapter(arrayList)
        TabLayoutMediator(tabLayout, viewPager2) { _, _ ->
        }.attach()
        startAutoScrollTimer()
        tabLayout.addOnTabSelectedListener(object : OnTabSelectedListener {
            override fun onTabSelected(tab: TabLayout.Tab?) {
                tab?.let {
                    val prevPosition = currentTabPosition
                    currentTabPosition = tab.position
                    analytics.logEvent(
                        analytics.PRE_ONBOARDING_CAROUSEL,
                        Bundle().apply {
                            putInt(analytics.PARAM_CHANGED_FROM, prevPosition + 1)
                            putInt(analytics.PARAM_CHANGES_TO, currentTabPosition + 1)
                        }, screenName = AnalyticsScreenNames.Walkthrough
                    )

                    if (isTabSelectedProgrammatically) {
                        // when it's auto scrolled
                        isTabSelectedProgrammatically = false
                        isTabAutoScrolledLast = true
                    } else {
                        // when it's scrolled manually by user
                        isTabAutoScrolledLast = false
                    }

                }
            }

            override fun onTabUnselected(tab: TabLayout.Tab?) {

            }

            override fun onTabReselected(tab: TabLayout.Tab?) {

            }
        })
    }

    private var isTabSelectedProgrammatically = false
    private fun startAutoScrollTimer() {
        if (arrayList.size > 1) {
            /*After setting the adapter use the timer */
            val handler = Handler(Looper.getMainLooper())
            val update = Runnable {
                if (binding != null) {
                    isTabSelectedProgrammatically = true
                    binding.viewPager2.currentItem =
                        if (binding.viewPager2.currentItem == arrayList.size - 1) 0 else binding.viewPager2.currentItem + 1
                }
            }
            val timerTask = object : TimerTask() {
                override fun run() {
                    handler.post(update);
                }
            }

            if (timer == null) {
                timer = Timer()
                timer?.schedule(timerTask, DELAY_MS, PERIOD_MS)
            }
        }
    }

    override fun onPause() {
        super.onPause()
        if (timer != null) {
            timer?.cancel()
            timer = null
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (timer != null) {
            timer?.cancel()
            timer = null
        }
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.onBordingSignUpLiveData.observe(this, onChange = { responseBody ->
            responseBody.data?.let {
                appPreferences.onBoardingList = it
                arrayList.clear()
                arrayList.addAll(it)
                setViewPagerTabLayout()
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })
    }
}

/*
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayout.OnTabSelectedListener
import com.google.android.material.tabs.TabLayoutMediator
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.SignUpOnboardingData
import com.mytatva.patient.databinding.AuthV2FragmentWalkThroughBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.auth.adapter.v2.WalkThroughItemAdapter
import com.mytatva.patient.ui.auth.bottomsheet.v2.LoginWithOtpBottomSheet
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.Timer
import java.util.TimerTask

class WalkThroughFragment : BaseFragment<AuthV2FragmentWalkThroughBinding>() {

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private var arrayList: ArrayList<SignUpOnboardingData> = arrayListOf()
    private var timer: Timer? = null

    private val DELAY_MS: Long = 5000 //delay in milliseconds before task is to be executed
    private val PERIOD_MS: Long = 5000 // time in milliseconds between successive task executions.

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthV2FragmentWalkThroughBinding {
        return AuthV2FragmentWalkThroughBinding.inflate(layoutInflater)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.Walkthrough)
        startAutoScrollTimer()
    }

    override fun bindData() {
        if (appPreferences.onBoardingList.isNullOrEmpty().not()) {
            appPreferences.onBoardingList?.let {
                arrayList.clear()
                arrayList.addAll(it)
                setViewPagerTabLayout()
            }
        } else {
            authViewModel.onBordingSignUp()
        }

        if (appPreferences.isToOpenLoginStep()) {
            openLoginDialog()
        }
        //setAdjustPan()
        setupViewListeners()
    }

    private fun setupViewListeners() {
        binding.buttonGetStart.setOnClickListener {
            onViewClick(it)
        }
    }

    private fun openLoginDialog() {
        val loginBottomSheet = LoginWithOtpBottomSheet().setCallback(onClick = {

            appPreferences.setToOpenLoginStep(false)
            navigator.loadActivity(
                AuthActivity::class.java,
                OTPVerificationFragment::class.java
            ).addBundle(it).start()

        }, onShow = {
            if (timer != null) {
                timer?.cancel()
                timer?.purge()
                timer = null
            }
        }, onDismiss = {
            startAutoScrollTimer()
        })
        loginBottomSheet.show(
            requireActivity().supportFragmentManager,
            LoginWithOtpBottomSheet::class.java.simpleName
        )
    }

    override fun onViewClick(view: View) {
        super.onViewClick(view)
        when (view.id) {
            R.id.buttonGetStart -> {
                analytics.logEvent(
                    analytics.NEW_USER_SIGNUP_ATTEMPT,
                    Bundle().apply {
                        putInt(analytics.PARAM_CAROUSEL_NUMBER, binding.viewPager2.currentItem + 1)
                        putString(
                            analytics.PARAM_AUTO_FLAG,
                            if (isTabAutoScrolledLast) "on" else "off"
                        )
                    },
                    screenName = AnalyticsScreenNames.Walkthrough
                )
                openLoginDialog()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    private var isTabAutoScrolledLast = false // to indicate last scrolled was auto or manually
    private var currentTabPosition = 0
    private fun setViewPagerTabLayout() = with(binding)
    {
        groupOfWalkThrough.isVisible = true
        imageViewLogo.isVisible = false
        viewPager2.adapter = WalkThroughItemAdapter(arrayList)
        TabLayoutMediator(tabLayout, viewPager2) { _, _ ->
        }.attach()
        startAutoScrollTimer()
        tabLayout.addOnTabSelectedListener(object : OnTabSelectedListener {
            override fun onTabSelected(tab: TabLayout.Tab?) {
                tab?.let {
                    val prevPosition = currentTabPosition
                    currentTabPosition = tab.position
                    analytics.logEvent(
                        analytics.PRE_ONBOARDING_CAROUSEL,
                        Bundle().apply {
                            putInt(analytics.PARAM_CHANGED_FROM, prevPosition + 1)
                            putInt(analytics.PARAM_CHANGES_TO, currentTabPosition + 1)
                        }, screenName = AnalyticsScreenNames.Walkthrough
                    )

                    if (isTabSelectedProgrammatically) {
                        // when it's auto scrolled
                        isTabSelectedProgrammatically = false
                        isTabAutoScrolledLast = true
                    } else {
                        // when it's scrolled manually by user
                        isTabAutoScrolledLast = false
                    }

                }
            }

            override fun onTabUnselected(tab: TabLayout.Tab?) {

            }

            override fun onTabReselected(tab: TabLayout.Tab?) {

            }
        })
    }

    private var isTabSelectedProgrammatically = false
    private fun startAutoScrollTimer() {
        if (arrayList.size > 1) {
            */
/*After setting the adapter use the timer *//*

            val handler = Handler(Looper.getMainLooper())
            val update = Runnable {
                if (binding != null) {
                    isTabSelectedProgrammatically = true
                    binding.viewPager2.currentItem =
                        if (binding.viewPager2.currentItem == arrayList.size - 1) 0 else binding.viewPager2.currentItem + 1
                }
            }
            val timerTask = object : TimerTask() {
                override fun run() {
                    handler.post(update);
                }
            }

            if (timer == null) {
                timer = Timer()
                timer?.schedule(timerTask, DELAY_MS, PERIOD_MS)
            }
        }
    }

    override fun onPause() {
        super.onPause()
        if (timer != null) {
            timer?.cancel()
            timer = null
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (timer != null) {
            timer?.cancel()
            timer = null
        }
    }

    */
/**
 * *****************************************************
 * LiveData observers API Response
 * *****************************************************
 **//*

    private fun observeLiveData() {
        authViewModel.onBordingSignUpLiveData.observe(this, onChange = { responseBody ->
            responseBody.data?.let {
                appPreferences.onBoardingList = it
                arrayList.clear()
                arrayList.addAll(it)
                setViewPagerTabLayout()
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })
    }
}*/
