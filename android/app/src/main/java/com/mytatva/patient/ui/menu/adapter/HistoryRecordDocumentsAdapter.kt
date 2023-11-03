package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.databinding.MenuRowHistoryRecordDocumentsBinding
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.imagepicker.load

class HistoryRecordDocumentsAdapter(
    val mainPosition: Int,
    val navigator: Navigator,
    var list: ArrayList<String>,
    //val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HistoryRecordDocumentsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowHistoryRecordDocumentsBinding.inflate(
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
            if (!(item).contains(".pdf", true)) {
                imageViewImage.isVisible = true
                imageViewPdf.isVisible = false
                imageViewImage.load(item)
            } else {
                imageViewImage.isVisible = false
                imageViewPdf.isVisible = true
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowHistoryRecordDocumentsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewImage.setOnClickListener {
                    navigator.showImageViewerDialog(arrayListOf(list[bindingAdapterPosition]))
                }
                imageViewPdf.setOnClickListener {
                    list[bindingAdapterPosition].let { it1 -> navigator.openPdfViewer(it1) }
                }
            }
        }
    }

    interface AdapterListener {

    }
}