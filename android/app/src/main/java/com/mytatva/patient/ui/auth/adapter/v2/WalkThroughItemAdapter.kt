package com.mytatva.patient.ui.auth.adapter.v2

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.mytatva.patient.data.pojo.response.SignUpOnboardingData
import com.mytatva.patient.databinding.AuthV2RowWalkThroughBinding

class WalkThroughItemAdapter(val list : ArrayList<SignUpOnboardingData>) : RecyclerView.Adapter<WalkThroughItemAdapter.ViewHolder>() {

    inner class ViewHolder(val binding : AuthV2RowWalkThroughBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(position: Int) = with(binding){
            val item = list[position]

            textViewTitle.text = item.title
            textViewMessage.text = item.description
            Glide.with(binding.root.context)
                .asGif()
                .load(item.image_url)
                .into(binding.imageViewGIF)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        return ViewHolder(AuthV2RowWalkThroughBinding.inflate(LayoutInflater.from(parent.context),parent,false))
    }

    override fun getItemCount(): Int {
        return list.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            holder.bind(position)
    }
}