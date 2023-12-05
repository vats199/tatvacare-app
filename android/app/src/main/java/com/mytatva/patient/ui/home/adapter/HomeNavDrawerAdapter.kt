package com.mytatva.patient.ui.home.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.TextViewCompat
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.DrawerItem
import com.mytatva.patient.databinding.HomeRowNavMenuBinding
import com.mytatva.patient.utils.imagepicker.loadDrawable

class HomeNavDrawerAdapter(var list: List<DrawerItem>, val adapterListener: AdapterListener) :
    RecyclerView.Adapter<HomeNavDrawerAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowNavMenuBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        val res = holder.binding.root.context.resources
        holder.binding.apply {

            /*imageViewIcon.imageTintList =
                ColorStateList.valueOf(res.getColor(item.colorRes, null))*/

            imageViewIcon.loadDrawable(item.icon, false)
            textViewItem.text = item.drawerItem
            textViewItem.setTextColor(res.getColor(item.colorRes, null))
            TextViewCompat.setCompoundDrawableTintList(
                textViewItem,
                ColorStateList.valueOf(res.getColor(item.colorRes, null))
            )

            /*if (item == DrawerItem.LogOut) {
                textViewItem.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0)
            } else {*/
            /*textViewItem.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0,
                R.drawable.ic_next_arrow_purple, 0)*/
            /*}*/

            if (item == DrawerItem.TransactionHistory
                || item == DrawerItem.History
                || item == DrawerItem.RateApp
            /*|| item == DrawerItem.ReportIncident*/) {
                viewLine1.visibility = View.VISIBLE
            } else {
                viewLine1.visibility = View.GONE
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowNavMenuBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                layoutNavMenuItem.setOnClickListener {
                    adapterListener.onItemClick(list[adapterPosition])
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(drawerItem: DrawerItem)
    }
}