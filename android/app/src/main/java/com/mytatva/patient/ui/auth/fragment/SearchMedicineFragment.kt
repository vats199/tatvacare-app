package com.mytatva.patient.ui.auth.fragment

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
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.GetMedicineResData
import com.mytatva.patient.databinding.AuthFragmentSearchMedicineBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.auth.adapter.SearchMedicineAdapter
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import kotlinx.coroutines.*


class SearchMedicineFragment : BaseFragment<AuthFragmentSearchMedicineBinding>() {

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    //pagination paramas
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

    private val fullMedicineList = arrayListOf<TempDataModel>()
    val medicineList = arrayListOf<GetMedicineResData>()

    val searchMedicineAdapter by lazy {
        SearchMedicineAdapter(medicineList,
            object : SearchMedicineAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    try {
                        if (medicineList.isNotEmpty() && position < medicineList.size) {
                            setResult(medicineList[position])
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            })
    }

    private fun setResult(dataModel: GetMedicineResData) {
        val intent = Intent()
        intent.putExtra(Common.BundleKey.MEDICINE_NAME, dataModel.medicine_name)
        intent.putExtra(Common.BundleKey.MEDICINE_ID, dataModel.medicine_id)
        requireActivity().setResult(Activity.RESULT_OK, intent)
        requireActivity().finish()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SearchDrugs)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSearchMedicineBinding {
        return AuthFragmentSearchMedicineBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        binding.apply {
            linearLayoutManager =
                LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
            recyclerViewSearch.apply {
                layoutManager = linearLayoutManager
                adapter = searchMedicineAdapter
            }

            /*recyclerViewSearch.addOnScrollListener(object : RecyclerView.OnScrollListener() {
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
                        getMedicineList(editTextSearch.text.toString().trim())
                        isLoading = true
                    }
                }
            })*/

            recyclerViewSearch.addOnScrollListener(object :
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
                    getMedicineList(editTextSearch.text.toString().trim())
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
                textViewToolbarTitle.text = getString(R.string.search_medicine_title)
                imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            }

            editTextSearch.addTextChangedListener { text: Editable? ->

                callApiJob?.cancel()

                callApiJob = GlobalScope.launch(Dispatchers.Main) {
                    delay(300)

                    if (text.isNullOrBlank()) {
                        medicineList.clear()
                        addNewNameOptionAsADrug()
                        searchMedicineAdapter.notifyDataSetChanged()
                    } else {
                        medicineList.clear()
                        /*addNewNameOptionAsADrug()
                        searchMedicineAdapter.notifyDataSetChanged()*/

                        resetPagingData()
                        getMedicineList(text.toString())
                    }

                }
            }
        }
    }

    private fun addNewNameOptionAsADrug() {
        with(binding) {
            if (editTextSearch.text.toString().trim().isNotBlank()) {
                /*val labelToAddAsDrug = "Add ${editTextSearch.text.toString().trim()} as a Drug"
                medicineList.add(
                    TempDataModel(name = labelToAddAsDrug,
                        medicineName = editTextSearch.text.toString().trim(),
                        isSelected = true)
                )*/
                medicineList.add(GetMedicineResData(
                    medicine_id = "0",
                    medicine_name = editTextSearch.text.toString().trim(),
                    isSelected = true
                ))
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
    private fun getMedicineList(medicineName: String) {
        val apiRequest = ApiRequest().apply {
            medicine_name = medicineName
            page_no = this@SearchMedicineFragment.page.toString()
        }
        //showLoader()
        authViewModel.getMedicineList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.getMedicineListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                isLoading = false

                if (page == 1) {
                    medicineList.clear()
                    responseBody.data?.let { medicineList.addAll(it) }
                    addNewNameOptionAsADrug()
                } else {
                    responseBody.data?.let { medicineList.addAll(medicineList.lastIndex, it) }
                }

                if (binding.editTextSearch.text.toString().trim().isBlank()) {
                    medicineList.clear()
                }
                searchMedicineAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                isLoading = false
                isLastPage = true
                if (page == 1) {
                    medicineList.clear()
                    addNewNameOptionAsADrug()
                }
                searchMedicineAdapter.notifyDataSetChanged()
                false
            })
    }
}