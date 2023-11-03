package com.mytatva.patient.ui.home.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.databinding.HomeRowRecommendedForYouBinding
import com.mytatva.patient.utils.imagepicker.load

class HomeRecommendedAdapter(
    var list: ArrayList<ContentData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<HomeRecommendedAdapter.ViewHolder>() {

    override fun getItemViewType(position: Int): Int {
        return position
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowRecommendedForYouBinding.inflate(
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
            imageViewRecommended.load(item.media?.firstOrNull()?.image_url ?: "")
            textViewTitle.text = item.title
            textViewDescription.text = item.getHtmlFormattedDescription
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowRecommendedForYouBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}