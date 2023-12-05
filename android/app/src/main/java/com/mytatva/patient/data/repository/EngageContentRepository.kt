package com.mytatva.patient.data.repository

import com.mytatva.patient.data.pojo.DataWrapper
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.AnswerCommentData
import com.mytatva.patient.data.pojo.response.AnswerData
import com.mytatva.patient.data.pojo.response.AnswerDetailsResData
import com.mytatva.patient.data.pojo.response.AskAnExpertFiltersData
import com.mytatva.patient.data.pojo.response.BookmarkedContentData
import com.mytatva.patient.data.pojo.response.Comment
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.data.pojo.response.ContentFiltersData
import com.mytatva.patient.data.pojo.response.ExerciseFilterMainData
import com.mytatva.patient.data.pojo.response.ExerciseMainData
import com.mytatva.patient.data.pojo.response.ExercisePlanData
import com.mytatva.patient.data.pojo.response.ExercisePlanDayData
import com.mytatva.patient.data.pojo.response.FoodQtyUtensilData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.data.pojo.response.MyRoutineMainData
import com.mytatva.patient.data.pojo.response.QuestionsData
import com.mytatva.patient.data.pojo.response.TopicsData

interface EngageContentRepository {
    suspend fun topicList(apiRequest: ApiRequest): DataWrapper<List<TopicsData>>
    suspend fun contentList(apiRequest: ApiRequestSubData): DataWrapper<List<ContentData>>
    suspend fun contentById(apiRequest: ApiRequest): DataWrapper<ContentData>
    suspend fun contentFilters(apiRequest: ApiRequest): DataWrapper<ContentFiltersData>
    suspend fun updateComment(apiRequest: ApiRequest): DataWrapper<ContentData>
    suspend fun updateViewCount(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateShareCount(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateBookmarks(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateLikes(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun reportComment(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun removeComment(apiRequest: ApiRequest, screenName: String): DataWrapper<ContentData>
    suspend fun bookmarkContentList(apiRequest: ApiRequest): DataWrapper<ArrayList<BookmarkedContentData>>
    suspend fun bookmarkContentListByType(apiRequest: ApiRequest): DataWrapper<ArrayList<ContentData>>
    suspend fun commentList(apiRequest: ApiRequest): DataWrapper<Comment>
    suspend fun stayInformed(apiRequest: ApiRequest): DataWrapper<ArrayList<ContentData>>
    suspend fun recommendedContent(apiRequest: ApiRequest): DataWrapper<ArrayList<ContentData>>

    suspend fun exerciseList(apiRequest: ApiRequestSubData): DataWrapper<ArrayList<ExerciseMainData>>
    suspend fun exerciseListByGenreId(apiRequest: ApiRequestSubData): DataWrapper<ArrayList<ContentData>>
    suspend fun utensilList(apiRequest: ApiRequest): DataWrapper<ArrayList<FoodQtyUtensilData>>
    suspend fun exerciseFilters(apiRequest: ApiRequest): DataWrapper<ArrayList<ExerciseFilterMainData>>
    suspend fun exerciseBookmarkList(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun exercisePlanList(apiRequest: ApiRequest): DataWrapper<ArrayList<ExercisePlanData>>
    suspend fun planDaysList(apiRequest: ApiRequest): DataWrapper<ArrayList<ExercisePlanDayData>>
    suspend fun updateBreathingExerciseLog(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun planDaysDetailsById(apiRequest: ApiRequest): DataWrapper<ExercisePlanDayData>

    suspend fun planDaysListCustomised(apiRequest: ApiRequest): DataWrapper<ArrayList<ExercisePlanDayData>>
    suspend fun updateBreathingExerciseLogCustomised(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun planDaysDetailsByIdCustomised(apiRequest: ApiRequest): DataWrapper<ExercisePlanDayData>


    suspend fun exercisePlanDetails(apiRequest: ApiRequest): DataWrapper<MyRoutineMainData>
    suspend fun exercisePlanMarkAsDone(apiRequest: ApiRequest): DataWrapper<GoalReadingData>
    suspend fun exercisePlanUpdateDifficulty(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun exercisePlanMarkAsDoneMultiple(apiRequest: ApiRequest): DataWrapper<Any>

    //ask an expert
    suspend fun questionList(apiRequest: ApiRequest): DataWrapper<ArrayList<QuestionsData>>
    suspend fun postQuestion(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun postQuestionUpdate(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun questionDelete(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateAnswer(apiRequest: ApiRequest): DataWrapper<QuestionsData>
    suspend fun answersList(apiRequest: ApiRequest): DataWrapper<ArrayList<AnswerData>>
    suspend fun answerCommentDelete(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun answerDelete(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun answerDetail(apiRequest: ApiRequest): DataWrapper<AnswerDetailsResData>
    suspend fun updateAnswerReply(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun answerCommentUpdateLike(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun contentReport(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun reportAnswerComment(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun askAnExpertFilters(apiRequest: ApiRequest): DataWrapper<AskAnExpertFiltersData>
    suspend fun questionDetail(apiRequest: ApiRequest): DataWrapper<QuestionsData>
    suspend fun answerComments(apiRequest: ApiRequest): DataWrapper<ArrayList<AnswerCommentData>>
}