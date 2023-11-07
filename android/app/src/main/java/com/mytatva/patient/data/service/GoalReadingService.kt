package com.mytatva.patient.data.service

import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.pojo.ResponseBody
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.UpdateBcaVitalsApiRequest
import com.mytatva.patient.data.pojo.response.*
import retrofit2.http.Body
import retrofit2.http.POST

interface GoalReadingService {

    //goal readings
    @POST(URLFactory.GoalReading.UPDATE_GOAL_LOGS)
    suspend fun updateGoalLogs(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<UpdateGoalLogsResData>>

    @POST(URLFactory.GoalReading.UPDATE_PATIENT_READINGS)
    suspend fun updatePatientReadings(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.GoalReading.GET_EXERCISE_LIST)
    suspend fun getExerciseList(@Body apiRequest: ApiRequest): ResponseBody<List<ExerciseData>>

    @POST(URLFactory.GoalReading.GOAL_DAILY_SUMMARY)
    suspend fun goalDailySummary(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.GoalReading.DAILY_SUMMARY)
    suspend fun dailySummary(@Body apiRequest: ApiRequest): ResponseBody<DailySummaryData>

    @POST(URLFactory.GoalReading.GET_READING_RECORDS)
    suspend fun getReadingRecords(@Body apiRequest: ApiRequest): ResponseBody<ChartRecordData>

    @POST(URLFactory.GoalReading.GET_GOAL_RECORDS)
    suspend fun getGoalRecords(@Body apiRequest: ApiRequest): ResponseBody<ChartRecordData>

    @POST(URLFactory.GoalReading.UPDATE_PATIENT_DOSES)
    suspend fun updatePatientDoses(@Body apiRequest: ApiRequest): ResponseBody<UpdatePatientDosesResData>

    @POST(URLFactory.GoalReading.PATIENT_TODAYS_MEDICATION_LIST)
    suspend fun patientTodaysMedicationList(@Body apiRequest: ApiRequest): ResponseBody<MedicationMainData>

    @POST(URLFactory.GoalReading.LAST_SEVEN_DAYS_MEDICATION)
    suspend fun lastSevenDaysMedication(@Body apiRequest: ApiRequest): ResponseBody<List<MedicationSummaryData>>

    @POST(URLFactory.GoalReading.UPDATE_READINGS_GOALS)
    suspend fun updateReadingsGoals(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.GoalReading.ADD_CAT_SURVEY)
    suspend fun addCatSurvey(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.GoalReading.GET_CAT_SURVEY)
    suspend fun getCatSurvey(@Body apiRequest: ApiRequest): ResponseBody<CatSurveyData>

    @POST(URLFactory.GoalReading.SEARCH_FOOD)
    suspend fun searchFood(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<FoodItemData>>

    @POST(URLFactory.GoalReading.FREQUENTLY_ADDED_FOOD)
    suspend fun frequentlyAddedFood(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<FoodItemData>>

    @POST(URLFactory.GoalReading.ADD_MEAL)
    suspend fun addMeal(@Body apiRequest: ApiRequest): ResponseBody<FoodInsightResData>

    @POST(URLFactory.GoalReading.EDIT_MEAL)
    suspend fun editMeal(@Body apiRequest: ApiRequest): ResponseBody<FoodInsightResData>

    @POST(URLFactory.GoalReading.MEAL_TYPES)
    suspend fun mealTypes(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<MealTypeData>>

    @POST(URLFactory.GoalReading.FOOD_INSIGHT)
    suspend fun foodInsight(@Body apiRequest: ApiRequest): ResponseBody<FoodInsightResData>

    @POST(URLFactory.GoalReading.FOOD_LOGS)
    suspend fun foodLogs(@Body apiRequest: ApiRequest): ResponseBody<FoodLogResData>

    @POST(URLFactory.GoalReading.GET_MONTHLY_DIET_CAL)
    suspend fun getMonthlyDietCal(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<MonthlyCalData>>

    @POST(URLFactory.GoalReading.PATIENT_MEAL_REL_BY_ID)
    suspend fun patientMealRelById(@Body apiRequest: ApiRequest): ResponseBody<AddedPatientMealData>

    @POST(URLFactory.GoalReading.CALCULATE_BMR_MONTHS)
    suspend fun calculateBmrMonths(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<WeightGoalMonthsData>>

    @POST(URLFactory.GoalReading.CALCULATE_BMR_CALORIES)
    suspend fun calculateBmrCalories(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.GoalReading.CHECK_BMR_DISCLAIMER)
    suspend fun checkBmrDisclaimer(@Body apiRequest: ApiRequest): ResponseBody<BmrDisclaimerData>

    @POST(URLFactory.GoalReading.DIET_PLAN_LIST)
    suspend fun dietPlanList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<Diet>>

    @POST(URLFactory.GoalReading.VITALS_TREND_ANALYSIS)
    suspend fun vitalsTrendAnalysis(@Body apiRequest: ApiRequest): ResponseBody<BcaReadingsTrendsData>

    @POST(URLFactory.GoalReading.UPDATE_BCA_READINGS)
    suspend fun updateBcaReadings(@Body apiRequest: UpdateBcaVitalsApiRequest): ResponseBody<Any>

    @POST(URLFactory.GoalReading.GET_BCA_VITALS)
    suspend fun getBcaVitals(@Body apiRequest: ApiRequest): ResponseBody<GetBcaReadingsMainData>

    @POST(URLFactory.GoalReading.GENERATE_BCA_REPORT)
    suspend fun generateBcaReport(@Body apiRequest: ApiRequest): ResponseBody<String>

    @POST(URLFactory.GoalReading.SPIROMETER_TEST_LIST)
    suspend fun spirometerTestList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<SpirometerTestResData>>

    @POST(URLFactory.GoalReading.UPDATE_SPIROMETER_DATA)
    suspend fun updateSpirometerData(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.GoalReading.UPDATE_INCENTIVE_SPIROMETER_DATA)
    suspend fun updateIncentiveSpirometerData(@Body apiRequest: ApiRequest): ResponseBody<Any>

    //surveys
    @POST(URLFactory.Survey.GET_INCIDENT_SURVEY)
    suspend fun getIncidentSurvey(@Body apiRequest: ApiRequest): ResponseBody<IncidentSurveyData>

    @POST(URLFactory.Survey.ADD_INCIDENT_DETAILS)
    suspend fun addIncidentDetails(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Survey.FETCH_INCIDENT_LIST)
    suspend fun fetchIncidentList(@Body apiRequest: ApiRequest): ResponseBody<IncidentDetailsAllData>

    @POST(URLFactory.Survey.GET_QUIZ)
    suspend fun getQuiz(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Survey.QUIZ_QUESTION_IDS)
    suspend fun quizQuestionIds(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Survey.ADD_QUIZ_ANSWERS)
    suspend fun addQuizAnswers(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Survey.ADD_POLL_ANSWERS)
    suspend fun addPollAnswers(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Survey.GET_INCIDENT_FREE_DAYS)
    suspend fun getIncidentFreeDays(@Body apiRequest: ApiRequest): ResponseBody<LastIncidentData>

    @POST(URLFactory.Survey.GET_INCIDENT_DURATION_OCCURANCE_LIST)
    suspend fun getIncidentDurationOccuranceList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<IncidentDetailsMainData>>

    @POST(URLFactory.Survey.GET_POLL_QUIZ)
    suspend fun getPollQuiz(@Body apiRequest: ApiRequest): ResponseBody<QuizPoleMainData>

    @POST(URLFactory.GoalReading.MY_HEALTH_INSIGHTS)
    suspend fun myHealthInsights(@Body apiRequest: ApiRequest): ResponseBody<MyHealthInsightData>

}