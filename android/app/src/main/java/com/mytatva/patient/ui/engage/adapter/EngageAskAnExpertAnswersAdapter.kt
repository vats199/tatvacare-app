package com.mytatva.patient.ui.engage.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.AnswerData
import com.mytatva.patient.databinding.EngageRowAskAnExpertAnswersBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.kFormat

class EngageAskAnExpertAnswersAdapter(
    val mainPosition: Int,
    val activity: BaseActivity,
    val navigator: Navigator,
    val userId: String,
    var list: ArrayList<AnswerData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<EngageAskAnExpertAnswersAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowAskAnExpertAnswersBinding.inflate(
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
            imageViewOptionMenu.isVisible = item.patient_id == userId
            imageViewReportAnswer.isVisible = item.patient_id != userId

            textViewAnsGivenBy.text = item.ansGivenBy(userId)
            textViewTopAnsTime.text = item.formattedTopAnsTime
            textViewTopAns.text = item.comment

            textViewLikeCount.text = item.likeCount.kFormat()
            textViewCommentCount.text = item.commentCount.kFormat()

            imageViewLikeAnswer.isSelected = item.liked == "Y"
            imageViewReportAnswer.isSelected = item.reported == "Y"

            if (item.user_type == Common.AnswerUserType.PATIENT
                || item.user_type == Common.AnswerUserType.ADMIN
            ) {
                textViewTagDoctorOrHc.isVisible = false
            } else {
                textViewTagDoctorOrHc.isVisible = true
                textViewTagDoctorOrHc.text = item.user_title ?: ""
            }

            /* when (item.user_type ?: "") {
                 Common.AnswerUserType.ADMIN -> {
                     textViewTagDoctorOrHc.isVisible = true
                     textViewTagDoctorOrHc.text = item.user_title ?: ""
                 }
                 Common.AnswerUserType.HEALTHCOACH -> {
                     textViewTagDoctorOrHc.isVisible = true
                     textViewTagDoctorOrHc.text = item.user_title ?: ""
                 }
                 Common.AnswerUserType.PATIENT -> {
                     textViewTagDoctorOrHc.isVisible = false
                 }
                 else -> {
                     textViewTagDoctorOrHc.isVisible = false
                 }
             }*/
        }
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int, payloads: MutableList<Any>) {
        super.onBindViewHolder(holder, position, payloads)
        val item = list[position]
        holder.binding.apply {

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowAskAnExpertAnswersBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                textViewReadFullAns.setOnClickListener {
                    adapterListener.onReadFullAnsOrCommentClick(mainPosition,
                        bindingAdapterPosition)
                }
                imageViewReportAnswer.setOnClickListener {
                    adapterListener.onReportAnsClick(mainPosition, bindingAdapterPosition)
                }
                imageViewComment.setOnClickListener {
                    adapterListener.onReadFullAnsOrCommentClick(mainPosition,
                        bindingAdapterPosition)
                }
                layoutTopAnswer.setOnClickListener {
                    adapterListener.onReadFullAnsOrCommentClick(mainPosition,
                        bindingAdapterPosition)
                }
                imageViewLikeAnswer.setOnClickListener {
                    if (list[bindingAdapterPosition].liked == "Y") {
                        list[bindingAdapterPosition].liked = "N"
                        list[bindingAdapterPosition].likeCount =
                            list[bindingAdapterPosition].likeCount - 1
                    } else {
                        list[bindingAdapterPosition].liked = "Y"
                        list[bindingAdapterPosition].likeCount =
                            list[bindingAdapterPosition].likeCount + 1
                    }
                    notifyItemChanged(bindingAdapterPosition)
                    adapterListener.onLikeAnswerClick(mainPosition, bindingAdapterPosition)
                }
                imageViewOptionMenu.setOnClickListener {
                    adapterListener.onAnswerOptionClick(mainPosition, bindingAdapterPosition)
                }
            }
        }
    }


    interface AdapterListener {
        fun onReportAnsClick(mainPosition: Int, position: Int)
        fun onReadFullAnsOrCommentClick(mainPosition: Int, position: Int)
        fun onLikeAnswerClick(mainPosition: Int, position: Int)
        fun onAnswerOptionClick(mainPosition: Int, position: Int)
    }
}