package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.BookmarkedContentData
import com.mytatva.patient.databinding.MenuRowBookmarksMainBinding

class BookmarksMainAdapter(
    var list: ArrayList<BookmarkedContentData>,
    val adapterListener: AdapterListener,
    val subAdapterListener: BookmarksSubAdapter.AdapterListener,
) : RecyclerView.Adapter<BookmarksMainAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowBookmarksMainBinding.inflate(
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
            textViewTitle.text = item.display_value
            recyclerViewBookmarksSub.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                adapter = BookmarksSubAdapter(list[position].data ?: listOf(),
                    position,
                    subAdapterListener)
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowBookmarksMainBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                textViewViewAll.setOnClickListener {
                    adapterListener.onViewAllClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onViewAllClick(position: Int)
    }
}