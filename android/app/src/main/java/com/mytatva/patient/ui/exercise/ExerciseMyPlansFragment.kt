package com.mytatva.patient.ui.exercise

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.CoachMarkPage
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.ExercisePlanData
import com.mytatva.patient.databinding.ExerciseFragmentMyPlansBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.adapter.ExerciseMyPlansAdapter
import com.mytatva.patient.ui.exercise.adapter.ExerciseMyPlansSubAdapter
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import smartdevelop.ir.eram.showcaseviewlib.GuideView
import smartdevelop.ir.eram.showcaseviewlib.config.Gravity
import smartdevelop.ir.eram.showcaseviewlib.listener.GuideListener
import java.util.*
import java.util.concurrent.TimeUnit

class ExerciseMyPlansFragment : BaseFragment<ExerciseFragmentMyPlansBinding>() {

    private val planList = arrayListOf<ExercisePlanData>()

    private val exerciseMyPlansAdapter by lazy {
        ExerciseMyPlansAdapter(planList,
            object : ExerciseMyPlansAdapter.AdapterListener {
                override fun onItemClick(position: Int) {

                    analytics.logEvent(analytics.USER_CLICKED_ON_PLAN_EXERCISE, Bundle().apply {
                        putString(analytics.PARAM_CONTENT_MASTER_ID,
                            planList[position].content_master_id)
                        putString(analytics.PARAM_CONTENT_TYPE,
                            planList[position].content_type)
                    }, screenName = AnalyticsScreenNames.ExercisePlan)

                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        ExercisePlanDetailsFragment::class.java).addBundle(bundleOf(
                        Pair(Common.BundleKey.TITLE, planList[position].title),
                        Pair(Common.BundleKey.CONTENT_ID, planList[position].content_master_id)
                    )).start()
                }
            }, object : ExerciseMyPlansSubAdapter.AdapterListener {
                override fun onItemClick(mainPosition: Int, position: Int) {

                    analytics.logEvent(analytics.USER_CLICKED_ON_PLAN_EXERCISE, Bundle().apply {
                        putString(analytics.PARAM_CONTENT_MASTER_ID,
                            planList[mainPosition].content_master_id)
                        putString(analytics.PARAM_CONTENT_TYPE,
                            planList[mainPosition].content_type)
                    }, screenName = AnalyticsScreenNames.ExercisePlan)

                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        ExercisePlanDetailsFragment::class.java).addBundle(bundleOf(
                        Pair(Common.BundleKey.TITLE, planList[mainPosition].title),
                        Pair(Common.BundleKey.CONTENT_ID, planList[mainPosition].content_master_id)
                    )).start()

                }
            })
    }

    //pagination params
    var page = 1
    internal var isLoading = false
    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null

    var isLastPage: Boolean = false

    fun resetPagingData() {
        isLoading = false
        page = 1
        previousTotal = 0

        isLastPage = false
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
    ): ExerciseFragmentMyPlansBinding {
        return ExerciseFragmentMyPlansBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onResume() {
        super.onResume()
        if (isAdded && (requireActivity() as HomeActivity).binding.layoutExercise.isSelected) {
            analytics.setScreenName(AnalyticsScreenNames.ExercisePlan)
            resetPagingData()
            exercisePlanList()

            resumedTime = Calendar.getInstance().timeInMillis
        }
    }

    override fun onPause() {
        super.onPause()
        if (isAdded && (requireActivity() as HomeActivity).binding.layoutExercise.isSelected) {
            updateScreenTimeDurationInAnalytics()
        }
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_MY_ROUTINE, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        },AnalyticsScreenNames.ExercisePlan)
    }

    override fun onShow() {
        super.onShow()
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        with(binding) {
            linearLayoutManager =
                LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            recyclerViewPlans.apply {
                layoutManager = linearLayoutManager
                adapter = exerciseMyPlansAdapter
            }

            /*recyclerViewPlans.addOnScrollListener(object : RecyclerView.OnScrollListener() {
                override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {

                }

                override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                    //pagination
                    val visibleItemCount = recyclerView.childCount
                    val totalItemCount = linearLayoutManager!!.itemCount
                    val pastVisibleItems = linearLayoutManager!!.findFirstVisibleItemPosition()
                    if (isLoading) {
                        if (totalItemCount > previousTotal) {
                            isLoading = false
                            previousTotal = totalItemCount
                        }
                    }
                    if (!isLoading && totalItemCount - visibleItemCount <= pastVisibleItems + 0) {
                        // End has been reached
                        page++
                        exercisePlanList()
                        isLoading = true
                    }
                }
            })*/

            recyclerViewPlans.addOnScrollListener(object :
                PaginationScrollListener(linearLayoutManager!!) {
                override fun isLastPage(): Boolean {
                    return isLastPage
                }

                override fun isLoading(): Boolean {
                    return isLoading
                }

                override fun loadMoreItems() {
                    isLoading = true
                    //you have to call load more items to get more data
                    page++
                    exercisePlanList()
                }

                override fun isScrolledDown(isScrolledDown: Boolean) {

                }
            })
        }
    }

    private fun setViewListeners() {
        with(binding) {
            swipeRefreshLayout.setOnRefreshListener {
                resetPagingData()
                exercisePlanList()
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }

    var onCoachMarkFinish: (() -> Unit)? = null
    fun showCoachMark(onFinish: () -> Unit) {

        if (planList.isNotEmpty()) {

            onCoachMarkFinish = null

            binding.recyclerViewPlans.scrollToPosition(0)

            Handler(Looper.getMainLooper()).postDelayed({

                var mGuideView: GuideView? = null
                var builder: GuideView.Builder? = null
                val targetView = linearLayoutManager?.findViewByPosition(0)
                builder = GuideView.Builder(requireActivity())
                    .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.EXERCISE_MY_PLAN.pageKey))
                    .setButtonText("Next")
                    .setGravity(Gravity.auto)
                    /*.setDismissType(DismissType.outside)*/
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
                mGuideView?.show()

            }, 200)

        } else {
            onCoachMarkFinish = onFinish
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun exercisePlanList() {
        val apiRequest = ApiRequest().apply {
            page = this@ExerciseMyPlansFragment.page.toString()
        }
        binding.swipeRefreshLayout.isRefreshing = page == 1
        engageContentViewModel.exercisePlanList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //exercisePlanListLiveData
        engageContentViewModel.exercisePlanListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                isLoading = false
                if (page == 1) {
                    planList.clear()
                }
                responseBody.data?.let { planList.addAll(it) }
                exerciseMyPlansAdapter.notifyDataSetChanged()

                if (planList.isNotEmpty()) {
                    Handler(Looper.getMainLooper()).postDelayed({
                        onCoachMarkFinish?.let {
                            showCoachMark(it)
                        }
                    }, 200)
                }

                with(binding) {
                    recyclerViewPlans.visibility = View.VISIBLE
                    textViewNoData.visibility = View.GONE
                }
            },
            onError = { throwable ->
                hideLoader()
                binding.swipeRefreshLayout.isRefreshing = false
                isLoading = false
                isLastPage = true
                if (page == 1) {
                    planList.clear()
                    exerciseMyPlansAdapter.notifyDataSetChanged()
                    with(binding) {
                        recyclerViewPlans.visibility = View.GONE
                        textViewNoData.visibility = View.VISIBLE
                        textViewNoData.text = throwable.message
                    }
                }
                false
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

}