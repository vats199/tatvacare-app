package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.databinding.MenuRowBookmarksSubBinding
import com.mytatva.patient.utils.imagepicker.load

class BookmarksSubAdapter(
    var list: List<ContentData>,
    var mainPosition: Int,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<BookmarksSubAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowBookmarksSubBinding.inflate(
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

            imageViewBookmark.isVisible = item.content_type != "AskAnExpert"

            textViewTitle.text = item.title
            textViewDate.text = item.formattedUpdatedDate
            if (item.media.isNullOrEmpty().not()) {
                imageViewBookmark.load(item.media!![0].image_url ?: "", isCenterCrop = false)
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowBookmarksSubBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    adapterListener.onItemClick(mainPosition, bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(mainPosition: Int, position: Int)
    }
}