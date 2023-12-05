package com.mytatva.patient.data.datasource

import android.os.Bundle
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.DataWrapper
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
import com.mytatva.patient.data.service.GoalReadingService
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GoalReadingLiveDataSource @Inject constructor(private val goalReadingService: GoalReadingService) :
    BaseDataSource(), GoalReadingRepository {

    @Inject
    lateinit var session: Session

    @Inject
    lateinit var analytics: AnalyticsClient

    override suspend fun updateGoalLogs(apiRequest: ApiRequest): DataWrapper<ArrayList<UpdateGoalLogsResData>> {
        return execute { goalReadingService.updateGoalLogs(apiRequest) }.apply {

            if (responseBody?.data?.isNullOrEmpty()?.not() == true) {
                val updateGoalLogsResData = responseBody.data.first()

                val todayAchievedValue =
                    updateGoalLogsResData.todays_achieved_value?.toDoubleOrNull()?.toInt() ?: 0
                val targetValue = updateGoalLogsResData.target_value?.toDoubleOrNull()?.toInt() ?: 0

                if (targetValue in 1..todayAchievedValue) {
                    analytics.logEvent(analytics.GOAL_COMPLETED, Bundle().apply {
                        putString(analytics.PARAM_GOAL_ID, apiRequest.goal_id)
                        putString(analytics.PARAM_GOAL_VALUE, targetValue.toString())
                    }, screenName = AnalyticsScreenNames.LogGoal)
                }
            }

        }
    }

    override suspend fun updatePatientReadings(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.updatePatientReadings(apiRequest) }
    }

    override suspend fun getExerciseList(apiRequest: ApiRequest): DataWrapper<List<ExerciseData>> {
        return execute { goalReadingService.getExerciseList(apiRequest) }
    }

    override suspend fun goalDailySummary(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.goalDailySummary(apiRequest) }
    }

    override suspend fun dailySummary(apiRequest: ApiRequest): DataWrapper<DailySummaryData> {
        return execute { goalReadingService.dailySummary(apiRequest) }
    }

    override suspend fun getReadingRecords(apiRequest: ApiRequest): DataWrapper<ChartRecordData> {
        return execute { goalReadingService.getReadingRecords(apiRequest) }
    }

    override suspend fun getGoalRecords(apiRequest: ApiRequest): DataWrapper<ChartRecordData> {
        return execute { goalReadingService.getGoalRecords(apiRequest) }
    }

    override suspend fun updatePatientDoses(
        apiRequest: ApiRequest,
        goalMasterId: String?,
    ): DataWrapper<UpdatePatientDosesResData> {
        return execute { goalReadingService.updatePatientDoses(apiRequest) }.apply {

            responseBody?.data?.let {
                val updatePatientDosesResData = responseBody.data

                val todayAchievedValue =
                    updatePatientDosesResData.todays_achieved_value?.toDoubleOrNull()?.toInt() ?: 0
                val targetValue =
                    updatePatientDosesResData.goal_value?.toDoubleOrNull()?.toInt() ?: 0

                if (targetValue in 1..todayAchievedValue) {
                    analytics.logEvent(analytics.GOAL_COMPLETED, Bundle().apply {
                        putString(analytics.PARAM_GOAL_ID, goalMasterId)
                        putString(analytics.PARAM_GOAL_VALUE, targetValue.toString())
                    }, screenName = AnalyticsScreenNames.LogGoal)
                }
            }

        }
    }

    override suspend fun patientTodaysMedicationList(apiRequest: ApiRequest): DataWrapper<MedicationMainData> {
        return execute { goalReadingService.patientTodaysMedicationList(apiRequest) }
    }

    override suspend fun lastSevenDaysMedication(apiRequest: ApiRequest): DataWrapper<List<MedicationSummaryData>> {
        return execute { goalReadingService.lastSevenDaysMedication(apiRequest) }
    }

    override suspend fun updateReadingsGoals(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.updateReadingsGoals(apiRequest) }
    }

    override suspend fun addCatSurvey(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.addCatSurvey(apiRequest) }
    }

    override suspend fun getCatSurvey(apiRequest: ApiRequest): DataWrapper<CatSurveyData> {
        return execute { goalReadingService.getCatSurvey(apiRequest) }
    }

    override suspend fun searchFood(apiRequest: ApiRequest): DataWrapper<ArrayList<FoodItemData>> {
        return execute { goalReadingService.searchFood(apiRequest) }
    }

    override suspend fun frequentlyAddedFood(apiRequest: ApiRequest): DataWrapper<ArrayList<FoodItemData>> {
        return execute { goalReadingService.frequentlyAddedFood(apiRequest) }
    }

    override suspend fun addMeal(apiRequest: ApiRequest): DataWrapper<FoodInsightResData> {
        return execute { goalReadingService.addMeal(apiRequest) }.apply {

            responseBody?.data?.let {
                val foodInsightResData = responseBody.data

                val todayAchievedValue =
                    foodInsightResData.todays_achieved_value?.toDoubleOrNull()?.toInt() ?: 0
                val targetValue =
                    foodInsightResData.target_value?.toDoubleOrNull()?.toInt() ?: 0

                if (targetValue in 1..todayAchievedValue) {
                    analytics.logEvent(analytics.GOAL_COMPLETED, Bundle().apply {
                        putString(analytics.PARAM_GOAL_ID, foodInsightResData.goal_master_id)
                        putString(analytics.PARAM_GOAL_VALUE, targetValue.toString())
                    }, screenName = AnalyticsScreenNames.LogGoal)
                }
            }

        }
    }

    override suspend fun editMeal(apiRequest: ApiRequest): DataWrapper<FoodInsightResData> {
        return execute { goalReadingService.editMeal(apiRequest) }.apply {

            responseBody?.data?.let {
                val foodInsightResData = responseBody.data

                val todayAchievedValue =
                    foodInsightResData.todays_achieved_value?.toDoubleOrNull()?.toInt() ?: 0
                val targetValue =
                    foodInsightResData.target_value?.toDoubleOrNull()?.toInt() ?: 0

                if (targetValue in 1..todayAchievedValue) {
                    analytics.logEvent(analytics.GOAL_COMPLETED, Bundle().apply {
                        putString(analytics.PARAM_GOAL_ID, foodInsightResData.goal_master_id)
                        putString(analytics.PARAM_GOAL_VALUE, targetValue.toString())
                    }, screenName = AnalyticsScreenNames.LogGoal)
                }
            }

        }
    }

    override suspend fun mealTypes(apiRequest: ApiRequest): DataWrapper<ArrayList<MealTypeData>> {
        return execute { goalReadingService.mealTypes(apiRequest) }
    }

    override suspend fun foodInsight(apiRequest: ApiRequest): DataWrapper<FoodInsightResData> {
        return execute { goalReadingService.foodInsight(apiRequest) }
    }

    override suspend fun foodLogs(apiRequest: ApiRequest): DataWrapper<FoodLogResData> {
        return execute { goalReadingService.foodLogs(apiRequest) }
    }

    override suspend fun getMonthlyDietCal(apiRequest: ApiRequest): DataWrapper<ArrayList<MonthlyCalData>> {
        return execute { goalReadingService.getMonthlyDietCal(apiRequest) }
    }

    override suspend fun patientMealRelById(apiRequest: ApiRequest): DataWrapper<AddedPatientMealData> {
        return execute { goalReadingService.patientMealRelById(apiRequest) }
    }

    override suspend fun calculateBmrMonths(apiRequest: ApiRequest): DataWrapper<ArrayList<WeightGoalMonthsData>> {
        return execute { goalReadingService.calculateBmrMonths(apiRequest) }
    }

    override suspend fun calculateBmrCalories(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { goalReadingService.calculateBmrCalories(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.userSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun checkBmrDisclaimer(apiRequest: ApiRequest): DataWrapper<BmrDisclaimerData> {
        return execute { goalReadingService.checkBmrDisclaimer(apiRequest) }
    }

    override suspend fun dietPlanList(apiRequest: ApiRequest): DataWrapper<ArrayList<Diet>> {
        return execute { goalReadingService.dietPlanList(apiRequest) }
    }

    override suspend fun vitalsTrendAnalysis(apiRequest: ApiRequest): DataWrapper<BcaReadingsTrendsData> {
        return execute { goalReadingService.vitalsTrendAnalysis(apiRequest) }
    }

    override suspend fun updateBcaReadings(apiRequest: UpdateBcaVitalsApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.updateBcaReadings(apiRequest) }
    }

    override suspend fun getBcaVitals(apiRequest: ApiRequest): DataWrapper<GetBcaReadingsMainData> {
        return execute { goalReadingService.getBcaVitals(apiRequest) }
    }

    override suspend fun generateBcaReport(apiRequest: ApiRequest): DataWrapper<String> {
        return execute { goalReadingService.generateBcaReport(apiRequest) }
    }

    override suspend fun spirometerTestList(apiRequest: ApiRequest): DataWrapper<ArrayList<SpirometerTestResData>> {
        return execute { goalReadingService.spirometerTestList(apiRequest) }
    }

    override suspend fun updateSpirometerData(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.updateSpirometerData(apiRequest) }
    }

    override suspend fun updateIncentiveSpirometerData(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.updateIncentiveSpirometerData(apiRequest) }
    }

    override suspend fun getIncidentSurvey(apiRequest: ApiRequest): DataWrapper<IncidentSurveyData> {
        return execute { goalReadingService.getIncidentSurvey(apiRequest) }
    }

    override suspend fun addIncidentDetails(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.addIncidentDetails(apiRequest) }
    }

    override suspend fun fetchIncidentList(apiRequest: ApiRequest): DataWrapper<IncidentDetailsAllData> {
        return execute { goalReadingService.fetchIncidentList(apiRequest) }
    }

    override suspend fun getQuiz(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.getQuiz(apiRequest) }
    }

    override suspend fun quizQuestionIds(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.quizQuestionIds(apiRequest) }
    }

    override suspend fun addQuizAnswers(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.addQuizAnswers(apiRequest) }
    }

    override suspend fun addPollAnswers(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { goalReadingService.addPollAnswers(apiRequest) }
    }

    override suspend fun getIncidentFreeDays(apiRequest: ApiRequest): DataWrapper<LastIncidentData> {
        return execute { goalReadingService.getIncidentFreeDays(apiRequest) }
    }

    override suspend fun getIncidentDurationOccuranceList(apiRequest: ApiRequest): DataWrapper<ArrayList<IncidentDetailsMainData>> {
        return execute { goalReadingService.getIncidentDurationOccuranceList(apiRequest) }
    }

    override suspend fun getPollQuiz(apiRequest: ApiRequest): DataWrapper<QuizPoleMainData> {
        return execute { goalReadingService.getPollQuiz(apiRequest) }
    }

    override suspend fun myHealthInsights(apiRequest: ApiRequest): DataWrapper<MyHealthInsightData> {
        return execute { goalReadingService.myHealthInsights(apiRequest) }
    }
}
