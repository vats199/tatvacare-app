package com.mytatva.patient.ui.careplan.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.Diet
import com.mytatva.patient.databinding.CarePlanRowDietPlanBinding
import com.mytatva.patient.utils.SafeClickListener
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class CarePlanDietPlanAdapter(
    var list: ArrayList<Diet>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<CarePlanDietPlanAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = CarePlanRowDietPlanBinding.inflate(
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
            textViewPlanTitle.text = item.document_title
            textViewValidDate.text = "Valid until ".plus(DateTimeFormatter
                .date(item.valid_till, DateTimeFormatter.FORMAT_yyyyMMdd)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy))
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: CarePlanRowDietPlanBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                buttonDownload.setOnClickListener(SafeClickListener {
                    adapterListener.onDownloadClick(bindingAdapterPosition,
                        list[bindingAdapterPosition])
                })
            }
        }
    }

    interface AdapterListener {
        fun onDownloadClick(position: Int, diet: Diet)
    }
}