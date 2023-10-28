package com.mytatva.patient.ui.engage.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.AnswerCommentData
import com.mytatva.patient.databinding.EngageRowAnswerCommentsBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.kFormat

class EngageAskAnExpertAnswerCommentsAdapter(
    val activity: BaseActivity,
    val navigator: Navigator,
    val userId: String,
    var list: ArrayList<AnswerCommentData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<EngageAskAnExpertAnswerCommentsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowAnswerCommentsBinding.inflate(
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
            textViewAnsGivenBy.text = item.ansGivenBy(userId)
            textViewCommentTime.text = item.formattedTopAnsTime
            textViewComment.text = item.comment

            textViewLikeCount.text = item.likeCount.kFormat()

            imageViewLike.isSelected = item.liked == "Y"
            imageViewReportComment.isSelected = item.reported == "Y"

            imageViewOptionMenu.isVisible = item.patient_id == userId
            imageViewReportComment.isVisible = item.patient_id != userId
        }
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int, payloads: MutableList<Any>) {
        super.onBindViewHolder(holder, position, payloads)
        val item = list[position]
        holder.binding.apply {

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowAnswerCommentsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewLike.setOnClickListener {
                    if (list[bindingAdapterPosition].liked == "Y") {
                        list[bindingAdapterPosition].liked = "N"
                        list[bindingAdapterPosition].likeCount =
                            list[bindingAdapterPosition].likeCount - 1
                    } else {
                        list[bindingAdapterPosition].liked = "Y"
                        list[bindingAdapterPosition].likeCount =
                            list[bindingAdapterPosition].likeCount + 1
                    }
                    adapterListener.onLikeClick(bindingAdapterPosition)
                    notifyItemChanged(bindingAdapterPosition)
                }
                imageViewReportComment.setOnClickListener {
                    adapterListener.onReportClick(bindingAdapterPosition)
                }
                imageViewOptionMenu.setOnClickListener {
                    adapterListener.onOptionMenuClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onReportClick(position: Int)

        //fun onReadFullAnsOrCommentClick(mainPosition: Int, position: Int)
        fun onLikeClick(position: Int)
        fun onOptionMenuClick(position: Int)
        //fun onAnswerOptionClick(mainPosition: Int, position: Int)
    }
}