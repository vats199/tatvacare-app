package com.mytatva.patient.ui.profile.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.DoctorData
import com.mytatva.patient.databinding.ProfileRowMyProfileDoctorBinding
import com.mytatva.patient.utils.imagepicker.loadCircle

class MyProfileConsultingDoctorAdapter(
    var list: ArrayList<DoctorData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<MyProfileConsultingDoctorAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ProfileRowMyProfileDoctorBinding.inflate(
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
            imageViewProfile.loadCircle(item.profile_image ?: "")
            textViewName.text = item.name
            textViewGender.text =
                if (item.gender == "M") "Male" else if (item.gender == "F") "Female" else ""
            textViewContact.text = (item.country_code ?: "").plus(" ").plus(item.contact_no ?: "")
            textViewEmail.text = item.email ?: ""

            groupEmail.isVisible = item.email.isNullOrBlank().not()

            textViewLocation.text =
                (item.city?.plus(",") ?: "").plus(" ")
                    .plus(item.state?.plus(",") ?: "").plus(" ")
                    .plus(item.country ?: "").trim()
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ProfileRowMyProfileDoctorBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            /*binding.root.setOnClickListener {
                adapterListener.onClick(bindingAdapterPosition)
            }*/
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }
}