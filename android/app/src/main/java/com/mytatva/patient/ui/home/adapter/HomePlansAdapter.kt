package com.mytatva.patient.ui.home.adapter

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.target.Target
import com.mytatva.patient.data.pojo.response.BcpPlanData
import com.mytatva.patient.databinding.HomeRowCarePlanBinding

class HomePlansAdapter(
    var list: ArrayList<BcpPlanData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HomePlansAdapter.ViewHolder>() {


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            HomeRowCarePlanBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = list[position]
        val context = holder.binding.root.context

        holder.binding.apply {
            //textViewTitle.text = data.plan_name
            //textViewDescription.text = data.sub_title

            ivPlaceholder.isVisible = true

            Glide.with(context)
                .asDrawable()
                .load(data.image_url.toString())
                .error(ColorDrawable(Color.TRANSPARENT))
                .listener(object : RequestListener<Drawable> {
                    override fun onLoadFailed(
                        e: GlideException?,
                        model: Any?,
                        target: Target<Drawable>?,
                        isFirstResource: Boolean,
                    ): Boolean {
                        ivPlaceholder.isVisible = true
                        return false
                    }

                    override fun onResourceReady(
                        resource: Drawable?,
                        model: Any?,
                        target: Target<Drawable>?,
                        dataSource: DataSource?,
                        isFirstResource: Boolean,
                    ): Boolean {
                        ivPlaceholder.isVisible = false
                        return false
                    }
                }).into(ivPlan)

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowCarePlanBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
            binding.tvKnowMore.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onKnowMoreClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onKnowMoreClick(position: Int)
    }
}