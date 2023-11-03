package com.mytatva.patient.ui.payment.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.PaymentRowBottomsheetSelectAddressBinding

class SelectAddressAdapter(var list: List<TestAddressData>, val itemSelected: (Int) -> Unit, val onMoreClick: (View, Int) -> Unit) :
    RecyclerView.Adapter<SelectAddressAdapter.ViewHolder>() {

    var selectionPos = -1

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            PaymentRowBottomsheetSelectAddressBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        holder.binding.apply {
//            viewLine1.isVisible = position != list.size-1
            if (item.address_type == Common.AddressTypes.HOME) {
                imageViewIconLocation.setImageDrawable(
                    ContextCompat.getDrawable(
                        this.root.context,
                        R.drawable.ic_home_gray
                    )
                )
            } else {
                imageViewIconLocation.setImageDrawable(
                    ContextCompat.getDrawable(
                        this.root.context,
                        R.drawable.ic_address_new
                    )
                )
            }

            imageViewSelector.isSelected = if (selectionPos != -1) selectionPos == position else false
            textViewAddress.text = String.format("%s, %s - %s", item.address, item.street, item.pincode)
            textViewAddressType.text = if (Common.AddressTypes.WORK == item.address_type) Common.AddressTypes.OFFICE else item.address_type
            imageViewMore.visibility = if (item.bcp_address == "Y") View.INVISIBLE else View.VISIBLE
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: PaymentRowBottomsheetSelectAddressBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                selectionPos = bindingAdapterPosition
                itemSelected.invoke(selectionPos)
                notifyDataSetChanged()
            }
            binding.imageViewMore.setOnClickListener {
                onMoreClick.invoke(it, bindingAdapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}