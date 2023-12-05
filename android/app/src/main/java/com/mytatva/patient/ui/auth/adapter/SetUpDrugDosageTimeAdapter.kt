package com.mytatva.patient.ui.auth.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.databinding.AuthRowDosageTimeBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.util.Calendar

class SetUpDrugDosageTimeAdapter(var activity: BaseActivity, var list: ArrayList<String>) :
    RecyclerView.Adapter<SetUpDrugDosageTimeAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            AuthRowDosageTimeBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            textViewTime.text = try {
                DateTimeFormatter.date(item, DateTimeFormatter.FORMAT_HHMM)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            } catch (e: Exception) {
                e.printStackTrace()
                ""
            }
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: AuthRowDosageTimeBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                activity.pickTime({ view, hourOfDay, minute ->
                    val cal = Calendar.getInstance()
                    cal.set(Calendar.HOUR_OF_DAY, hourOfDay)
                    cal.set(Calendar.MINUTE, minute)
                    list[adapterPosition] = DateTimeFormatter.date(cal.time)
                        .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_HHMM)
                    notifyItemChanged(adapterPosition)
                }, false)
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}