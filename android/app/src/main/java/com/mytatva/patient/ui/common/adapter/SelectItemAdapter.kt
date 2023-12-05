package com.mytatva.patient.ui.common.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.CommonSelectItemData
import com.mytatva.patient.databinding.CommonRowSelectItemBinding
import com.mytatva.patient.ui.common.fragment.SelectItemFragment

class SelectItemAdapter(
    var list: ArrayList<CommonSelectItemData>,
    val adapterListener: AdapterListener
) :
    RecyclerView.Adapter<SelectItemAdapter.ViewHolder>() {

    var selectType: SelectItemFragment.SelectType? = null

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            CommonRowSelectItemBinding.inflate(
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
            textViewItem.text = when (selectType) {
                SelectItemFragment.SelectType.CITY -> {
                    item.city_name
                }

                SelectItemFragment.SelectType.STATE -> {
                    item.state_name
                }

                else -> {
                    ""
                }
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: CommonRowSelectItemBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                adapterListener.onClick(adapterPosition, list[adapterPosition])
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int, commonSelectItemData: CommonSelectItemData)
    }
}