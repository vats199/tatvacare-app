package com.mytatva.patient.ui.goal.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.viewpager.widget.ViewPager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.databinding.GoalFragmentFoodDiaryMainBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*

class FoodDiaryMainFragment : BaseFragment<GoalFragmentFoodDiaryMainBinding>() {

    private val pagerPosition by lazy {
        arguments?.getInt(Common.BundleKey.POSITION) ?: 0
    }

    /*private var viewPagerAdapter: CommonViewPager2Adapter? = null*/
    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val foodDiaryDayFragment = FoodDiaryDayFragment()
    private val foodDiaryMonthFragment = FoodDiaryMonthFragment()

    private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): GoalFragmentFoodDiaryMainBinding {
        return GoalFragmentFoodDiaryMainBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setViewListeners()
        setUpToolbar()
        setUpViewPager()
    }

    fun showFoodDiaryDayWithDate(date: Date) {
        if (isAdded) {
            with(binding) {
                foodDiaryDayFragment.selectedDate = date
                viewPager.currentItem = 0
            }
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)
            viewPagerAdapter?.addFrag(foodDiaryDayFragment, getString(R.string.food_dairy_tab_day))
            viewPagerAdapter?.addFrag(foodDiaryMonthFragment,
                getString(R.string.food_dairy_tab_month))
            viewPager.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPager)

            viewPager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
                override fun onPageScrolled(
                    position: Int,
                    positionOffset: Float,
                    positionOffsetPixels: Int,
                ) {

                }

                override fun onPageSelected(position: Int) {
                    if (position == 1) {
                        analytics.logEvent(analytics.USER_CLICKED_ON_MONTHLY_INSIGHT,
                        screenName = AnalyticsScreenNames.FoodDiaryDay)
                    }
                }

                override fun onPageScrollStateChanged(state: Int) {

                }
            })

            if (pagerPosition > 0) {
                viewPager.currentItem = pagerPosition
            }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.food_dairy_title_food_diary)
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        with(binding) {

        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
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

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

}