package com.mytatva.patient.ui.chat.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.databinding.ChatRowChatListBinding
import com.mytatva.patient.ui.common.fragment.SelectItemFragment
import com.mytatva.patient.utils.imagepicker.loadUrlWithOverride

class ChatListAdapter(
    var list: ArrayList<HealthCoachData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<ChatListAdapter.ViewHolder>() {

    var selectType: SelectItemFragment.SelectType? = null

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            ChatRowChatListBinding.inflate(
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
            textViewName.text = item.first_name.plus(" ").plus(item.last_name)
            imageViewProfile.loadUrlWithOverride(item.profile_pic ?: "", 180)
            textViewDescription.text = item.role
            /*textViewTime.text = ""
            textViewMsg.text = ""*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ChatRowChatListBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.imageViewProfile.setOnClickListener {
                adapterListener.onProfileClick(bindingAdapterPosition)
            }
            binding.root.setOnClickListener {
                adapterListener.onClick(bindingAdapterPosition)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onProfileClick(position: Int)
    }
}