package com.mytatva.patient.ui.menu.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.FaqData
import com.mytatva.patient.databinding.MenuRowFaqSubBinding
import com.mytatva.patient.utils.textdecorator.TextDecorator

class FAQSubAdapter(
    var list: List<FaqData>,
) : RecyclerView.Adapter<FAQSubAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowFaqSubBinding.inflate(
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

            val questionLabel = "Q.".plus(item.faq_question)
            TextDecorator.decorate(textViewQuestion, questionLabel)
                .setTextColor(R.color.colorPrimary, 0, 2)
                .build()

            /*val answerLabel = "Ans.".plus(item.faq_answer)
            TextDecorator.decorate(textViewAns, answerLabel)
                .setTextColor(R.color.colorPrimary, 0, 4)
                .build()*/
            textViewAns.text = item.getHtmlFormattedAns

            imageViewUpDown.rotation = if (item.isSelected) 180F else 0F
            if (item.isSelected) {
                //viewLine1.visibility = View.VISIBLE
                textViewAns.visibility = View.VISIBLE
            } else {
                //viewLine1.visibility = View.GONE
                textViewAns.visibility = View.GONE
            }

        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowFaqSubBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                layoutQuestion.setOnClickListener {
                    /*if (imageViewUpDown.rotation == 0F)
                        imageViewUpDown.animate().rotation(180F).start()
                    else
                        imageViewUpDown.animate().rotation(0F).start()*/

                    list[bindingAdapterPosition].isSelected =
                        list[bindingAdapterPosition].isSelected.not()
                    notifyItemChanged(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}