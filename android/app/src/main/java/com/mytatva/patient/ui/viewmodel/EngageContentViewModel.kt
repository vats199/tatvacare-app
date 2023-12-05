package com.mytatva.patient.ui.viewmodel

import android.os.Bundle
import androidx.lifecycle.viewModelScope
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
import com.mytatva.patient.data.repository.EngageContentRepository
import com.mytatva.patient.ui.base.APILiveData
import com.mytatva.patient.ui.base.BaseViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import kotlinx.coroutines.launch
import javax.inject.Inject

class EngageContentViewModel @Inject constructor(
    private val engageContentRepository: EngageContentRepository,
) : BaseViewModel() {

    /**
     * @API :- topicList
     */
    val topicListLiveData = APILiveData<List<TopicsData>>()
    fun topicList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.topicList(apiRequest)
            topicListLiveData.value = result
        }
    }

    /**
     * @API :- contentList
     */
    val contentListLiveData = APILiveData<List<ContentData>>()
    fun contentList(apiRequest: ApiRequestSubData) {
        viewModelScope.launch {
            val result = engageContentRepository.contentList(apiRequest)
            contentListLiveData.value = result
        }
    }

    /**
     * @API :- contentById
     */
    val contentByIdLiveData = APILiveData<ContentData>()
    fun contentById(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.contentById(apiRequest)
            contentByIdLiveData.value = result
        }
    }

    /**
     * @API :- contentFilters
     */
    val contentFiltersLiveData = APILiveData<ContentFiltersData>()
    fun contentFilters(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.contentFilters(apiRequest)
            contentFiltersLiveData.value = result
        }
    }

    /**
     * @API :- updateComment
     */
    val updateCommentLiveData = APILiveData<ContentData>()
    fun updateComment(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.updateComment(apiRequest)
            updateCommentLiveData.value = result
        }
    }

    /**
     * @API :- updateViewCount
     */
    val updateViewCountLiveData = APILiveData<Any>()
    fun updateViewCount(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.updateViewCount(apiRequest)
            updateViewCountLiveData.value = result
        }
    }

    /**
     * @API :- updateShareCount
     */
    val updateShareCountLiveData = APILiveData<Any>()
    fun updateShareCount(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.updateShareCount(apiRequest)
            updateShareCountLiveData.value = result
        }
    }

    /**
     * @API :- updateBookmarks
     */
    val updateBookmarksLiveData = APILiveData<Any>()
    fun updateBookmarks(
        apiRequest: ApiRequest, analytics: AnalyticsClient?, contentType: String?,
        screenName: String,
    ) {

        if (apiRequest.is_active == "Y") {
            analytics?.logEvent(
                analytics.USER_BOOKMARKED_CONTENT,
                Bundle().apply {
                    putString(
                        analytics.PARAM_CONTENT_MASTER_ID,
                        apiRequest.content_master_id
                    )
                    contentType?.let {
                        putString(analytics.PARAM_CONTENT_TYPE, contentType)
                    }
                }, screenName = screenName
            )
        } else {
            analytics?.logEvent(
                analytics.USER_UN_BOOKMARK_CONTENT,
                Bundle().apply {
                    putString(
                        analytics.PARAM_CONTENT_MASTER_ID,
                        apiRequest.content_master_id
                    )
                    contentType?.let {
                        putString(analytics.PARAM_CONTENT_TYPE, contentType)
                    }
                }, screenName = screenName
            )
        }

        viewModelScope.launch {
            val result = engageContentRepository.updateBookmarks(apiRequest)
            updateBookmarksLiveData.value = result
        }
    }

    /**
     * @API :- updateBookmarks
     * same updateBookmarks API for ask an expert module
     */
    val updateBookmarksQuestionLiveData = APILiveData<Any>()
    fun updateBookmarksQuestion(
        apiRequest: ApiRequest,
        analytics: AnalyticsClient?,
        screenName: String,
    ) {

        if (apiRequest.is_active == "Y") {
            analytics?.logEvent(
                analytics.USER_BOOKMARKED_QUESTION,
                Bundle().apply {
                    putString(
                        analytics.PARAM_CONTENT_MASTER_ID,
                        apiRequest.content_master_id
                    )
                }, screenName = screenName
            )
        } else {
            analytics?.logEvent(
                analytics.USER_UN_BOOKMARK_QUESTION,
                Bundle().apply {
                    putString(
                        analytics.PARAM_CONTENT_MASTER_ID,
                        apiRequest.content_master_id
                    )
                }, screenName = screenName
            )
        }

        viewModelScope.launch {
            val result = engageContentRepository.updateBookmarks(apiRequest)
            updateBookmarksQuestionLiveData.value = result
        }
    }

    /**
     * @API :- updateLikes
     */
    val updateLikesLiveData = APILiveData<Any>()
    fun updateLikes(
        apiRequest: ApiRequest, analytics: AnalyticsClient, contentType: String?,
        screenName: String,
    ) {

        if (apiRequest.is_active == "Y") {
            analytics.logEvent(
                analytics.USER_LIKED_CONTENT,
                Bundle().apply {
                    putString(
                        analytics.PARAM_CONTENT_MASTER_ID,
                        apiRequest.content_master_id
                    )
                    contentType?.let {
                        putString(analytics.PARAM_CONTENT_TYPE, contentType)
                    }
                }, screenName = screenName
            )
        } else {
            analytics.logEvent(
                analytics.USER_UNLIKED_CONTENT,
                Bundle().apply {
                    putString(
                        analytics.PARAM_CONTENT_MASTER_ID,
                        apiRequest.content_master_id
                    )
                    contentType?.let {
                        putString(analytics.PARAM_CONTENT_TYPE, contentType)
                    }
                }, screenName = screenName
            )
        }

        viewModelScope.launch {
            val result = engageContentRepository.updateLikes(apiRequest)
            updateLikesLiveData.value = result
        }
    }

    /**
     * @API :- reportComment
     */
    val reportCommentLiveData = APILiveData<Any>()
    fun reportComment(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.reportComment(apiRequest)
            reportCommentLiveData.value = result
        }
    }

    /**
     * @API :- removeComment
     */
    val removeCommentLiveData = APILiveData<ContentData>()
    fun removeComment(apiRequest: ApiRequest, screenName: String) {
        viewModelScope.launch {
            val result = engageContentRepository.removeComment(apiRequest, screenName)
            removeCommentLiveData.value = result
        }
    }

    /**
     * @API :- bookmarkContentList
     */
    val bookmarkContentListLiveData = APILiveData<ArrayList<BookmarkedContentData>>()
    fun bookmarkContentList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.bookmarkContentList(apiRequest)
            bookmarkContentListLiveData.value = result
        }
    }

    /**
     * @API :- bookmarkContentListByType
     */
    val bookmarkContentListByTypeLiveData = APILiveData<ArrayList<ContentData>>()
    fun bookmarkContentListByType(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.bookmarkContentListByType(apiRequest)
            bookmarkContentListByTypeLiveData.value = result
        }
    }

    /**
     * @API :- commentList
     */
    val commentListLiveData = APILiveData<Comment>()
    fun commentList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.commentList(apiRequest)
            commentListLiveData.value = result
        }
    }

    /**
     * @API :- stayInformed
     */
    val stayInformedLiveData = APILiveData<ArrayList<ContentData>>()
    fun stayInformed(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.stayInformed(apiRequest)
            stayInformedLiveData.value = result
        }
    }

    /**
     * @API :- recommendedContent
     */
    val recommendedContentLiveData = APILiveData<ArrayList<ContentData>>()
    fun recommendedContent(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.recommendedContent(apiRequest)
            recommendedContentLiveData.value = result
        }
    }

    /**
     * @API :- exerciseList
     */
    val exerciseListLiveData = APILiveData<ArrayList<ExerciseMainData>>()
    fun exerciseList(apiRequest: ApiRequestSubData) {
        viewModelScope.launch {
            val result = engageContentRepository.exerciseList(apiRequest)
            exerciseListLiveData.value = result
        }
    }

    /**
     * @API :- exerciseList
     */
    val exerciseListByGenreIdLiveData = APILiveData<ArrayList<ContentData>>()
    fun exerciseListByGenreId(apiRequest: ApiRequestSubData) {
        viewModelScope.launch {
            val result = engageContentRepository.exerciseListByGenreId(apiRequest)
            exerciseListByGenreIdLiveData.value = result
        }
    }

    /**
     * @API :- utensilList
     */
    val utensilListLiveData = APILiveData<ArrayList<FoodQtyUtensilData>>()
    fun utensilList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.utensilList(apiRequest)
            utensilListLiveData.value = result
        }
    }

    /**
     * @API :- exerciseFilters
     */
    val exerciseFiltersLiveData = APILiveData<ArrayList<ExerciseFilterMainData>>()
    fun exerciseFilters(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.exerciseFilters(apiRequest)
            exerciseFiltersLiveData.value = result
        }
    }

    /**
     * @API :- exerciseBookmarkList
     */
    val exerciseBookmarkListLiveData = APILiveData<Any>()
    fun exerciseBookmarkList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.exerciseBookmarkList(apiRequest)
            exerciseBookmarkListLiveData.value = result
        }
    }

    /**
     * @API :- exercisePlanList
     */
    val exercisePlanListLiveData = APILiveData<ArrayList<ExercisePlanData>>()
    fun exercisePlanList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.exercisePlanList(apiRequest)
            exercisePlanListLiveData.value = result
        }
    }

    /**
     * @API :- planDaysList
     */
    val planDaysListLiveData = APILiveData<ArrayList<ExercisePlanDayData>>()
    fun planDaysList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.planDaysList(apiRequest)
            planDaysListLiveData.value = result
        }
    }

    /**
     * @API :- updateBreathingExerciseLog
     */
    val updateBreathingExerciseLogLiveData = APILiveData<Any>()
    fun updateBreathingExerciseLog(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.updateBreathingExerciseLog(apiRequest)
            updateBreathingExerciseLogLiveData.value = result
        }
    }

    /**
     * @API :- planDaysDetailsById
     */
    val planDaysDetailsByIdLiveData = APILiveData<ExercisePlanDayData>()
    fun planDaysDetailsById(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.planDaysDetailsById(apiRequest)
            planDaysDetailsByIdLiveData.value = result
        }
    }

    /**
     * @API :- planDaysListCustomised
     */
    val planDaysListCustomisedLiveData = APILiveData<ArrayList<ExercisePlanDayData>>()
    fun planDaysListCustomised(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.planDaysListCustomised(apiRequest)
            planDaysListCustomisedLiveData.value = result
        }
    }

    /**
     * @API :- updateBreathingExerciseLogCustomised
     */
    val updateBreathingExerciseLogCustomisedLiveData = APILiveData<Any>()
    fun updateBreathingExerciseLogCustomised(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.updateBreathingExerciseLogCustomised(apiRequest)
            updateBreathingExerciseLogCustomisedLiveData.value = result
        }
    }

    /**
     * @API :- planDaysDetailsByIdCustomised
     */
    val planDaysDetailsByIdCustomisedLiveData = APILiveData<ExercisePlanDayData>()
    fun planDaysDetailsByIdCustomised(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.planDaysDetailsByIdCustomised(apiRequest)
            planDaysDetailsByIdCustomisedLiveData.value = result
        }
    }

    //exercise - new APIs after exercise revamp changes as per Sprint May1 2023 - START
    /**
     * @API :- exercisePlanDetails
     */
    val exercisePlanDetailsLiveData = APILiveData<MyRoutineMainData>()
    fun exercisePlanDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.exercisePlanDetails(apiRequest)
            exercisePlanDetailsLiveData.value = result
        }
    }

    /**
     * @API :- exercisePlanMarkAsDone
     */
    val exercisePlanMarkAsDoneLiveData = APILiveData<GoalReadingData>()
    fun exercisePlanMarkAsDone(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.exercisePlanMarkAsDone(apiRequest)
            exercisePlanMarkAsDoneLiveData.value = result
        }
    }

    /**
     * @API :- exercisePlanUpdateDifficulty
     */
    val exercisePlanUpdateDifficultyLiveData = APILiveData<Any>()
    fun exercisePlanUpdateDifficulty(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.exercisePlanUpdateDifficulty(apiRequest)
            exercisePlanUpdateDifficultyLiveData.value = result
        }
    }

    /**
     * @API :- exercisePlanMarkAsDoneMultiple REMOVED
     */
    /*val exercisePlanMarkAsDoneMultipleLiveData = APILiveData<Any>()
    fun exercisePlanMarkAsDoneMultiple(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.exercisePlanMarkAsDoneMultiple(apiRequest)
            exercisePlanMarkAsDoneMultipleLiveData.value = result
        }
    }*/
    //exercise - new APIs after exercise revamp changes as per Sprint May1 2023 - END

    /* ***************************************************
     * Ask an expert APIs
     *************************************************** */
    /**
     * @API :- questionList
     */
    val questionListLiveData = APILiveData<ArrayList<QuestionsData>>()
    fun questionList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.questionList(apiRequest)
            questionListLiveData.value = result
        }
    }

    /**
     * @API :- postQuestion
     */
    val postQuestionLiveData = APILiveData<Any>()
    fun postQuestion(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.postQuestion(apiRequest)
            postQuestionLiveData.value = result
        }
    }

    /**
     * @API :- postQuestionUpdate
     */
    val postQuestionUpdateLiveData = APILiveData<Any>()
    fun postQuestionUpdate(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.postQuestionUpdate(apiRequest)
            postQuestionUpdateLiveData.value = result
        }
    }

    /**
     * @API :- questionDelete
     */
    val questionDeleteLiveData = APILiveData<Any>()
    fun questionDelete(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.questionDelete(apiRequest)
            questionDeleteLiveData.value = result
        }
    }

    /**
     * @API :- updateAnswer
     */
    val updateAnswerLiveData = APILiveData<QuestionsData>()
    fun updateAnswer(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.updateAnswer(apiRequest)
            updateAnswerLiveData.value = result
        }
    }

    /**
     * @API :- answersList
     */
    val answersListLiveData = APILiveData<ArrayList<AnswerData>>()
    fun answersList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.answersList(apiRequest)
            answersListLiveData.value = result
        }
    }

    /**
     * @API :- answerCommentDelete
     */
    val answerCommentDeleteLiveData = APILiveData<Any>()
    fun answerCommentDelete(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.answerCommentDelete(apiRequest)
            answerCommentDeleteLiveData.value = result
        }
    }

    /**
     * @API :- answerCommentDelete
     */
    val answerDeleteLiveData = APILiveData<Any>()
    fun answerDelete(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.answerDelete(apiRequest)
            answerDeleteLiveData.value = result
        }
    }

    /**
     * @API :- answerDetail
     */
    val answerDetailLiveData = APILiveData<AnswerDetailsResData>()
    fun answerDetail(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.answerDetail(apiRequest)
            answerDetailLiveData.value = result
        }
    }

    /**
     * @API :- updateAnswerReply
     */
    val updateAnswerReplyLiveData = APILiveData<Any>()
    fun updateAnswerReply(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.updateAnswerReply(apiRequest)
            updateAnswerReplyLiveData.value = result
        }
    }

    /**
     * @API :- answerCommentUpdateLike
     */
    val answerCommentUpdateLikeLiveData = APILiveData<Any>()
    fun answerCommentUpdateLike(
        apiRequest: ApiRequest,
        analytics: AnalyticsClient,
        screenName: String,
        isComment: Boolean = false,
    ) {

        if (isComment) {
            if (apiRequest.is_active == "Y") {
                analytics.logEvent(analytics.USER_LIKED_COMMENT, Bundle().apply {
                    putString(analytics.PARAM_CONTENT_COMMENTS_ID, apiRequest.content_comments_id)
                }, screenName = screenName)
            } else {
                analytics.logEvent(analytics.USER_UNLIKED_COMMENT, Bundle().apply {
                    putString(analytics.PARAM_CONTENT_COMMENTS_ID, apiRequest.content_comments_id)
                }, screenName = screenName)
            }
        } else {
            if (apiRequest.is_active == "Y") {
                analytics.logEvent(analytics.USER_LIKED_ANSWER, Bundle().apply {
                    putString(analytics.PARAM_CONTENT_COMMENTS_ID, apiRequest.content_comments_id)
                }, screenName = screenName)
            } else {
                analytics.logEvent(analytics.USER_UNLIKED_ANSWER, Bundle().apply {
                    putString(analytics.PARAM_CONTENT_COMMENTS_ID, apiRequest.content_comments_id)
                }, screenName = screenName)
            }
        }

        viewModelScope.launch {
            val result = engageContentRepository.answerCommentUpdateLike(apiRequest)
            answerCommentUpdateLikeLiveData.value = result
        }
    }

    /**
     * @API :- contentReport
     */
    val contentReportLiveData = APILiveData<Any>()
    fun contentReport(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.contentReport(apiRequest)
            contentReportLiveData.value = result
        }
    }

    /**
     * @API :- reportAnswerComment
     */
    val reportAnswerCommentLiveData = APILiveData<Any>()
    fun reportAnswerComment(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.reportAnswerComment(apiRequest)
            reportAnswerCommentLiveData.value = result
        }
    }

    /**
     * @API :- askAnExpertFilters
     */
    val askAnExpertFiltersLiveData = APILiveData<AskAnExpertFiltersData>()
    fun askAnExpertFilters(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.askAnExpertFilters(apiRequest)
            askAnExpertFiltersLiveData.value = result
        }
    }

    /**
     * @API :- questionDetail
     */
    val questionDetailLiveData = APILiveData<QuestionsData>()
    fun questionDetail(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.questionDetail(apiRequest)
            questionDetailLiveData.value = result
        }
    }

    /**
     * @API :- answerComments
     */
    val answerCommentsLiveData = APILiveData<ArrayList<AnswerCommentData>>()
    fun answerComments(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = engageContentRepository.answerComments(apiRequest)
            answerCommentsLiveData.value = result
        }
    }

}