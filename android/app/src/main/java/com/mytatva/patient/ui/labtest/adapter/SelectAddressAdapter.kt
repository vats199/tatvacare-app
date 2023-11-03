package com.mytatva.patient.ui.labtest.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.LabtestRowSelectAddressBinding
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient

class SelectAddressAdapter(
    var list: ArrayList<TestAddressData>,
    val analytics: AnalyticsClient,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<SelectAddressAdapter.ViewHolder>() {

    var selectedPosition = -1

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowSelectAddressBinding.inflate(
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
            textViewTitle.text = item.address_type
            checkboxAddress.isChecked = selectedPosition == position
            textViewName.text = item.name
            textViewAddress.text = item.addressLabel
            textViewContact.text = item.contact_no
            textViewRemove.visibility =
                if (item.bcp_address == "Y") View.INVISIBLE else View.VISIBLE
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: LabtestRowSelectAddressBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    selectedPosition = bindingAdapterPosition
                    notifyDataSetChanged()
                    //adapterListener.onClick(bindingAdapterPosition)
                }
                textViewEdit.setOnClickListener {
                    adapterListener.onEditClick(bindingAdapterPosition)
                }
                textViewRemove.setOnClickListener {
                    adapterListener.onDeleteClick(bindingAdapterPosition)
                    /*list.removeAt(bindingAdapterPosition)
                    notifyItemRemoved(bindingAdapterPosition)*/
                }
            }
        }
    }

    interface AdapterListener {
        fun onEditClick(position: Int)
        fun onDeleteClick(position: Int)
    }
}