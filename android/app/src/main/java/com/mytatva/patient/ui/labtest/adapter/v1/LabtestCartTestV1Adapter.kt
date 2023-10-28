package com.mytatva.patient.ui.labtest.adapter.v1

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.databinding.LabtestRowCartTestV1Binding
import com.mytatva.patient.utils.imagepicker.load

class LabtestCartTestV1Adapter(
    var list: ArrayList<TestPackageData>,
    var isRemoveEnable: Boolean = false,
    val adapterListener: AdapterListener? = null,
) : RecyclerView.Adapter<LabtestCartTestV1Adapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowCartTestV1Binding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.binding(position)
        val item = list[position]
        holder.binding.apply {
            textViewLabelTestName.text = item.name
            imageViewTest.load(item.imageLocation ?: "", isCenterCrop = false)
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowCartTestV1Binding) :
        RecyclerView.ViewHolder(binding.root) {
        init {

        }

        fun binding(position: Int) = with(binding) {
            viewLine.isVisible = position != list.lastIndex
            imageViewRemove.isVisible = isRemoveEnable
            imageViewRemove.setOnClickListener {
                adapterListener?.onClickRemove(bindingAdapterPosition)
            }
        }

    }

    interface AdapterListener {
        fun onClickRemove(position: Int)
    }
}