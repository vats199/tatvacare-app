package com.mytatva.patient.ui.labtest.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestRowAppointmentReviewCartItemsBinding

class ReviewCartItemsAdapter(
    var list: ArrayList<TestPackageData>,
) : RecyclerView.Adapter<ReviewCartItemsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowAppointmentReviewCartItemsBinding.inflate(
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
            textViewTestName.text = item.name
            textViewItemPrice.text = "₹".plus(item.discount_price)
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowAppointmentReviewCartItemsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
            }
        }
    }

    interface AdapterListener {
    }
}