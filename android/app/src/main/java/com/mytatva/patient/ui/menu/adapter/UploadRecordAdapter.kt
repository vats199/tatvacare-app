package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.MenuRowUploadingDocsBinding
import com.mytatva.patient.utils.imagepicker.loadDrawable

class UploadRecordAdapter(
        var list: ArrayList<TempDataModel>,
        val adapterListener: AdapterListener,
) : RecyclerView.Adapter<UploadRecordAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowUploadingDocsBinding.inflate(
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
            imageViewIcon.loadDrawable(if (item.isPdfDocFile) R.drawable.ic_pdf
            else R.drawable.ic_image, false)
            textViewName.text = item.name
            /*textViewProgress.text=""
            progressIndicator*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowUploadingDocsBinding) :
            RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                imageViewRemove.setOnClickListener {
                    list.removeAt(bindingAdapterPosition)
                    notifyItemRemoved(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onRemoveClick(position: Int)
    }
}