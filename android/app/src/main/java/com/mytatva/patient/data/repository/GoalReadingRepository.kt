package com.mytatva.patient.data.repository

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

interface GoalReadingRepository {
    suspend fun updateGoalLogs(apiRequest: ApiRequest): DataWrapper<ArrayList<UpdateGoalLogsResData>>
    suspend fun updatePatientReadings(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getExerciseList(apiRequest: ApiRequest): DataWrapper<List<ExerciseData>>
    suspend fun goalDailySummary(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun dailySummary(apiRequest: ApiRequest): DataWrapper<DailySummaryData>
    suspend fun getReadingRecords(apiRequest: ApiRequest): DataWrapper<ChartRecordData>
    suspend fun getGoalRecords(apiRequest: ApiRequest): DataWrapper<ChartRecordData>
    suspend fun updatePatientDoses(
        apiRequest: ApiRequest,
        goalMasterId: String?
    ): DataWrapper<UpdatePatientDosesResData>

    suspend fun patientTodaysMedicationList(apiRequest: ApiRequest): DataWrapper<MedicationMainData>
    suspend fun lastSevenDaysMedication(apiRequest: ApiRequest): DataWrapper<List<MedicationSummaryData>>
    suspend fun updateReadingsGoals(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun addCatSurvey(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getCatSurvey(apiRequest: ApiRequest): DataWrapper<CatSurveyData>
    suspend fun myHealthInsights(apiRequest: ApiRequest): DataWrapper<MyHealthInsightData>

    //food diet goal
    suspend fun searchFood(apiRequest: ApiRequest): DataWrapper<ArrayList<FoodItemData>>
    suspend fun frequentlyAddedFood(apiRequest: ApiRequest): DataWrapper<ArrayList<FoodItemData>>
    suspend fun addMeal(apiRequest: ApiRequest): DataWrapper<FoodInsightResData>
    suspend fun editMeal(apiRequest: ApiRequest): DataWrapper<FoodInsightResData>
    suspend fun mealTypes(apiRequest: ApiRequest): DataWrapper<ArrayList<MealTypeData>>
    suspend fun foodInsight(apiRequest: ApiRequest): DataWrapper<FoodInsightResData>
    suspend fun foodLogs(apiRequest: ApiRequest): DataWrapper<FoodLogResData>
    suspend fun getMonthlyDietCal(apiRequest: ApiRequest): DataWrapper<ArrayList<MonthlyCalData>>
    suspend fun patientMealRelById(apiRequest: ApiRequest): DataWrapper<AddedPatientMealData>

    suspend fun calculateBmrMonths(apiRequest: ApiRequest): DataWrapper<ArrayList<WeightGoalMonthsData>>
    suspend fun calculateBmrCalories(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun checkBmrDisclaimer(apiRequest: ApiRequest): DataWrapper<BmrDisclaimerData>

    suspend fun dietPlanList(apiRequest: ApiRequest): DataWrapper<ArrayList<Diet>>

    suspend fun vitalsTrendAnalysis(apiRequest: ApiRequest): DataWrapper<BcaReadingsTrendsData>
    suspend fun updateBcaReadings(apiRequest: UpdateBcaVitalsApiRequest): DataWrapper<Any>
    suspend fun getBcaVitals(apiRequest: ApiRequest): DataWrapper<GetBcaReadingsMainData>

    suspend fun generateBcaReport(apiRequest: ApiRequest): DataWrapper<String>

    suspend fun spirometerTestList(apiRequest: ApiRequest): DataWrapper<ArrayList<SpirometerTestResData>>
    suspend fun updateSpirometerData(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateIncentiveSpirometerData(apiRequest: ApiRequest): DataWrapper<Any>


    //surveys
    suspend fun getIncidentSurvey(apiRequest: ApiRequest): DataWrapper<IncidentSurveyData>
    suspend fun addIncidentDetails(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun fetchIncidentList(apiRequest: ApiRequest): DataWrapper<IncidentDetailsAllData>
    suspend fun getQuiz(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun quizQuestionIds(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun addQuizAnswers(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun addPollAnswers(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getIncidentFreeDays(apiRequest: ApiRequest): DataWrapper<LastIncidentData>
    suspend fun getIncidentDurationOccuranceList(apiRequest: ApiRequest): DataWrapper<ArrayList<IncidentDetailsMainData>>
    suspend fun getPollQuiz(apiRequest: ApiRequest): DataWrapper<QuizPoleMainData>
}