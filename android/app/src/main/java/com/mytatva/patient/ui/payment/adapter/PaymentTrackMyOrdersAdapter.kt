package com.mytatva.patient.ui.payment.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.databinding.PaymentRowTrackMyOrdersBinding

class PaymentTrackMyOrdersAdapter(
    var list: ArrayList<String>,
) : RecyclerView.Adapter<PaymentTrackMyOrdersAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowTrackMyOrdersBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

    }

    override fun getItemCount(): Int = /*list.size*/ 5

    inner class ViewHolder(val binding: PaymentRowTrackMyOrdersBinding) :
        RecyclerView.ViewHolder(binding.root) {
    }
}