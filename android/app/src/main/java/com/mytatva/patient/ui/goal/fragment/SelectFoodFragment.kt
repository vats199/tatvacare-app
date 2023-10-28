package com.mytatva.patient.ui.goal.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.Editable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.core.widget.addTextChangedListener
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.FoodItemData
import com.mytatva.patient.databinding.GoalFragmentSelectFoodBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.SelectFoodAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import kotlinx.coroutines.*


class SelectFoodFragment : BaseFragment<GoalFragmentSelectFoodBinding>() {

    //pagination params
    var page = 1
    internal var isLoading = false
    var isLastPage: Boolean = false
    internal var previousTotal = 0
    var linearLayoutManager: LinearLayoutManager? = null

    fun resetPagingData() {
        isLoading = true
        page = 1
        previousTotal = 0

        isLastPage = false
    }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    private val searchFoodList = arrayListOf<FoodItemData>()

    private val selectFoodAdapter by lazy {
        SelectFoodAdapter(searchFoodList, requireActivity(),
            object : SelectFoodAdapter.AdapterListener {
                override fun onAddClick(position: Int) {
                    onItemSelect(position)
                }
            })
    }

    private fun onItemSelect(position: Int) {
        val intent = Intent()
        intent.putExtra(Common.BundleKey.SELECTED_FOOD_DATA, searchFoodList[position])
        requireActivity().setResult(Activity.RESULT_OK, intent)
        requireActivity().finish()
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): GoalFragmentSelectFoodBinding {
        return GoalFragmentSelectFoodBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SearchFood)
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()
        Handler(Looper.getMainLooper()).postDelayed({
            binding.editTextSearch.requestFocus()
            showKeyBoard()
        }, 200)
    }

    private fun setUpRecyclerView() {
        binding.apply {
            linearLayoutManager =
                LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            recyclerView.apply {
                layoutManager = linearLayoutManager
                adapter = selectFoodAdapter
            }

            recyclerView.addOnScrollListener(object :
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
                    searchFood(editTextSearch.text.toString().trim())
                }

                override fun isScrolledDown(isScrolledDown: Boolean) {

                }
            })
        }
    }

    var callApiJob: Job? = null

    @SuppressLint("NotifyDataSetChanged")
    private fun setViewListeners() {
        binding.apply {
            layoutHeader.apply {
                textViewToolbarTitle.text = "Search"
                imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            }

            editTextSearch.addTextChangedListener { text: Editable? ->

                callApiJob?.cancel()
                callApiJob = GlobalScope.launch(Dispatchers.Main) {
                    delay(300)

                    resetPagingData()
                    if (editTextSearch.text.toString().trim().isBlank()) {
                        searchFoodList.clear()
                        selectFoodAdapter.notifyDataSetChanged()
                        updateUI()
                    } else {
                        searchFood(editTextSearch.text.toString().trim())
                    }

                }

            }
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
    private fun searchFood(searchText: String) {
        val apiRequest = ApiRequest().apply {
            food_name = searchText
            page = this@SelectFoodFragment.page.toString()
        }
        if (searchText.isNotBlank()) {
            analytics.logEvent(analytics.USER_SEARCHED_FOOD_DISH, Bundle().apply {
                putString(analytics.PARAM_FOOD_NAME, searchText)
            }, screenName = AnalyticsScreenNames.SearchFood)
        }
        goalReadingViewModel.searchFood(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //searchFoodLiveData
        goalReadingViewModel.searchFoodLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                isLoading = false

                if (page == 1) {
                    searchFoodList.clear()
                }
                responseBody.data?.let { searchFoodList.addAll(it) }

                /*if (searchFoodList.isEmpty()) {
                    binding.layoutNoSearchResults.visibility = View.VISIBLE
                } else {
                    binding.layoutNoSearchResults.visibility = View.GONE
                }*/

                selectFoodAdapter.notifyDataSetChanged()
                updateUI()
            },
            onError = { throwable ->
                hideLoader()
                isLoading = false
                isLastPage = true
                if (throwable is ServerException) {
                    if (page == 1) {
                        searchFoodList.clear()
                        selectFoodAdapter.notifyDataSetChanged()
                    }
                    updateUI(throwable.message)
                }
                false
            })
    }

    private fun updateUI(message: String? = null) {
        if (isAdded) {
            with(binding) {
                textViewNoData.isVisible = searchFoodList.isEmpty()
                recyclerView.isVisible = searchFoodList.isNotEmpty()
                textViewNoData.text = message ?: ""
            }
        }
    }
}