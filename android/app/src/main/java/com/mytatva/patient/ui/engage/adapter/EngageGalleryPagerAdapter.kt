package com.mytatva.patient.ui.engage.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.ContentMediaData
import com.mytatva.patient.databinding.EngageRowGalleryBinding
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.imagepicker.loadUrl

class EngageGalleryPagerAdapter(
    val navigator: Navigator,
    var list: ArrayList<ContentMediaData>,
    val adapterListener: AdapterListener? = null,
) : RecyclerView.Adapter<EngageGalleryPagerAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowGalleryBinding.inflate(
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
            imageViewGallery.loadUrl(item.image_url ?: "")
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: EngageRowGalleryBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewGallery.setOnClickListener {
                    if (adapterListener == null) {
                        navigator.showImageViewerDialog(arrayListOf(list[bindingAdapterPosition].image_url
                            ?: ""))
                    } else {
                        adapterListener.onClick(bindingAdapterPosition)
                    }
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(imagePosition: Int)
    }
}