package com.mytatva.patient.ui.engage.adapter

import android.annotation.SuppressLint
import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.TopicsData
import com.mytatva.patient.databinding.EngageRowDiscoverTopicBinding
import com.mytatva.patient.utils.imagepicker.loadTopicIcon
import com.mytatva.patient.utils.parseAsColor

class EngageDiscoverTopicAdapter(
    var list: ArrayList<TopicsData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<EngageDiscoverTopicAdapter.ViewHolder>() {

    var selectedPos = -1

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowDiscoverTopicBinding.inflate(
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
            root.backgroundTintList = ColorStateList.valueOf(item.color_code.parseAsColor())
            imageViewIcon.loadTopicIcon(item.image_url ?: "", false)
            textViewTopic.text = item.name

            //imageViewSelected.visibility = if (item.isSelected) View.VISIBLE else View.GONE

            root.elevation =
                if (item.isSelected) context.resources.getDimension(R.dimen.dp_16) else 0f
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: EngageRowDiscoverTopicBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                binding.root.setOnClickListener {
                    /*selectedPos = bindingAdapterPosition*/
                    if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                        list[bindingAdapterPosition].isSelected =
                            list[bindingAdapterPosition].isSelected.not()
                        adapterListener.onClick(bindingAdapterPosition)
                        notifyDataSetChanged()
                    }
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}