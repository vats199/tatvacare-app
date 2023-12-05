package com.mytatva.patient.ui.viewmodel

import androidx.lifecycle.viewModelScope
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.UpdateBcaVitalsApiRequest
import com.mytatva.patient.data.pojo.response.AddedPatientMealData
import com.mytatva.patient.data.pojo.response.BcaReadingsTrendsData
import com.mytatva.patient.data.pojo.response.BmrDisclaimerData
import com.mytatva.patient.data.pojo.response.CatSurveyData
import com.mytatva.patient.data.pojo.response.ChartRecordData
import com.mytatva.patient.data.pojo.response.DailySummaryData
import com.mytatva.patient.data.pojo.response.Diet
import com.mytatva.patient.data.pojo.response.ExerciseData
import com.mytatva.patient.data.pojo.response.FoodInsightResData
import com.mytatva.patient.data.pojo.response.FoodItemData
import com.mytatva.patient.data.pojo.response.FoodLogResData
import com.mytatva.patient.data.pojo.response.GetBcaReadingsMainData
import com.mytatva.patient.data.pojo.response.IncidentDetailsAllData
import com.mytatva.patient.data.pojo.response.IncidentDetailsMainData
import com.mytatva.patient.data.pojo.response.IncidentSurveyData
import com.mytatva.patient.data.pojo.response.LastIncidentData
import com.mytatva.patient.data.pojo.response.MealTypeData
import com.mytatva.patient.data.pojo.response.MedicationMainData
import com.mytatva.patient.data.pojo.response.MedicationSummaryData
import com.mytatva.patient.data.pojo.response.MonthlyCalData
import com.mytatva.patient.data.pojo.response.MyHealthInsightData
import com.mytatva.patient.data.pojo.response.QuizPoleMainData
import com.mytatva.patient.data.pojo.response.SpirometerTestResData
import com.mytatva.patient.data.pojo.response.UpdateGoalLogsResData
import com.mytatva.patient.data.pojo.response.UpdatePatientDosesResData
import com.mytatva.patient.data.pojo.response.WeightGoalMonthsData
import com.mytatva.patient.data.repository.GoalReadingRepository
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.base.APILiveData
import com.mytatva.patient.ui.base.BaseViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

