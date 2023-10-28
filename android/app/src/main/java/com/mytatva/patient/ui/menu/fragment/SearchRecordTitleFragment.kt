package com.mytatva.patient.ui.menu.fragment

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
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.RecordTitleData
import com.mytatva.patient.databinding.MenuFragmentSearchRecordTitleBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.menu.adapter.SearchRecordTitleAdapter
import com.mytatva.patient.ui.viewmodel.AuthViewModel


class SearchRecordTitleFragment : BaseFragment<MenuFragmentSearchRecordTitleBinding>() {

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val fullTitleList = arrayListOf<RecordTitleData>()
    val titleList = arrayListOf<RecordTitleData>()

    val searchRecordTitleAdapter by lazy {
        SearchRecordTitleAdapter(titleList,
            object : SearchRecordTitleAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    setResult(titleList[position])
                }
            })
    }

    private fun setResult(dataModel: RecordTitleData) {
        val intent = Intent()
        intent.putExtra(Common.BundleKey.TITLE, dataModel.title)
        requireActivity().setResult(Activity.RESULT_OK, intent)
        requireActivity().finish()
    }

    override fun onResume() {
        super.onResume()
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MenuFragmentSearchRecordTitleBinding {
        return MenuFragmentSearchRecordTitleBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()
        //testTypes()
    }

    private fun setUpRecyclerView() {
        binding.apply {
            recyclerViewSearch.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = searchRecordTitleAdapter
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setViewListeners() {
        binding.apply {
            layoutHeader.apply {
                textViewToolbarTitle.text = "Add Document Title"
                imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            }

            editTextSearch.addTextChangedListener { text: Editable? ->
                titleList.clear()
                titleList.addAll(
                    fullTitleList.filter {
                        it.title?.contains(editTextSearch.text.toString()
                            .trim(), true) == true
                    }.toList()
                )
                if (editTextSearch.text.toString().trim().isNotBlank()) {
                    val labelToAddAsDrug =
                        "Add ${editTextSearch.text.toString().trim()} as a document title"
                    titleList.add(RecordTitleData(labelToAddAsCustom = labelToAddAsDrug,
                        title = editTextSearch.text.toString().trim(),
                        isSelected = true))
                }
                searchRecordTitleAdapter.notifyDataSetChanged()
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
    private fun testTypes() {
        val apiRequest = ApiRequest()
        authViewModel.testTypes(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.testTypesLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.title?.let {
                    fullTitleList.clear()
                    fullTitleList.addAll(it)
                    titleList.clear()
                    titleList.addAll(it)
                    searchRecordTitleAdapter.notifyDataSetChanged()
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}