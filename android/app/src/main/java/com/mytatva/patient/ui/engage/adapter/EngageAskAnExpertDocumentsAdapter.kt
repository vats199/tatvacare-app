package com.mytatva.patient.ui.engage.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.Documents
import com.mytatva.patient.databinding.EngageRowAskAnExpertDocumentsBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.imagepicker.load

class EngageAskAnExpertDocumentsAdapter(
    val mainPosition: Int,
    val activity: BaseActivity,
    val navigator: Navigator,
    val userId: String,
    var list: ArrayList<Documents>,
    //val adapterListener: AdapterListener,
) : RecyclerView.Adapter<EngageAskAnExpertDocumentsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowAskAnExpertDocumentsBinding.inflate(
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
            imageViewImage.isVisible = item.media_type == Common.QuestionDocType.PHOTO
            imageViewPdf.isVisible = item.media_type == Common.QuestionDocType.PDF

            imageViewImage.load(item.image_url ?: "")
        }
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int, payloads: MutableList<Any>) {
        super.onBindViewHolder(holder, position, payloads)
        val item = list[position]
        holder.binding.apply {

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowAskAnExpertDocumentsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewImage.setOnClickListener {
                    navigator.showImageViewerDialog(arrayListOf(list[bindingAdapterPosition].image_url
                        ?: ""))
                }
                imageViewPdf.setOnClickListener {
                    list[bindingAdapterPosition].image_url?.let { it1 -> navigator.openPdfViewer(it1) }
                }
            }
        }
    }

    interface AdapterListener {

    }
}