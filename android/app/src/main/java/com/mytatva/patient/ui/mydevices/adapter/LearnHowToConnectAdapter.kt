package com.mytatva.patient.ui.mydevices.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.LearnHowToConnectData
import com.mytatva.patient.databinding.HomeRowHowToConnectSmartScaleBinding

class LearnHowToConnectAdapter(
    var list: ArrayList<LearnHowToConnectData>
) : RecyclerView.Adapter<LearnHowToConnectAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowHowToConnectSmartScaleBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.binding(position)

    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowHowToConnectSmartScaleBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {

        }
        fun binding(position: Int)=with(binding){
            val item = list[position]
            textViewSrNo.text = item.srNo
            textViewSteps.text = item.steps
        }

    }
}