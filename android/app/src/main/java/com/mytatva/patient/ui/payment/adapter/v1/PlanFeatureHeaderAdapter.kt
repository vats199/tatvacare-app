package com.mytatva.patient.ui.payment.adapter.v1

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.BcpDuration
import com.mytatva.patient.databinding.PaymentRowPlanDetailsFeatureHeaderBinding

class PlanFeatureHeaderAdapter(
    var list: ArrayList<BcpDuration>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<PlanFeatureHeaderAdapter.ViewHolder>() {

    var cellWidth = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowPlanDetailsFeatureHeaderBinding.inflate(
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
            val params: ViewGroup.LayoutParams =
                ViewGroup.LayoutParams(cellWidth, ViewGroup.LayoutParams.WRAP_CONTENT)
            root.layoutParams = params
            textViewDuration.text = item.duration_title
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: PaymentRowPlanDetailsFeatureHeaderBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                /*textViewDuration.setOnClickListener {
                    adapterListener.onInfoClick(bindingAdapterPosition)
                }*/
            }
        }
    }

    interface AdapterListener {
        fun onInfoClick(position: Int)
    }
}