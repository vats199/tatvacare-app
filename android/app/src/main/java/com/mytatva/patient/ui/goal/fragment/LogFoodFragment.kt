package com.mytatva.patient.ui.goal.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.AddedPatientMealData
import com.mytatva.patient.data.pojo.response.FoodItemData
import com.mytatva.patient.data.pojo.response.ImageData
import com.mytatva.patient.data.pojo.response.MealTypeData
import com.mytatva.patient.databinding.GoalFragmentLogFoodBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.AddedFoodItemsAdapter
import com.mytatva.patient.ui.goal.adapter.MealImagesAdapter
import com.mytatva.patient.ui.goal.adapter.SearchFrequentlyAddedFoodItemsCommonAdapter
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.azure.UploadToAzureStorage
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.ImageAndVideoPicker
import com.mytatva.patient.utils.listOfField
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import java.util.*
import java.util.concurrent.TimeUnit


class LogFoodFragment : BaseFragment<GoalFragmentLogFoodBinding>() {

    private val mealTypeKey: String? by lazy {
        //to show selected meal type, only at the time of add new log
        arguments?.getString(Common.BundleKey.MEAL_TYPE_KEY)
    }

    private val patientMealRelId: String? by lazy {
        arguments?.getString(Common.BundleKey.PATIENT_MEAL_REL_ID)
    }

    private val date: Date? by lazy {
        arguments?.getSerializable(Common.BundleKey.DATE) as Date?
    }

    private val cal = Calendar.getInstance()

    private val isForEdit: Boolean
        get() = patientMealRelId.isNullOrBlank().not()

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    if (selectedMealTypeId.isNullOrBlank()) {
                        throw ApplicationException(getString(R.string.validation_select_food_type))
                    }

                    if (isForEdit.not() && addedFoodList.isNullOrEmpty()) {
                        throw ApplicationException(getString(R.string.validation_add_food_dish))
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    var selectedMealTypeId: String? = null

    private val imagesList = arrayListOf<ImageData>()
    private val mealImagesAdapter by lazy {
        MealImagesAdapter(imagesList,
            object : MealImagesAdapter.AdapterListener {
                override fun onAddClick(position: Int) {
                    showImagePicker()
                }
            })
    }

    private val addedFoodList = arrayListOf<FoodItemData>()
    private val addedFoodItemsAdapter by lazy {
        AddedFoodItemsAdapter(addedFoodList,
            analytics,
            requireActivity(),
            object : AddedFoodItemsAdapter.AdapterListener {
                override fun onRemoveClick(position: Int) {

                }
            })
    }

    private val searchFoodList = arrayListOf<FoodItemData>()
    private val searchFoodItemsAdapter by lazy {
        SearchFrequentlyAddedFoodItemsCommonAdapter(searchFoodList,
            requireActivity(),
            object : SearchFrequentlyAddedFoodItemsCommonAdapter.AdapterListener {
                override fun onAddClick(position: Int) {
                    handleAddToMealList(position, false)
                }
            })
    }

    private val frequentlyAddedFoodList = arrayListOf<FoodItemData>()
    private val frequentlyAddedFoodItemsAdapter by lazy {
        SearchFrequentlyAddedFoodItemsCommonAdapter(frequentlyAddedFoodList,
            requireActivity(),
            object : SearchFrequentlyAddedFoodItemsCommonAdapter.AdapterListener {
                override fun onAddClick(position: Int) {
                    handleAddToMealList(position, true)
                }
            })
    }

    private fun handleAddToMealList(position: Int, isFromFrequentlyAdded: Boolean) {
        val foodItem = if (isFromFrequentlyAdded) frequentlyAddedFoodList[position]
        else searchFoodList[position]

        if (foodItem.food_item_id == "0"
            /*|| addedFoodList.any { it.food_item_id == foodItem.food_item_id }.not()*/
            || addedFoodList.any { it.food_name == foodItem.food_name }.not()
        ) {

            analytics.logEvent(analytics.USER_SELECTED_FOOD_DISH, Bundle().apply {
                putString(analytics.PARAM_FOOD_NAME, foodItem.food_name)
                putString(analytics.PARAM_FOOD_ITEM_ID, foodItem.food_item_id)
            }, screenName = AnalyticsScreenNames.LogFood)

            addedFoodList.add(foodItem)
            addedFoodItemsAdapter.notifyItemInserted(addedFoodList.lastIndex)
        }
    }

    private fun handleAddToMealListFromSelectFoodResult(foodItem: FoodItemData) {
        if (foodItem.food_item_id == "0"
            /*|| addedFoodList.any { it.food_item_id == foodItem.food_item_id }.not()*/
            || addedFoodList.any { it.food_name == foodItem.food_name }.not()
        ) {

            analytics.logEvent(analytics.USER_SELECTED_FOOD_DISH, Bundle().apply {
                putString(analytics.PARAM_FOOD_NAME, foodItem.food_name)
                putString(analytics.PARAM_FOOD_ITEM_ID, foodItem.food_item_id)
            }, screenName = AnalyticsScreenNames.LogFood)

            addedFoodList.add(foodItem)
            addedFoodItemsAdapter.notifyItemInserted(addedFoodList.lastIndex)
        }
    }

    private fun addFoodManuallyToMealList() {
        val foodName = binding.editTextSearch.text.toString().trim()
        if (foodName.isNotBlank()) {
            val foodItem = FoodItemData().apply {
                isAddedByUser = true
                food_name = foodName
                food_item_id = foodName // set name as id for custom added food
                Energy_kcal = "100"
                unit_name = "unit"
            }

            addedFoodList.add(foodItem)
            addedFoodItemsAdapter.notifyItemInserted(addedFoodList.lastIndex)
        }
        binding.editTextSearch.setText("")
    }

    val mealTypeList = arrayListOf<MealTypeData>()

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): GoalFragmentLogFoodBinding {
        return GoalFragmentLogFoodBinding.inflate(inflater, container, attachToRoot)
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LogFood)
        resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        /*analytics.logEvent(analytics.TIME_SPENT_FOOD_LOG, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.LogFood)*/
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()
        frequentlyAddedFood()
        updateDate()

