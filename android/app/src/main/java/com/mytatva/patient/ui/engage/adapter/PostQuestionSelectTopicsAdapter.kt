package com.mytatva.patient.ui.engage.adapter

import android.annotation.SuppressLint
import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.TopicsData
import com.mytatva.patient.databinding.EngageRowPostQuestionSelectCategoryBinding
import com.mytatva.patient.utils.imagepicker.loadTopicIcon
import com.mytatva.patient.utils.parseAsColor

class PostQuestionSelectTopicsAdapter(var list: ArrayList<TopicsData>) :
    RecyclerView.Adapter<PostQuestionSelectTopicsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            EngageRowPostQuestionSelectCategoryBinding.inflate(
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
            textViewTopic.text = item.name
            imageViewTopic.loadTopicIcon(item.image_url ?: "", false)
            if (item.isSelected) {
                layoutTopic.backgroundTintList =
                        /*ColorStateList.valueOf(ContextCompat.getColor(context,
                            R.color.yellow1))*/
                    ColorStateList.valueOf(item.color_code.parseAsColor())
            } else {
                layoutTopic.backgroundTintList =
                    ColorStateList.valueOf(ContextCompat.getColor(context,
                        R.color.textBlack1Transparent40))
            }
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: EngageRowPostQuestionSelectCategoryBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                layoutTopic.setOnClickListener {
                    list[bindingAdapterPosition].isSelected =
                        !list[bindingAdapterPosition].isSelected
                    notifyItemChanged(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}