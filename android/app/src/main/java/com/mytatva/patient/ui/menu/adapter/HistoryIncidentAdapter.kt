package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.IncidentDetailsMainData
import com.mytatva.patient.databinding.MenuRowHistoryIncidentBinding

class HistoryIncidentAdapter(
    var list: ArrayList<IncidentDetailsMainData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HistoryIncidentAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowHistoryIncidentBinding.inflate(
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
            textViewLabelDuration.text = item.duration_question//Html.fromHtml(item.duration_question)
            textViewLabelHowDidItImprove.text = item.occur_question//Html.fromHtml(item.occur_question)
            textViewDate.text = item.formattedDate
            textViewDuration.text = item.duration_answer.plus(" min")
            textViewHowDidItImprove.text = item.occur_answer
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowHistoryIncidentBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}