        mealTypes(false)

        if (isForEdit.not() && date != null) {
            cal.time = date!!
            updateDate()
        }

        /*if (isForEdit) {
            mealTypes(false)
        }*/
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = ""
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setUpViewListeners() {

        val scope = CoroutineScope(Dispatchers.Main)

        with(binding) {
            /*editTextSearch.addTextChangedListener { text ->
                if (text.isNullOrBlank()) {
                    searchFoodList.clear()
                    searchFoodItemsAdapter.notifyDataSetChanged()
                } else {
                    searchFood(text.toString())
                }
            }*/

            editTextSearch.setOnClickListener {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    SelectFoodFragment::class.java)
                    .forResult(Common.RequestCode.REQUEST_SELECT_FOOD)
                    .start()
            }

            textViewDate.setOnClickListener { onViewClick(it) }
            textViewFoodLogType.setOnClickListener { onViewClick(it) }
            textViewHelp.setOnClickListener { onViewClick(it) }
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonDone.setOnClickListener { onViewClick(it) }
            buttonAddNewFood.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == Common.RequestCode.REQUEST_SELECT_FOOD && resultCode == Activity.RESULT_OK) {
            if (data?.hasExtra(Common.BundleKey.SELECTED_FOOD_DATA) == true) {
                handleAddToMealListFromSelectFoodResult(data.getSerializableExtra(Common.BundleKey.SELECTED_FOOD_DATA) as FoodItemData)
            }
        }
    }

    private fun setUpRecyclerView() {
        imagesList.add(ImageData())//to handle add option add empty string
        binding.recyclerViewMealImages.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = mealImagesAdapter
        }

        binding.recyclerViewAddedFoodItems.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = addedFoodItemsAdapter
        }

        binding.recyclerViewSearchItems.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = searchFoodItemsAdapter
        }

        binding.recyclerViewFrequentlyAddedItems.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = frequentlyAddedFoodItemsAdapter
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewDate -> {
                if (isForEdit.not()) {
                    navigator.pickDate({ _, year, month, dayOfMonth ->
                        cal.set(year, month, dayOfMonth)
                        updateDate()
                    }, 0L, Calendar.getInstance().timeInMillis)
                }
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.textViewFoodLogType -> {
                if (mealTypeList.isNotEmpty()) {
                    showMealTypeSelection()
                } else {
                    mealTypes(true)
                }
            }
            R.id.textViewHelp -> {
                analytics.logEvent(analytics.USER_CLICKED_ON_REFERENCE_UTENSILS, screenName = AnalyticsScreenNames.LogFood)
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LogFoodQuantityHelpFragment::class.java)
                    .start()
            }
            R.id.buttonCancel -> {
                navigator.goBack()
            }
            R.id.buttonDone -> {
                if (isValid) {
                    if (imagesList.size <= 1) {
                        if (isForEdit) {
                            editMeal(listOf())
                        } else {
                            addMeal(listOf())
                        }
                    } else {
                        handleUploadMealImages { uplodedList ->
                            activity?.runOnUiThread {
                                if (isForEdit) {
                                    editMeal(uplodedList)
                                } else {
                                    addMeal(uplodedList)
                                }
                            }
                        }
                    }
                }
            }
            R.id.buttonAddNewFood -> {
                addFoodManuallyToMealList()
            }
        }
    }

    private fun updateDate() {
        binding.textViewDate.text = try {
            DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
        } catch (e: Exception) {
            ""
        }
    }

    private fun showImagePicker() {
        ImageAndVideoPicker.newInstance()
            .pickImage(true)
            .pickVideo(false)
            .pickDocument(false)
            .setResult(imagePickerResult = object : ImageAndVideoPicker.ImageVideoPickerResult() {
                override fun onFail(message: String) {
                    showMessage(message)
                }

                @SuppressLint("NotifyDataSetChanged")
                override fun onImagesSelected(list: ArrayList<String>) {
                    if (ImageAndVideoPicker.isValidFileSize(list.first())) {
                        imagesList.add(imagesList.size - 1, ImageData(imagePath = list.first()))
                        mealImagesAdapter.notifyDataSetChanged()
                    } else {
                        showMessage(getString(R.string.validation_invalid_file_size))
                    }
                }
            }).show(childFragmentManager, ImageAndVideoPicker::class.java.name)
    }


    var imageCount = 0
    private fun handleUploadMealImages(success: (uplodedList: List<String>) -> Unit) {
        val uploadedList = arrayListOf<String>()
        showLoader()

        if (patientMealRelId.isNullOrBlank().not()) {
            //For edit time, add all image names which uploaded previously
            uploadedList.addAll(ArrayList(imagesList.filter { it.image_url.isNullOrBlank().not() }
                .toList()).listOfField(ImageData::image_name))
        }

        val finalImageListToUpload =
            ArrayList(imagesList.filter { it.imagePath.isNullOrBlank().not() }
                .toList()).listOfField(ImageData::imagePath)

        val totalUploadedSize = uploadedList.size + finalImageListToUpload.size

        if (finalImageListToUpload.isEmpty()) {
            // if no new images added at edit time
            success.invoke(uploadedList)
        } else {

            for (i in 0 until finalImageListToUpload.size) {

                val fileName = UploadToAzureStorage.PREFIX_FOOD + "$createFileName.jpg"
                UploadToAzureStorage().uploadImage(
                    this,
                    finalImageListToUpload[i],
                    UploadToAzureStorage.AZURE_CONTAINER,
                    fileName,
                    {
                        imageCount++
                        uploadedList.add(fileName)
                        if (/*finalImageListToUpload.size*/totalUploadedSize == uploadedList.size) {
                            hideLoader()
                            success.invoke(uploadedList)
                        }
                    },
                    {
                        hideLoader()
                        showMessage(it)
                    })
            }

        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    /*private fun searchFood(searchText: String) {
        val apiRequest = ApiRequest().apply {
            food_name = searchText
        }
        if (searchText.isNotBlank()) {
            analytics.logEvent(analytics.USER_SEARCHED_FOOD_DISH, Bundle().apply {
                putString(analytics.PARAM_FOOD_NAME, searchText)
            })
        }
        goalReadingViewModel.searchFood(apiRequest)
    }*/

    private fun frequentlyAddedFood() {
        val apiRequest = ApiRequest()
        goalReadingViewModel.frequentlyAddedFood(apiRequest)
    }

    private fun addMeal(imagesList: List<String>) {
        /*
         * meal_data- [{food_item_id:8,quantity:5,unit_name:number,calories:370.083333333}]
         * Send total calories means percalory * total quantity
         * meal images- ['image1.jpg','image2.jpg']
         */
        val apiRequest = ApiRequest().apply {
            meal_types_id = selectedMealTypeId

            val list = arrayListOf<ApiRequestSubData>()
            addedFoodList.forEachIndexed { index, foodItemData ->
                list.add(ApiRequestSubData().apply {
                    food_item_id = foodItemData.food_item_id
                    quantity = foodItemData.quantity.toString()
                    unit_name = foodItemData.unit_name
                    calories = foodItemData.calculatedCalorie.toString()
                    food_name = foodItemData.food_name
                })
            }
            meal_data = list

            meal_date = DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)

            if (imagesList.isNullOrEmpty().not()) {
                meal_images = ArrayList(imagesList)
            }
        }
        showLoader()
        goalReadingViewModel.addMeal(apiRequest)
    }

    private fun mealTypes(showMealTypeSelection: Boolean) {
        isNeedToShowMealTypeSelection = showMealTypeSelection

        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.mealTypes(apiRequest)
    }

    private fun patientMealRelById() {
        val apiRequest = ApiRequest().apply {
            patient_meal_rel_id = patientMealRelId
        }
        showLoader()
        goalReadingViewModel.patientMealRelById(apiRequest)
    }

    private fun editMeal(imagesList: List<String>) {
        val apiRequest = ApiRequest().apply {
            patient_meal_rel_id = patientMealRelId

            meal_types_id = selectedMealTypeId

            val list = arrayListOf<ApiRequestSubData>()
            addedFoodList.forEachIndexed { index, foodItemData ->
                list.add(ApiRequestSubData().apply {
                    food_item_id = if (foodItemData.food_item_id == "0") foodItemData.food_name
                    else foodItemData.food_item_id

                    quantity = foodItemData.quantity.toString()
                    unit_name = foodItemData.unit_name
                    calories = foodItemData.calculatedCalorie.toString()
                    food_name = foodItemData.food_name
                })
            }
            meal_data = list

            meal_date = DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)

            if (imagesList.isNullOrEmpty().not()) {
                meal_images = ArrayList(imagesList)
            }
        }
        showLoader()
        goalReadingViewModel.editMeal(apiRequest)
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
                searchFoodList.clear()
                responseBody.data?.let { searchFoodList.addAll(it) }

                if (searchFoodList.isEmpty()) {
                    binding.layoutNoSearchResults.visibility = View.VISIBLE
                } else {
                    binding.layoutNoSearchResults.visibility = View.GONE
                }

                if (binding.editTextSearch.text.toString().trim().isBlank()) {
                    //clear if search text is empty
                    searchFoodList.clear()
                }
                searchFoodItemsAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException) {
                    handleNoSearchFoodData(throwable.message ?: "")
                }
                false
            })

        //frequentlyAddedFoodLiveData
        goalReadingViewModel.frequentlyAddedFoodLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                frequentlyAddedFoodList.clear()
                responseBody.data?.let { frequentlyAddedFoodList.addAll(it) }
                frequentlyAddedFoodItemsAdapter.notifyDataSetChanged()
                handleFreqAddedItemUI()
            },
            onError = { throwable ->
                hideLoader()
                handleFreqAddedItemUI()
                false
            })

        //addMealLiveData
        goalReadingViewModel.addMealLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    val foodInsightResData = responseBody.data
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        LogFoodSuccessFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.FOOD_INSIGHT_RES_DATA, foodInsightResData),
                            Pair(Common.BundleKey.MEAL_TYPE,
                                binding.textViewFoodLogType.text.toString().trim())
                        )).byFinishingCurrent().start()

                    analytics.logEvent(analytics.USER_LOGGED_MEAL, Bundle().apply {
                        putString(analytics.PARAM_MEAL_TYPES_ID, selectedMealTypeId)
                    }, screenName = AnalyticsScreenNames.LogFood)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //editMealLiveData
        goalReadingViewModel.editMealLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                /*navigator.loadActivity(IsolatedFullActivity::class.java,
                    LogFoodSuccessFragment::class.java)
                    .start()*/
                analytics.logEvent(analytics.USER_LOGGED_MEAL, Bundle().apply {
                    putString(analytics.PARAM_MEAL_TYPES_ID, selectedMealTypeId)
                }, screenName = AnalyticsScreenNames.LogFood)
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //mealTypesLiveData
        goalReadingViewModel.mealTypesLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                mealTypeList.clear()
                responseBody.data?.let { mealTypeList.addAll(it) }
                if (isNeedToShowMealTypeSelection) {
                    showMealTypeSelection()
                } else {
                    // below code for show default first as selected meal type
                    /*selectedMealTypeId = mealTypeList.firstOrNull()?.meal_types_id
                    binding.textViewFoodLogType.text = mealTypeList.firstOrNull()?.meal_type
                        ?: ""*/
                }

                if (isForEdit) {
                    patientMealRelById()
                } else {
                    //if for add new log show selected meal type from meal type key
                    selectedMealTypeId =
                        mealTypeList.firstOrNull { it.keys == mealTypeKey }?.meal_types_id
                    binding.textViewFoodLogType.text =
                        mealTypeList.firstOrNull { it.meal_types_id == selectedMealTypeId }?.meal_type
                            ?: ""
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //patientMealRelByIdLiveData
        goalReadingViewModel.patientMealRelByIdLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { setPatientMealData(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setPatientMealData(patientMealData: AddedPatientMealData) {
        patientMealData.let {
            addedFoodList.clear()
            it.food_data?.let { it1 ->
                addedFoodList.addAll(it1/*.map {
                    if (it.food_item_id == "0")
                        it.food_item_id = it.food_name
                    it
                }*/)
            }
            addedFoodItemsAdapter.notifyDataSetChanged()

            imagesList.clear()
            it.image_data?.let { it1 -> imagesList.addAll(it1) }
            imagesList.add(ImageData())//to handle add image
            mealImagesAdapter.notifyDataSetChanged()

            selectedMealTypeId = addedFoodList.firstOrNull()?.meal_types_id
            binding.textViewFoodLogType.text =
                mealTypeList.firstOrNull { it.meal_types_id == selectedMealTypeId }?.meal_type

            val mealDate = addedFoodList.firstOrNull()?.meal_date ?: ""
            if (mealDate.isNotBlank() && mealDate.contains("-") && mealDate.split("-").size == 3) {
                val year = mealDate.split("-")[0].toInt()
                val month = mealDate.split("-")[1].toInt()
                val date = mealDate.split("-")[2].toInt()
                cal.set(year, month - 1, date)
            }
            updateDate()
        }
    }

    private fun handleFreqAddedItemUI() {
        with(binding) {
            if (frequentlyAddedFoodList.isNotEmpty()) {
                tetViewLabelFrequentlyAddedItems.visibility = View.VISIBLE
                recyclerViewFrequentlyAddedItems.visibility = View.VISIBLE
            } else {
                tetViewLabelFrequentlyAddedItems.visibility = View.GONE
                recyclerViewFrequentlyAddedItems.visibility = View.GONE
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleNoSearchFoodData(msg: String) {
        with(binding) {
            searchFoodList.clear()
            searchFoodItemsAdapter.notifyDataSetChanged()
            if (editTextSearch.text.toString().trim().isNotBlank()) {
                textViewNoItemFound.text = msg
                layoutNoSearchResults.visibility = View.VISIBLE
            } else {
                layoutNoSearchResults.visibility = View.GONE
            }
        }
    }

    private var isNeedToShowMealTypeSelection = false
    private fun showMealTypeSelection() {
        BottomSheet<MealTypeData>().showBottomSheetDialog(requireActivity(),
            mealTypeList,
            "",
            object : BottomSheetAdapter.ItemListener<MealTypeData> {
                override fun onItemClick(item: MealTypeData, position: Int) {
                    selectedMealTypeId = item.meal_types_id
                    binding.textViewFoodLogType.text = item.meal_type
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<MealTypeData>.MyViewHolder,
                    position: Int,
                    item: MealTypeData,
                ) {
                    holder.textView.text = item.meal_type
                }
            })
    }
}