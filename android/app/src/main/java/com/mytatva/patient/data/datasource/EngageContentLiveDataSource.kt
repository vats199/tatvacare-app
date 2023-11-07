package com.mytatva.patient.data.datasource

import android.os.Bundle
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.DataWrapper
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.*
import com.mytatva.patient.data.repository.EngageContentRepository
import com.mytatva.patient.data.service.EngageContentService
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class EngageContentLiveDataSource @Inject constructor(private val engageContentService: EngageContentService) :
    BaseDataSource(), EngageContentRepository {

    @Inject
    lateinit var session: Session

    @Inject
    lateinit var analytics: AnalyticsClient

    override suspend fun topicList(apiRequest: ApiRequest): DataWrapper<List<TopicsData>> {
        return execute { engageContentService.topicList(apiRequest) }
    }

    override suspend fun contentList(apiRequest: ApiRequestSubData): DataWrapper<List<ContentData>> {
        return execute { engageContentService.contentList(apiRequest) }
    }

    override suspend fun contentById(apiRequest: ApiRequest): DataWrapper<ContentData> {
        return execute { engageContentService.contentById(apiRequest) }
    }

    override suspend fun contentFilters(apiRequest: ApiRequest): DataWrapper<ContentFiltersData> {
        return execute { engageContentService.contentFilters(apiRequest) }
    }

    override suspend fun updateComment(apiRequest: ApiRequest): DataWrapper<ContentData> {
        return execute { engageContentService.updateComment(apiRequest) }
    }

    override suspend fun updateViewCount(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.updateViewCount(apiRequest) }
    }

    override suspend fun updateShareCount(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.updateShareCount(apiRequest) }
    }

    override suspend fun updateBookmarks(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.updateBookmarks(apiRequest) }
    }

    override suspend fun updateLikes(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.updateLikes(apiRequest) }
    }

    override suspend fun reportComment(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.reportComment(apiRequest) }
    }

    override suspend fun removeComment(
        apiRequest: ApiRequest,
        screenName: String,
    ): DataWrapper<ContentData> {
        return execute { engageContentService.removeComment(apiRequest) }.apply {
            analytics.logEvent(analytics.USER_DELETED_OWN_COMMENT, Bundle().apply {
                putString(analytics.PARAM_CONTENT_COMMENTS_ID, apiRequest.content_comments_id)
            }, screenName = screenName)
        }
    }

    override suspend fun bookmarkContentList(apiRequest: ApiRequest): DataWrapper<ArrayList<BookmarkedContentData>> {
        return execute { engageContentService.bookmarkContentList(apiRequest) }
    }

    override suspend fun bookmarkContentListByType(apiRequest: ApiRequest): DataWrapper<ArrayList<ContentData>> {
        return execute { engageContentService.bookmarkContentListByType(apiRequest) }
    }

    override suspend fun commentList(apiRequest: ApiRequest): DataWrapper<Comment> {
        return execute { engageContentService.commentList(apiRequest) }
    }

    override suspend fun stayInformed(apiRequest: ApiRequest): DataWrapper<ArrayList<ContentData>> {
        return execute { engageContentService.stayInformed(apiRequest) }
    }

    override suspend fun recommendedContent(apiRequest: ApiRequest): DataWrapper<ArrayList<ContentData>> {
        return execute { engageContentService.recommendedContent(apiRequest) }
    }

    override suspend fun exerciseList(apiRequest: ApiRequestSubData): DataWrapper<ArrayList<ExerciseMainData>> {
        return execute { engageContentService.exerciseList(apiRequest) }
    }

    override suspend fun exerciseListByGenreId(apiRequest: ApiRequestSubData): DataWrapper<ArrayList<ContentData>> {
        return execute { engageContentService.exerciseListByGenreId(apiRequest) }
    }

    override suspend fun utensilList(apiRequest: ApiRequest): DataWrapper<ArrayList<FoodQtyUtensilData>> {
        return execute { engageContentService.utensilList(apiRequest) }
    }

    override suspend fun exerciseFilters(apiRequest: ApiRequest): DataWrapper<ArrayList<ExerciseFilterMainData>> {
        return execute { engageContentService.exerciseFilters(apiRequest) }
    }

    override suspend fun exerciseBookmarkList(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.exerciseBookmarkList(apiRequest) }
    }

    override suspend fun exercisePlanList(apiRequest: ApiRequest): DataWrapper<ArrayList<ExercisePlanData>> {
        return execute { engageContentService.exercisePlanList(apiRequest) }
    }

    override suspend fun planDaysList(apiRequest: ApiRequest): DataWrapper<ArrayList<ExercisePlanDayData>> {
        return execute { engageContentService.planDaysList(apiRequest) }
    }

    override suspend fun updateBreathingExerciseLog(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.updateBreathingExerciseLog(apiRequest) }
    }

    override suspend fun planDaysDetailsById(apiRequest: ApiRequest): DataWrapper<ExercisePlanDayData> {
        return execute { engageContentService.planDaysDetailsById(apiRequest) }
    }

    override suspend fun planDaysListCustomised(apiRequest: ApiRequest): DataWrapper<ArrayList<ExercisePlanDayData>> {
        return execute { engageContentService.planDaysListCustomised(apiRequest) }
    }

    override suspend fun updateBreathingExerciseLogCustomised(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.updateBreathingExerciseLogCustomised(apiRequest) }
    }

    override suspend fun planDaysDetailsByIdCustomised(apiRequest: ApiRequest): DataWrapper<ExercisePlanDayData> {
        return execute { engageContentService.planDaysDetailsByIdCustomised(apiRequest) }
    }

    override suspend fun exercisePlanDetails(apiRequest: ApiRequest): DataWrapper<MyRoutineMainData> {
        return execute { engageContentService.exercisePlanDetails(apiRequest) }
    }

    override suspend fun exercisePlanMarkAsDone(apiRequest: ApiRequest): DataWrapper<GoalReadingData> {
        return execute { engageContentService.exercisePlanMarkAsDone(apiRequest) }
    }

    override suspend fun exercisePlanUpdateDifficulty(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.exercisePlanUpdateDifficulty(apiRequest) }
    }

    override suspend fun exercisePlanMarkAsDoneMultiple(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.exercisePlanMarkAsDoneMultiple(apiRequest) }
    }

    override suspend fun questionList(apiRequest: ApiRequest): DataWrapper<ArrayList<QuestionsData>> {
        return execute { engageContentService.questionList(apiRequest) }
    }

    override suspend fun postQuestion(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.postQuestion(apiRequest) }
    }

    override suspend fun postQuestionUpdate(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.postQuestionUpdate(apiRequest) }
    }

    override suspend fun questionDelete(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.questionDelete(apiRequest) }
    }

    override suspend fun updateAnswer(apiRequest: ApiRequest): DataWrapper<QuestionsData> {
        return execute { engageContentService.updateAnswer(apiRequest) }
    }

    override suspend fun answersList(apiRequest: ApiRequest): DataWrapper<ArrayList<AnswerData>> {
        return execute { engageContentService.answersList(apiRequest) }
    }

    override suspend fun answerCommentDelete(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.answerCommentDelete(apiRequest) }
    }

    override suspend fun answerDelete(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.answerDelete(apiRequest) }
    }

    override suspend fun answerDetail(apiRequest: ApiRequest): DataWrapper<AnswerDetailsResData> {
        return execute { engageContentService.answerDetail(apiRequest) }
    }

    override suspend fun updateAnswerReply(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.updateAnswerReply(apiRequest) }
    }

    override suspend fun answerCommentUpdateLike(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.answerCommentUpdateLike(apiRequest) }
    }

    override suspend fun contentReport(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.contentReport(apiRequest) }
    }

    override suspend fun reportAnswerComment(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { engageContentService.reportAnswerComment(apiRequest) }
    }

    override suspend fun askAnExpertFilters(apiRequest: ApiRequest): DataWrapper<AskAnExpertFiltersData> {
        return execute { engageContentService.askAnExpertFilters(apiRequest) }
    }

    override suspend fun questionDetail(apiRequest: ApiRequest): DataWrapper<QuestionsData> {
        return execute { engageContentService.questionDetail(apiRequest) }
    }

    override suspend fun answerComments(apiRequest: ApiRequest): DataWrapper<ArrayList<AnswerCommentData>> {
        return execute { engageContentService.answerComments(apiRequest) }
    }
}
