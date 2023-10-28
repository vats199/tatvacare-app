package com.mytatva.patient.ui.engage.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.EngageRowPostQuestionDocumentsBinding
import com.mytatva.patient.utils.azure.UploadToAzureStorage

class PostQuestionDocumentsAdapter(var list: ArrayList<TempDataModel>) :
    RecyclerView.Adapter<PostQuestionDocumentsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            EngageRowPostQuestionDocumentsBinding.inflate(
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
            imageViewIcon.setImageResource(if (item.isPdfDocFile) R.drawable.ic_pdf else R.drawable.ic_image)
            textViewDocumentName.text =
                item.name.replace(UploadToAzureStorage.PREFIX_ASKANEXPERT, "")
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: EngageRowPostQuestionDocumentsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.imageViewDelete.setOnClickListener {
                list.removeAt(bindingAdapterPosition)
                notifyItemRemoved(bindingAdapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}