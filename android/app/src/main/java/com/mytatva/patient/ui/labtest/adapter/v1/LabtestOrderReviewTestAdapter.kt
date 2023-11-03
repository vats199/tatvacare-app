package com.mytatva.patient.ui.labtest.adapter.v1

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestRowOrderReviewTestBinding
import com.mytatva.patient.utils.imagepicker.load

class LabtestOrderReviewTestAdapter(
    var list: ArrayList<TestPackageData>,
) : RecyclerView.Adapter<LabtestOrderReviewTestAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowOrderReviewTestBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        with(holder.binding) {
            textViewLabelTestName.text = item.name
            imageViewTest.load(item.imageLocation ?: "", isCenterCrop = false)
            if (position != list.lastIndex) {
                viewLine.visibility = View.VISIBLE
            } else {
                viewLine.visibility = View.INVISIBLE
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowOrderReviewTestBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {

        }

    }
}