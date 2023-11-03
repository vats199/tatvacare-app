package com.mytatva.patient.ui.goal.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.FoodQtyUtensilData
import com.mytatva.patient.databinding.GoalFragmentFoodLogQtyHelpBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.FoodQuantityHelpAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel


class LogFoodQuantityHelpFragment : BaseFragment<GoalFragmentFoodLogQtyHelpBinding>() {

    private val utensilList = arrayListOf<FoodQtyUtensilData>()

    private val foodQuantityHelpAdapter by lazy {
        FoodQuantityHelpAdapter(utensilList)
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
    ): GoalFragmentFoodLogQtyHelpBinding {
        return GoalFragmentFoodLogQtyHelpBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()
        utensilList()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = ""
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            textViewLabelQtyHelp.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewQtyHelp.apply {
            layoutManager = GridLayoutManager(requireContext(), 2, RecyclerView.VERTICAL, false)
            adapter = foodQuantityHelpAdapter
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.textViewLabelQtyHelp -> {

            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun utensilList() {
        val apiRequest = ApiRequest()
        showLoader()
        engageContentViewModel.utensilList(apiRequest)
    }


    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //utensilListLiveData
        engageContentViewModel.utensilListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                utensilList.clear()
                responseBody.data?.let { utensilList.addAll(it) }
                foodQuantityHelpAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}