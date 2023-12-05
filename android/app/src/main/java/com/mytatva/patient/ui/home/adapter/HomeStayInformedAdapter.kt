package com.mytatva.patient.ui.home.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.databinding.HomeRowStayInformedNewBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.datetime.DateTimeFormatter.Companion.FORMAT_yyyyMMdd_HHmmss
import com.mytatva.patient.utils.imagepicker.load

class HomeStayInformedAdapter(
    val activity: BaseActivity,
    var list: ArrayList<ContentData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<HomeStayInformedAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowStayInformedNewBinding.inflate(
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
            imageViewStayInformed.load(item.media?.firstOrNull()?.image_url ?: "")
            textViewTitle.text = item.title
            textViewDescription.text = item.getHtmlFormattedDescription
            imageViewBookmark.isSelected = item.bookmarked == "Y"
            imageViewBookmark.isVisible = item.bookmark_capability != Common.CapabilityYesNo.NO
            tvDate.text =
                DateTimeFormatter.formatDate(item.publish_date.toString(), FORMAT_yyyyMMdd_HHmmss)
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowStayInformedNewBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                }
                imageViewBookmark.setOnClickListener {
                    if (activity.isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                        imageViewBookmark.isSelected = imageViewBookmark.isSelected.not()
                        adapterListener.onBookmarkClick(bindingAdapterPosition)
                    }
                }
                /*imageViewShare.setOnClickListener {
                    adapterListener.onShareClick(bindingAdapterPosition)
                }*/
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onShareClick(position: Int)
        fun onBookmarkClick(position: Int)
    }
}