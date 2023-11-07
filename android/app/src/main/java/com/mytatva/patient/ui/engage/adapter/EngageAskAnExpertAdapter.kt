package com.mytatva.patient.ui.engage.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.flexbox.FlexDirection
import com.google.android.flexbox.FlexboxLayoutManager
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.QuestionsData
import com.mytatva.patient.databinding.EngageRowAskAnExpertBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.imagepicker.loadTopicIcon
import com.mytatva.patient.utils.kFormat
import com.mytatva.patient.utils.parseAsColor

class EngageAskAnExpertAdapter(
    val activity: BaseActivity,
    val navigator: Navigator,
    val userId: String,
    var list: ArrayList<QuestionsData>,
    val adapterListener: AdapterListener,
    val subAdapterListener: EngageAskAnExpertAnswersAdapter.AdapterListener,
) : RecyclerView.Adapter<EngageAskAnExpertAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowAskAnExpertBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context

        holder.binding.apply {
            imageViewUpDown.rotation = if (item.isSelected) 180f else 0f

            textViewQuestion.text = item.title
            layoutTopic.backgroundTintList =
                ColorStateList.valueOf(item.topics?.firstOrNull()?.color_code.parseAsColor())
            imageViewTopic.loadTopicIcon(item.topics?.firstOrNull()?.image_url ?: "")
            textViewTopic.text = item.topics?.firstOrNull()?.name
            textViewQuestionTime.text = item.formattedQuestionTime

            imageViewBookmark.isSelected = item.bookmarked == "Y"
            imageViewReportQuestion.isSelected = item.reported == "Y"

            imageViewLikeAnswer.isSelected = item.top_answer?.liked == "Y"
            imageViewReportAnswer.isSelected = item.top_answer?.reported == "Y"

            imageViewOptionMenuQuestion.isVisible = item.updated_by == userId
            imageViewOptionMenuTopAns.isVisible = item.top_answer?.patient_id == userId
            imageViewReportQuestion.isVisible = item.updated_by != userId
            imageViewReportAnswer.isVisible = item.top_answer?.patient_id != userId

            if (item.top_answer?.user_type == Common.AnswerUserType.PATIENT
                || item.top_answer?.user_type == Common.AnswerUserType.ADMIN
            ) {
                textViewTagDoctorOrHc.isVisible = false
            } else {
                textViewTagDoctorOrHc.isVisible = true
                textViewTagDoctorOrHc.text = item.top_answer?.user_title ?: ""
            }
            /*when (item.top_answer?.user_type ?: "") {
                Common.AnswerUserType.ADMIN -> {
                    textViewTagDoctorOrHc.isVisible = true
                    textViewTagDoctorOrHc.text = item.top_answer?.user_title ?: ""
                }
                Common.AnswerUserType.HEALTHCOACH -> {
                    textViewTagDoctorOrHc.isVisible = true
                    textViewTagDoctorOrHc.text = item.top_answer?.user_title ?: ""
                }
                Common.AnswerUserType.PATIENT -> {
                    textViewTagDoctorOrHc.isVisible = false
                }
                else -> {
                    textViewTagDoctorOrHc.isVisible = false
                }
            }*/

            textViewLikeCount.text = item.top_answer?.likeCount.kFormat()
            textViewCommentCount.text = item.top_answer?.commentCount.kFormat()

            /*if (position == 0 || position == 1) {
                textViewLikeCount.text = 1125.kFormat()
                textViewCommentCount.text = (position * 10000).kFormat()
            } else if (position == 2 || position == 3) {
                textViewLikeCount.text = (position * 100000).kFormat()
                textViewCommentCount.text = (position * 1000000).kFormat()
            } else {
                textViewLikeCount.text = (position * 10000000).kFormat()
                textViewCommentCount.text = (position * 100000000).kFormat()
            }*/

            textViewAnsGivenBy.text = item.top_answer?.ansGivenBy(userId).plus(" (Top Answer)")
            textViewTopAnsTime.text = item.formattedTopAnsTime
            textViewTopAns.text = item.top_answer?.comment
            textViewAnsCount.text = item.totalAnswers.toString().plus(" Answers")

            imageViewUpDown.isVisible = item.totalAnswers > 1

            if (item.top_answer?.content_comments_id.isNullOrBlank()) {
                layoutTopAnswer.isVisible = false
                groupAnswers.isVisible = false
            } else {
                layoutTopAnswer.isVisible = true
                //groupAnswers.isVisible = true
                groupAnswers.isVisible = item.isSelected && item.totalAnswers > 1
            }

            val flexboxLayoutManager = FlexboxLayoutManager(activity)
            flexboxLayoutManager.flexDirection = FlexDirection.ROW
            recyclerViewTopics.apply {
                layoutManager = flexboxLayoutManager
                adapter = EngageAskAnExpertTopicsAdapter(activity,
                    navigator,
                    userId,
                    item.topics ?: arrayListOf())
            }

            recyclerViewDocuments.apply {
                layoutManager = LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
                adapter = EngageAskAnExpertDocumentsAdapter(position, activity, navigator, userId,
                    item.documents ?: arrayListOf())
            }

            recyclerViewAnswers.apply {
                layoutManager = LinearLayoutManager(activity, RecyclerView.VERTICAL, false)
                adapter = EngageAskAnExpertAnswersAdapter(position, activity, navigator, userId,
                    item.recent_answers ?: arrayListOf(), subAdapterListener)
            }
        }
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int, payloads: MutableList<Any>) {
        super.onBindViewHolder(holder, position, payloads)
        val item = list[position]

    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowAskAnExpertBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                layoutQuestion.setOnClickListener {
                    adapterListener.openQuestionDetails(bindingAdapterPosition)
                }
                textViewQuestion.setOnClickListener {
                    adapterListener.openQuestionDetails(bindingAdapterPosition)
                }
                textViewAnswerThis.setOnClickListener {
                    adapterListener.onClickAnswerThis(bindingAdapterPosition)
                }
                imageViewBookmark.setOnClickListener {
                    if (list[bindingAdapterPosition].bookmarked == "Y") {
                        list[bindingAdapterPosition].bookmarked = "N"
                    } else {
                        list[bindingAdapterPosition].bookmarked = "Y"
                    }
                    notifyItemChanged(bindingAdapterPosition)
                    adapterListener.onBookmarkClick(bindingAdapterPosition)
                }
                imageViewReportQuestion.setOnClickListener {
                    adapterListener.onReportQuestionClick(bindingAdapterPosition)
                }
                textViewReadFullAns.setOnClickListener {
                    adapterListener.onReadFullAnsOrCommentClick(bindingAdapterPosition)
                }
                imageViewLikeAnswer.setOnClickListener {
                    if (list[bindingAdapterPosition].top_answer?.liked == "Y") {
                        list[bindingAdapterPosition].top_answer?.liked = "N"
                        list[bindingAdapterPosition].top_answer?.likeCount =
                            (list[bindingAdapterPosition].top_answer?.likeCount ?: 0) - 1
                    } else {
                        list[bindingAdapterPosition].top_answer?.liked = "Y"
                        list[bindingAdapterPosition].top_answer?.likeCount =
                            (list[bindingAdapterPosition].top_answer?.likeCount ?: 0) + 1
                    }
                    notifyItemChanged(bindingAdapterPosition)
                    adapterListener.onLikeAnsClick(bindingAdapterPosition)
                }
                imageViewReportAnswer.setOnClickListener {
                    adapterListener.onReportAnsClick(bindingAdapterPosition)
                }
                layoutTopAnswer.setOnClickListener {
                    adapterListener.onReadFullAnsOrCommentClick(bindingAdapterPosition)
                }
                imageViewComment.setOnClickListener {
                    adapterListener.onReadFullAnsOrCommentClick(bindingAdapterPosition)
                }
                textViewAnsCount.setOnClickListener {
                    if (list[bindingAdapterPosition].totalAnswers > 1) {
                        list[bindingAdapterPosition].isSelected =
                            !list[bindingAdapterPosition].isSelected
                        notifyItemChanged(bindingAdapterPosition)
                    }
                }
                imageViewUpDown.setOnClickListener {
                    if (list[bindingAdapterPosition].totalAnswers > 1) {
                        list[bindingAdapterPosition].isSelected =
                            !list[bindingAdapterPosition].isSelected
                        notifyItemChanged(bindingAdapterPosition)
                    }
                }
                textViewShowAllAnswer.setOnClickListener {
                    adapterListener.openQuestionDetails(bindingAdapterPosition)
                }
                imageViewOptionMenuQuestion.setOnClickListener {
                    adapterListener.onOptionMenuClick(bindingAdapterPosition, true)
                }
                imageViewOptionMenuTopAns.setOnClickListener {
                    adapterListener.onOptionMenuClick(bindingAdapterPosition, false)
                }
            }
        }
    }

    interface AdapterListener {
        fun openQuestionDetails(position: Int)
        fun onBookmarkClick(position: Int)
        fun onReportQuestionClick(position: Int)
        fun onClickAnswerThis(position: Int)
        fun onReportAnsClick(position: Int)
        fun onReadFullAnsOrCommentClick(position: Int)
        fun onLikeAnsClick(position: Int)
        fun onOptionMenuClick(position: Int, isQuestion: Boolean)
    }
}