class GoalReadingViewModel @Inject constructor(
    private val goalReadingRepository
    : GoalReadingRepository,
) : BaseViewModel() {

    // Goal Readings APIs
    /**
     * @API :- updateGoalLogs
     */
    val updateGoalLogsLiveData = APILiveData<ArrayList<UpdateGoalLogsResData>>()
    fun updateGoalLogs(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.updateGoalLogs(apiRequest)
            updateGoalLogsLiveData.value = result
        }
    }

    /**
     * @API :- updatePatientReadings
     */
    val updatePatientReadingsLiveData = APILiveData<Any>()
    fun updatePatientReadings(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.updatePatientReadings(apiRequest)
            updatePatientReadingsLiveData.value = result
        }
    }

    /**
     * @API :- getExerciseList
     */
    val getExerciseListLiveData = APILiveData<List<ExerciseData>>()
    fun getExerciseList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getExerciseList(apiRequest)
            getExerciseListLiveData.value = result
        }
    }

    /**
     * @API :- goalDailySummary
     */
    val goalDailySummaryLiveData = APILiveData<Any>()
    fun goalDailySummary(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.goalDailySummary(apiRequest)
            goalDailySummaryLiveData.value = result
        }
    }

    /**
     * @API :- dailySummary
     */
    val dailySummaryLiveData = APILiveData<DailySummaryData>()
    fun dailySummary(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.dailySummary(apiRequest)
            dailySummaryLiveData.value = result
        }
    }

    /**
     * @API :- dailySummary
     * call the same dailySummary API for care plan
     * and handled with different live data instance
     */
    val dailySummaryCarePlanLiveData = APILiveData<DailySummaryData>()
    fun dailySummaryCarePlan(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.dailySummary(apiRequest)
            dailySummaryCarePlanLiveData.value = result
        }
    }

    /**
     * @API :- getReadingRecords
     */
    val getReadingRecordsLiveData = APILiveData<ChartRecordData>()
    fun getReadingRecords(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getReadingRecords(apiRequest)
            getReadingRecordsLiveData.value = result
        }
    }


    /**
     * @API :- getGoalRecords
     */
    val getGoalRecordsLiveData = APILiveData<ChartRecordData>()
    fun getGoalRecords(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getGoalRecords(apiRequest)

            result.apply {
                // set goal id & chartDurationKey to response from request param to handle
                // in setting response of correct goal and duration
                responseBody?.goalId = apiRequest.goal_id
                responseBody?.chartDurationKey = apiRequest.goal_time
                if (throwable != null && throwable is ServerException) {
                    throwable.goalId = apiRequest.goal_id
                    throwable.chartDurationKey = apiRequest.goal_time
                }
            }

            getGoalRecordsLiveData.value = result
        }
    }

    /**
     * @API :- updatePatientDoses
     */
    val updatePatientDosesLiveData = APILiveData<UpdatePatientDosesResData>()
    fun updatePatientDoses(apiRequest: ApiRequest, goalMasterId: String?) {
        viewModelScope.launch {
            val result = goalReadingRepository.updatePatientDoses(apiRequest, goalMasterId)
            updatePatientDosesLiveData.value = result
        }
    }

    /**
     * @API :- patientTodaysMedicationList
     */
    val patientTodaysMedicationListLiveData = APILiveData<MedicationMainData>()
    fun patientTodaysMedicationList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.patientTodaysMedicationList(apiRequest)
            patientTodaysMedicationListLiveData.value = result
        }
    }

    /**
     * @API :- patientTodaysMedicationList
     */
    val lastSevenDaysMedicationLiveData = APILiveData<List<MedicationSummaryData>>()
    fun lastSevenDaysMedication(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.lastSevenDaysMedication(apiRequest)
            lastSevenDaysMedicationLiveData.value = result
        }
    }

    /**
     * @API :- updateReadingsGoals
     */
    val updateReadingsGoalsLiveData = APILiveData<Any>()
    fun updateReadingsGoals(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.updateReadingsGoals(apiRequest)
            updateReadingsGoalsLiveData.value = result
        }
    }

    /**
     * @API :- addCatSurvey
     */
    val addCatSurveyLiveData = APILiveData<Any>()
    fun addCatSurvey(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.addCatSurvey(apiRequest)
            addCatSurveyLiveData.value = result
        }
    }

    /**
     * @API :- getCatSurvey
     */
    val getCatSurveyLiveData = APILiveData<CatSurveyData>()
    fun getCatSurvey(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getCatSurvey(apiRequest)
            getCatSurveyLiveData.value = result
        }
    }

    // Food goal APIs
    /**
     * @API :- searchFood
     */
    val searchFoodLiveData = APILiveData<ArrayList<FoodItemData>>()
    fun searchFood(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.searchFood(apiRequest)
            searchFoodLiveData.value = result
        }
    }

    /**
     * @API :- frequentlyAddedFood
     */
    val frequentlyAddedFoodLiveData = APILiveData<ArrayList<FoodItemData>>()
    fun frequentlyAddedFood(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.frequentlyAddedFood(apiRequest)
            frequentlyAddedFoodLiveData.value = result
        }
    }

    /**
     * @API :- addMeal
     */
    val addMealLiveData = APILiveData<FoodInsightResData>()
    fun addMeal(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.addMeal(apiRequest)
            addMealLiveData.value = result
        }
    }

    /**
     * @API :- addMeal
     */
    val editMealLiveData = APILiveData<FoodInsightResData>()
    fun editMeal(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.editMeal(apiRequest)
            editMealLiveData.value = result
        }
    }

    /**
     * @API :- mealTypes
     */
    val mealTypesLiveData = APILiveData<ArrayList<MealTypeData>>()
    fun mealTypes(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.mealTypes(apiRequest)
            mealTypesLiveData.value = result
        }
    }

    /**
     * @API :- foodInsight
     */
    val foodInsightLiveData = APILiveData<FoodInsightResData>()
    fun foodInsight(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.foodInsight(apiRequest)
            foodInsightLiveData.value = result
        }
    }

    /**
     * @API :- foodLogs
     */
    val foodLogsLiveData = APILiveData<FoodLogResData>()
    fun foodLogs(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.foodLogs(apiRequest)
            foodLogsLiveData.value = result
        }
    }

    /**
     * @API :- getMonthlyDietCal
     */
    val getMonthlyDietCalLiveData = APILiveData<ArrayList<MonthlyCalData>>()
    fun getMonthlyDietCal(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getMonthlyDietCal(apiRequest)
            getMonthlyDietCalLiveData.value = result
        }
    }

    /**
     * @API :- patientMealRelById
     */
    val patientMealRelByIdLiveData = APILiveData<AddedPatientMealData>()
    fun patientMealRelById(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.patientMealRelById(apiRequest)
            patientMealRelByIdLiveData.value = result
        }
    }

    /**
     * @API :- calculateBmrMonths
     */
    val calculateBmrMonthsLiveData = APILiveData<ArrayList<WeightGoalMonthsData>>()
    fun calculateBmrMonths(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.calculateBmrMonths(apiRequest)
            calculateBmrMonthsLiveData.value = result
        }
    }

    /**
     * @API :- calculateBmrCalories
     */
    val calculateBmrCaloriesLiveData = APILiveData<User>()
    fun calculateBmrCalories(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.calculateBmrCalories(apiRequest)
            calculateBmrCaloriesLiveData.value = result
        }
    }

    /**
     * @API :- checkBmrDisclaimer
     */
    val checkBmrDisclaimerLiveData = APILiveData<BmrDisclaimerData>()
    fun checkBmrDisclaimer(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.checkBmrDisclaimer(apiRequest)
            checkBmrDisclaimerLiveData.value = result
        }
    }

    /**
     * @API :- dietPlanList
     */
    val dietPlanListLiveData = APILiveData<ArrayList<Diet>>()
    fun dietPlanList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.dietPlanList(apiRequest)
            dietPlanListLiveData.value = result
        }
    }

    //BCA device integration related APIs
    /**
     * @API :- vitalsTrendAnalysis
     */
    val vitalsTrendAnalysisLiveData = APILiveData<BcaReadingsTrendsData>()
    fun vitalsTrendAnalysis(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.vitalsTrendAnalysis(apiRequest)
            vitalsTrendAnalysisLiveData.value = result
        }
    }

    /**
     * @API :- updateBcaReadings
     */
    val updateBcaReadingsLiveData = APILiveData<Any>()
    fun updateBcaReadings(apiRequest: UpdateBcaVitalsApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.updateBcaReadings(apiRequest)
            updateBcaReadingsLiveData.value = result
        }
    }

    /**
     * @API :- getBcaVitals
     */
    val getBcaVitalsLiveData = APILiveData<GetBcaReadingsMainData>()
    fun getBcaVitals(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getBcaVitals(apiRequest)
            getBcaVitalsLiveData.value = result
        }
    }

    /**
     * @API :- generateBcaReport
     */
    val generateBcaReportLiveData = APILiveData<String>()
    fun generateBcaReport(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.generateBcaReport(apiRequest)
            generateBcaReportLiveData.value = result
        }
    }

    /**
     * @API :- spirometerTestList
     */
    val spirometerTestListLiveData = APILiveData<ArrayList<SpirometerTestResData>>()
    fun spirometerTestList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.spirometerTestList(apiRequest)
            spirometerTestListLiveData.value = result
        }
    }

    /**
     * @API :- updateSpirometerData
     */
    val updateSpirometerDataLiveData = APILiveData<Any>()
    fun updateSpirometerData(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.updateSpirometerData(apiRequest)
            updateSpirometerDataLiveData.value = result
        }
    }

    /**
     * @API :- updateIncentiveSpirometerData
     */
    val updateIncentiveSpirometerDataLiveData = APILiveData<Any>()
    fun updateIncentiveSpirometerData(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.updateIncentiveSpirometerData(apiRequest)
            updateIncentiveSpirometerDataLiveData.value = result
        }
    }

    // Survey APIs
    /**
     * @API :- getIncidentSurvey
     */
    val getIncidentSurveyLiveData = APILiveData<IncidentSurveyData>()
    fun getIncidentSurvey(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getIncidentSurvey(apiRequest)
            getIncidentSurveyLiveData.value = result
        }
    }

    /**
     * @API :- addIncidentDetails
     */
    val addIncidentDetailsLiveData = APILiveData<Any>()
    fun addIncidentDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.addIncidentDetails(apiRequest)
            addIncidentDetailsLiveData.value = result
        }
    }

    /**
     * @API :- fetchIncidentList
     */
    val fetchIncidentListLiveData = APILiveData<IncidentDetailsAllData>()
    fun fetchIncidentList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.fetchIncidentList(apiRequest)
            fetchIncidentListLiveData.value = result
        }
    }

    /**
     * @API :- getQuiz
     */
    val getQuizLiveData = APILiveData<Any>()
    fun getQuiz(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getQuiz(apiRequest)
            getQuizLiveData.value = result
        }
    }

    /**
     * @API :- quizQuestionIds
     */
    val quizQuestionIdsLiveData = APILiveData<Any>()
    fun quizQuestionIds(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.quizQuestionIds(apiRequest)
            quizQuestionIdsLiveData.value = result
        }
    }

    /**
     * @API :- addQuizAnswers
     */
    val addQuizAnswersLiveData = APILiveData<Any>()
    fun addQuizAnswers(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.addQuizAnswers(apiRequest)
            addQuizAnswersLiveData.value = result
        }
    }

    /**
     * @API :- addQuizAnswers
     */
    val addPollAnswersLiveData = APILiveData<Any>()
    fun addPollAnswers(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.addPollAnswers(apiRequest)
            addPollAnswersLiveData.value = result
        }
    }

    /**
     * @API :- getIncidentFreeDays
     */
    val getIncidentFreeDaysLiveData = APILiveData<LastIncidentData>()
    fun getIncidentFreeDays(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getIncidentFreeDays(apiRequest)
            getIncidentFreeDaysLiveData.value = result
        }
    }

    /**
     * @API :- fetchIncidentList
     */
    val getIncidentDurationOccuranceListLiveData = APILiveData<ArrayList<IncidentDetailsMainData>>()
    fun getIncidentDurationOccuranceList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getIncidentDurationOccuranceList(apiRequest)
            getIncidentDurationOccuranceListLiveData.value = result
        }
    }

    /**
     * @API :- fetchIncidentList
     */
    val getPollQuizLiveData = APILiveData<QuizPoleMainData>()
    fun getPollQuiz(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.getPollQuiz(apiRequest)
            getPollQuizLiveData.value = result
        }
    }


    /**
     * @API :- myHealthInsights
     */
    val myHealthInsightsLiveData = APILiveData<MyHealthInsightData>()
    fun myHealthInsights(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = goalReadingRepository.myHealthInsights(apiRequest)
            myHealthInsightsLiveData.value = result
        }
    }


}