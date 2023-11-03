package com.mytatva.patient.ui.labtest.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.databinding.LabtestRowPatientDetailsBinding
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient

class PatientDetailsAdapter(
    var list: ArrayList<TestPatientData>,
    val analytics: AnalyticsClient,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<PatientDetailsAdapter.ViewHolder>() {
    var selectedPos = -1
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowPatientDetailsBinding.inflate(
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
            textViewTitle.text = item.name
            textViewEmail.isVisible = item.email.isNullOrBlank().not()
            textViewEmail.text = item.email
            textViewAge.text = "Age : ${item.age}"
            textViewGender.text = "Gender : ${item.gender}"
            radioSelect.isChecked = selectedPos == position
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: LabtestRowPatientDetailsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                root.setOnClickListener {
                    selectedPos = bindingAdapterPosition
                    notifyDataSetChanged()
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}