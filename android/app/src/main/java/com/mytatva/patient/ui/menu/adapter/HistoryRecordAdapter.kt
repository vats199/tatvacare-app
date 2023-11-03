package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.RecordData
import com.mytatva.patient.databinding.MenuRowHistoryRecordsBinding
import com.mytatva.patient.ui.manager.Navigator

class HistoryRecordAdapter(
    val navigator: Navigator,
    var list: ArrayList<RecordData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HistoryRecordAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowHistoryRecordsBinding.inflate(
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

            /*if (!(item.document_url?.firstOrNull() ?: "").contains(".pdf", true)) {
                imageViewPdf.visibility = View.GONE
                imageViewRecord.visibility = View.VISIBLE
                imageViewRecord.loadRounded(item.document_url?.firstOrNull() ?: "",
                    context.resources.getDimension(R.dimen.dp_6).toInt())
            } else {
                imageViewPdf.visibility = View.VISIBLE
                imageViewRecord.visibility = View.GONE
            }*/

            recyclerViewRecordDocuments.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
                adapter = HistoryRecordDocumentsAdapter(position, navigator,
                    item.document_url ?: arrayListOf())
            }

            textViewType.isVisible = !item.test_name.isNullOrBlank()
            textViewType.text = item.test_name
            textViewTitle.text = item.title
            textViewDescription.text = item.description
            textViewUploadedBy.text = when (item.added_by) {
                Common.AnswerUserType.DOCTOR -> {
                    "Uploaded by Doctor"
                }
                Common.AnswerUserType.HEALTHCOACH -> {
                    "Uploaded by Health coach"
                }
                Common.AnswerUserType.ADMIN -> {
                    "Uploaded by Admin"
                }
                else -> {
                    "Uploaded by Me"
                }
            }
            textViewDate.text = item.getFormattedDate
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowHistoryRecordsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                /*imageViewPdf.setOnClickListener {
                    adapterListener.onPDFClick(bindingAdapterPosition)
                }
                imageViewRecord.setOnClickListener {
                    adapterListener.onImageClick(bindingAdapterPosition)
                }*/
            }
        }
    }

    interface AdapterListener {
        fun onPDFClick(position: Int)
        fun onImageClick(position: Int)
    }
}