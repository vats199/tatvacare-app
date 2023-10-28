package com.mytatva.patient.data.service

import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.pojo.ResponseBody
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.*
import retrofit2.http.Body
import retrofit2.http.POST

interface EngageContentService {

    @POST(URLFactory.Content.TOPIC_LIST)
    suspend fun topicList(@Body apiRequest: ApiRequest): ResponseBody<List<TopicsData>>

    @POST(URLFactory.Content.CONTENT_LIST)
    suspend fun contentList(@Body apiRequest: ApiRequestSubData): ResponseBody<List<ContentData>>

    @POST(URLFactory.Content.CONTENT_BY_ID)
    suspend fun contentById(@Body apiRequest: ApiRequest): ResponseBody<ContentData>

    @POST(URLFactory.Content.CONTENT_FILTERS)
    suspend fun contentFilters(@Body apiRequest: ApiRequest): ResponseBody<ContentFiltersData>

    @POST(URLFactory.Content.UPDATE_COMMENT)
    suspend fun updateComment(@Body apiRequest: ApiRequest): ResponseBody<ContentData>

    @POST(URLFactory.Content.UPDATE_VIEW_COUNT)
    suspend fun updateViewCount(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.UPDATE_SHARE_COUNT)
    suspend fun updateShareCount(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.UPDATE_BOOKMARKS)
    suspend fun updateBookmarks(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.UPDATE_LIKES)
    suspend fun updateLikes(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.REPORT_COMMENT)
    suspend fun reportComment(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.REMOVE_COMMENT)
    suspend fun removeComment(@Body apiRequest: ApiRequest): ResponseBody<ContentData>

    @POST(URLFactory.Content.BOOKMARK_CONTENT_LIST)
    suspend fun bookmarkContentList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<BookmarkedContentData>>

    @POST(URLFactory.Content.BOOKMARK_CONTENT_LIST_BY_TYPE)
    suspend fun bookmarkContentListByType(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<ContentData>>

    @POST(URLFactory.Content.COMMENT_LIST)
    suspend fun commentList(@Body apiRequest: ApiRequest): ResponseBody<Comment>

    @POST(URLFactory.Content.STAY_INFORMED)
    suspend fun stayInformed(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<ContentData>>

    @POST(URLFactory.Content.RECOMMENDED_CONTENT)
    suspend fun recommendedContent(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<ContentData>>

    @POST(URLFactory.Content.EXERCISE_LIST)
    suspend fun exerciseList(@Body apiRequest: ApiRequestSubData): ResponseBody<ArrayList<ExerciseMainData>>

    @POST(URLFactory.Content.EXERCISE_LIST_BY_GENRE_ID)
    suspend fun exerciseListByGenreId(@Body apiRequest: ApiRequestSubData): ResponseBody<ArrayList<ContentData>>

    @POST(URLFactory.Content.UTENSIL_LIST)
    suspend fun utensilList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<FoodQtyUtensilData>>

    @POST(URLFactory.Content.EXERCISE_FILTERS)
    suspend fun exerciseFilters(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<ExerciseFilterMainData>>

    @POST(URLFactory.Content.EXERCISE_BOOKMARK_LIST)
    suspend fun exerciseBookmarkList(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.EXERCISE_PLAN_LIST)
    suspend fun exercisePlanList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<ExercisePlanData>>

    @POST(URLFactory.Content.PLAN_DAYS_LIST)
    suspend fun planDaysList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<ExercisePlanDayData>>

    @POST(URLFactory.Content.UPDATE_BREATHING_EXERCISE_LOG)
    suspend fun updateBreathingExerciseLog(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.PLAN_DAYS_DETAILS_BY_ID)
    suspend fun planDaysDetailsById(@Body apiRequest: ApiRequest): ResponseBody<ExercisePlanDayData>

    @POST(URLFactory.Content.PLAN_DAYS_LIST_CUSTOMISED)
    suspend fun planDaysListCustomised(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<ExercisePlanDayData>>

    @POST(URLFactory.Content.UPDATE_BREATHING_EXERCISE_LOG_CUSTOMISED)
    suspend fun updateBreathingExerciseLogCustomised(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.PLAN_DAYS_DETAILS_BY_ID_CUSTOMISED)
    suspend fun planDaysDetailsByIdCustomised(@Body apiRequest: ApiRequest): ResponseBody<ExercisePlanDayData>

    //exercise - new APIs after exercise revamp changes as per Sprint May1 2023
    @POST(URLFactory.Content.EXERCISE_PLAN_DETAILS)
    suspend fun exercisePlanDetails(@Body apiRequest: ApiRequest): ResponseBody<MyRoutineMainData>

    @POST(URLFactory.Content.EXERCISE_PLAN_MARK_AS_DONE)
    suspend fun exercisePlanMarkAsDone(@Body apiRequest: ApiRequest): ResponseBody<GoalReadingData>

    @POST(URLFactory.Content.EXERCISE_PLAN_UPDATE_DIFFICULTY)
    suspend fun exercisePlanUpdateDifficulty(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.EXERCISE_PLAN_MARK_AS_DONE_MULTI)
    suspend fun exercisePlanMarkAsDoneMultiple(@Body apiRequest: ApiRequest): ResponseBody<Any>
    //===========================================================================

    @POST(URLFactory.Content.QUESTION_LIST)
    suspend fun questionList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<QuestionsData>>

    @POST(URLFactory.Content.POST_QUESTION)
    suspend fun postQuestion(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.POST_QUESTION_UPDATE)
    suspend fun postQuestionUpdate(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.QUESTION_DELETE)
    suspend fun questionDelete(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.UPDATE_ANSWER)
    suspend fun updateAnswer(@Body apiRequest: ApiRequest): ResponseBody<QuestionsData>

    @POST(URLFactory.Content.ANSWERS_LIST)
    suspend fun answersList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<AnswerData>>

    @POST(URLFactory.Content.ANSWER_COMMENT_DELETE)
    suspend fun answerCommentDelete(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.ANSWER_DELETE)
    suspend fun answerDelete(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.ANSWER_DETAIL)
    suspend fun answerDetail(@Body apiRequest: ApiRequest): ResponseBody<AnswerDetailsResData>

    @POST(URLFactory.Content.UPDATE_ANSWER_REPLY)
    suspend fun updateAnswerReply(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.ANSWER_COMMENT_UPDATE_LIKE)
    suspend fun answerCommentUpdateLike(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.CONTENT_REPORT)
    suspend fun contentReport(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.REPORT_ANSWER_COMMENT)
    suspend fun reportAnswerComment(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Content.ASK_AN_EXPERT_FILTERS)
    suspend fun askAnExpertFilters(@Body apiRequest: ApiRequest): ResponseBody<AskAnExpertFiltersData>

    @POST(URLFactory.Content.QUESTION_DETAIL)
    suspend fun questionDetail(@Body apiRequest: ApiRequest): ResponseBody<QuestionsData>

    @POST(URLFactory.Content.ANSWER_COMMENTS)
    suspend fun answerComments(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<AnswerCommentData>>
}