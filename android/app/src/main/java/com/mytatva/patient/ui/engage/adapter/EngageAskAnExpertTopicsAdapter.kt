package com.mytatva.patient.ui.engage.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.Topics
import com.mytatva.patient.databinding.EngageRowAskAnExpertTopicsBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.imagepicker.loadTopicIcon
import com.mytatva.patient.utils.parseAsColor

class EngageAskAnExpertTopicsAdapter(
    val activity: BaseActivity,
    val navigator: Navigator,
    val userId: String,
    var list: ArrayList<Topics>,
    //val adapterListener: AdapterListener,
) : RecyclerView.Adapter<EngageAskAnExpertTopicsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowAskAnExpertTopicsBinding.inflate(
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
            layoutTopic.backgroundTintList = ColorStateList.valueOf(item.color_code.parseAsColor())
            imageViewTopic.loadTopicIcon(item.image_url ?: "")
            textViewTopic.text = item.name
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowAskAnExpertTopicsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {

            }
        }
    }

    interface AdapterListener {

    }
}