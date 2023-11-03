package com.mytatva.patient.ui.home.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.QuizPoleData
import com.mytatva.patient.databinding.HomeRowQuizPollBinding

class HomeQuizPolePagerAdapter(
    var list: ArrayList<QuizPoleData>,
    val adapterListener: AdapterListener,
) :
    RecyclerView.Adapter<HomeQuizPolePagerAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = HomeRowQuizPollBinding.inflate(
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
            textViewTitle.text = item.title
            textViewDescription.text = item.description
            buttonStart.text = item.cat
            /*buttonStart.text =
                if (item.quiz_master_id != null)
                    "Start Quiz"
                else "Click here"*/
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowQuizPollBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                buttonStart.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}