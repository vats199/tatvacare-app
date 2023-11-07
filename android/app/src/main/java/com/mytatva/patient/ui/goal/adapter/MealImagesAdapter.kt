package com.mytatva.patient.ui.goal.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.ImageData
import com.mytatva.patient.databinding.GoalRowMealImagesBinding
import com.mytatva.patient.utils.imagepicker.loadRounded

class MealImagesAdapter(
    var list: ArrayList<ImageData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<MealImagesAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowMealImagesBinding.inflate(
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
            if (item.image_url.isNullOrBlank().not()) {
                //already added before
                imageViewFood.loadRounded(item.image_url ?: "",
                    context.resources.getDimension(R.dimen.dp_5).toInt())
            } else {
                imageViewFood.loadRounded(item.imagePath ?: "",
                    context.resources.getDimension(R.dimen.dp_5).toInt())
            }

            if (position == list.lastIndex) {
                imageViewAdd.visibility = View.VISIBLE
                imageViewFood.visibility = View.GONE
                imageViewRemove.visibility = View.GONE
            } else {
                imageViewAdd.visibility = View.GONE
                imageViewFood.visibility = View.VISIBLE
                imageViewRemove.visibility = View.VISIBLE
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowMealImagesBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                imageViewAdd.setOnClickListener {
                    adapterListener.onAddClick(bindingAdapterPosition)
                }
                imageViewRemove.setOnClickListener {
                    list.removeAt(bindingAdapterPosition)
                    notifyItemRemoved(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onAddClick(position: Int)
    }
}