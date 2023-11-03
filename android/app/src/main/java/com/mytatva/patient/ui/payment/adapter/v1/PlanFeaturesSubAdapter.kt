package com.mytatva.patient.ui.payment.adapter.v1

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.databinding.PaymentRowPlanDetailsFeatureContentBinding

class PlanFeaturesSubAdapter(
    var list: ArrayList<String>,
    var cellWidth: Int = 0,
    /*val adapterListener: AdapterListener,*/
) : RecyclerView.Adapter<PlanFeaturesSubAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowPlanDetailsFeatureContentBinding.inflate(
            LayoutInflater.from(parent.context), null, false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            val params: ViewGroup.LayoutParams =
                ViewGroup.LayoutParams(cellWidth, ViewGroup.LayoutParams.MATCH_PARENT)
            root.layoutParams = params

            val isToShowCheckBox = item == "Y" || item == "N"

            if (isToShowCheckBox) {
                imageViewCheck.isVisible = true
                textViewCount.isVisible = false
                imageViewCheck.isSelected = item == "Y"
            } else {
                imageViewCheck.isVisible = false
                textViewCount.isVisible = true
                textViewCount.text = item
            }
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: PaymentRowPlanDetailsFeatureContentBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {}
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}