package com.mytatva.patient.ui.common.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.addTextChangedListener
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.CommonSelectItemData
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.CommonFragmentSelectItemBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.adapter.SelectItemAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel


class SelectItemFragment : BaseFragment<CommonFragmentSelectItemBinding>() {

    enum class SelectType {
        CITY, STATE
    }

    var selectType: SelectType? = null

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val fullItemsList = arrayListOf<CommonSelectItemData>()
    private val itemsList = arrayListOf<CommonSelectItemData>()

    private val selectItemAdapter by lazy {
        SelectItemAdapter(itemsList,
            object : SelectItemAdapter.AdapterListener {
                override fun onClick(position: Int, commonSelectItemData: CommonSelectItemData) {
                    onItemSelect(commonSelectItemData)
                }
            })
    }

    private fun onItemSelect(commonSelectItemData: CommonSelectItemData) {
        val intent = Intent()
        intent.putExtra(Common.BundleKey.COMMON_SELECT_ITEM_DATA, commonSelectItemData)
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
    ): CommonFragmentSelectItemBinding {
        return CommonFragmentSelectItemBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        arguments?.let {
            selectType = it.getSerializable(Common.BundleKey.SELECT_TYPE) as SelectType?
            selectItemAdapter.selectType = selectType
            when (selectType) {
                SelectType.CITY -> {
                    binding.layoutHeader.textViewToolbarTitle.text = "City"
                    val stateName = arguments?.getString(Common.BundleKey.STATE_NAME)
                    cityListByStateName(stateName)
                }
                SelectType.STATE -> {
                    binding.layoutHeader.textViewToolbarTitle.text = "State"
                    stateList()
                }

                else -> {}
            }
        }
        setViewListeners()
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        binding.apply {
            recyclerView.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = selectItemAdapter
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setViewListeners() {
        binding.apply {
            layoutHeader.apply {
                textViewToolbarTitle.text = "Search"
                imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            }

            editTextSearch.addTextChangedListener { text: Editable? ->
                when (selectType) {
                    SelectType.CITY -> {
                        itemsList.clear()
                        itemsList.addAll(
                            fullItemsList.filter {
                                it.city_name?.contains(editTextSearch.text.toString()
                                    .trim(), true) == true
                            }.toList()
                        )
                        selectItemAdapter.notifyDataSetChanged()
                    }
                    SelectType.STATE -> {
                        itemsList.clear()
                        itemsList.addAll(
                            fullItemsList.filter {
                                it.state_name?.contains(editTextSearch.text.toString()
                                    .trim(), true) == true
                            }.toList()
                        )
                        selectItemAdapter.notifyDataSetChanged()
                    }

                    else -> {}
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
    private fun stateList() {
        showLoader()
        val apiRequest = ApiRequest()
        authViewModel.stateList(apiRequest)
    }

    private fun cityListByStateName(stateName: String?) {
        showLoader()
        val apiRequest = ApiRequest()
        apiRequest.state_name = stateName
        authViewModel.cityListByStateName(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.stateListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                setData(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.cityListByStateNameLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                setData(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setData(data: List<CommonSelectItemData>?) {
        fullItemsList.clear()
        data?.let { fullItemsList.addAll(it) }
        itemsList.clear()
        data?.let { itemsList.addAll(it) }
        selectItemAdapter.notifyDataSetChanged()
    }
}