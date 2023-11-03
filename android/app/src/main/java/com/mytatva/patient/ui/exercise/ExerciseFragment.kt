package com.mytatva.patient.ui.exercise

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.viewpager.widget.ViewPager
import com.mytatva.patient.R
import com.mytatva.patient.data.model.CoachMarkPage
import com.mytatva.patient.databinding.ExerciseFragmentExerciseBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.bottomsheet.ExerciseFilterBottomSheetDialog
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import smartdevelop.ir.eram.showcaseviewlib.GuideView
import smartdevelop.ir.eram.showcaseviewlib.listener.GuideListener

class ExerciseFragment : BaseFragment<ExerciseFragmentExerciseBinding>() {

    /*private var viewPagerAdapter: CommonViewPager2Adapter? = null*/
    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val exerciseMyRoutineFragment =
        ExerciseMyRoutineFragment()//ExerciseMyPlansNewFragment() ExerciseMyPlansFragment()
    private val engageMoreFragment = ExerciseMoreFragment()

    private val filterBottomSheetDialog =
        ExerciseFilterBottomSheetDialog { timeList, exerciseToolsList, levelList, genreList ->
            engageMoreFragment.updateFilters(timeList, exerciseToolsList, levelList, genreList)
        }

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
    ): ExerciseFragmentExerciseBinding {
        return ExerciseFragmentExerciseBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onShow() {
        super.onShow()
        setScreenName()
        Handler(Looper.getMainLooper()).postDelayed({
            if (isAdded && isVisible) {
                (viewPagerAdapter?.mFragmentList
                    ?.get(binding.viewPagerExercise.currentItem) as BaseFragment<*>).onShow()
            }
        }, 200)
    }

    private fun setScreenName() {
        if (isAdded) {
            if (binding.viewPagerExercise.currentItem == 0) {
                analytics.setScreenName(AnalyticsScreenNames.ExerciseMyRoutine/*ExercisePlan*/)
            } else {
                analytics.setScreenName(AnalyticsScreenNames.ExerciseMore)
            }
        }
    }

    override fun onResume() {
        super.onResume()
        //setScreenName()
    }

    override fun onPause() {
        super.onPause()
    }

    override fun bindData() {
        setViewListeners()
        setUpToolbar()
        setUpViewPager()
    }

    fun setViewPagerItemPosition(position: Int) {
        if (isAdded) {
            if (viewPagerAdapter?.count ?: 0 > position) {
                binding.viewPagerExercise.currentItem = position
            }
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)

            /*if (session.user?.isNaflOrNashPatient == true) {
                tabLayout.visibility = View.GONE
                //show filter icon when showing only explore page
                layoutHeader.imageViewFilter.visibility = View.VISIBLE
            } else {*/
            viewPagerAdapter?.addFrag(exerciseMyRoutineFragment, "My Routine")
            tabLayout.visibility = View.VISIBLE
            /*}*/

            viewPagerAdapter?.addFrag(engageMoreFragment, "Others")
            viewPagerExercise.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPagerExercise)

            viewPagerExercise.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
                override fun onPageScrolled(
                    position: Int,
                    positionOffset: Float,
                    positionOffsetPixels: Int,
                ) {

                }

                override fun onPageSelected(position: Int) {
                    if (position == 1) {
                        layoutHeader.imageViewFilter.visibility = View.VISIBLE
                    } else {
                        layoutHeader.imageViewFilter.visibility = View.GONE
                    }
                }

                override fun onPageScrollStateChanged(state: Int) {

                }
            })
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "Exercise"
            imageViewNotification.visibility = View.GONE
            imageViewToolbarBack.visibility = View.GONE
            imageViewFilter.setOnClickListener { onViewClick(it) }
            imageViewSearch.visibility = View.GONE
            imageViewSearch.setOnClickListener { onViewClick(it) }
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        with(binding) {

        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewFilter -> {
                activity?.supportFragmentManager?.let {
                    if (filterBottomSheetDialog.isAdded.not())
                        filterBottomSheetDialog.show(it,
                            ExerciseFilterBottomSheetDialog::class.java.simpleName)
                }
            }
            R.id.imageViewSearch -> {

            }
            R.id.imageViewToolbarBack -> {
                //navigator.goBack()
            }
        }
    }

    fun showCoachMark(onFinish: () -> Unit) {
        binding.viewPagerExercise.currentItem = 0

        if (viewPagerAdapter?.count ?: 0 > 1) {
            // check condition if both tabs are visible

            // show coach-mark with targeting tab view
            var mGuideView: GuideView? = null
            var builder: GuideView.Builder? = null
            val targetView = binding.tabLayout.getTabAt(0)?.view
            builder = GuideView.Builder(requireActivity())
                .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.EXERCISE_MY_PLAN.pageKey))
                .setButtonText("Next")
                .setTargetView(targetView)
                .setGuideListener(object : GuideListener {
                    override fun onDismiss(view: View?) {
                    }

                    override fun onSkip() {
                        showSkipCoachMarkMessage()
                    }

                    override fun onNext(view: View) {
                        when (view.id) {
                            targetView?.id -> {
                                binding.viewPagerExercise.currentItem = 1
                                engageMoreFragment.showCoachMark {
                                    onFinish.invoke()
                                }
                            }
                        }
                    }
                })
            mGuideView = builder?.build()
            mGuideView?.show()


            /*exerciseMyRoutineFragment.showCoachMark {

                binding.viewPagerExercise.currentItem = 1
                engageMoreFragment.showCoachMark {
                    onFinish.invoke()
                }

                // show coach-mark with targeting tab view
                *//*var mGuideView: GuideView? = null
                var builder: GuideView.Builder? = null
                val targetView = binding.tabLayout.getTabAt(1)?.view
                builder = GuideView.Builder(requireActivity())
                    .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.EXERCISE_EXPLORE.pageKey))
                    .setButtonText("Next")
                    .setTargetView(targetView)
                    .setGuideListener(object : GuideListener {
                        override fun onDismiss(view: View?) {
                        }

                        override fun onSkip() {
                            showSkipCoachMarkMessage()
                        }

                        override fun onNext(view: View) {
                            when (view.id) {
                                targetView?.id -> {
                                    onFinish.invoke()
                                }
                            }
                        }
                    })
                mGuideView = builder?.build()
                mGuideView?.show()*//*

            }*/

        } else {
            engageMoreFragment.showCoachMark {
                onFinish.invoke()
            }
            //onFinish.invoke()
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