package com.mytatva.patient.ui.home.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.PatientPlanData
import com.mytatva.patient.databinding.HomeRowCarePurchasedPlanBinding
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.util.Calendar

class HomePurchasedPlansAdapter(
    var list: ArrayList<PatientPlanData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HomePurchasedPlansAdapter.ViewHolder>() {

    fun doRefresh(homePurchasedPlanList: ArrayList<PatientPlanData>) {
        list = homePurchasedPlanList
        notifyDataSetChanged()
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding =
            HomeRowCarePurchasedPlanBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = list[position]
        val context = holder.binding.root.context


        holder.binding.apply {
            if (data.plan_master_id.isNullOrBlank().not()) {
                pbPlan.progress = setPlanProgress(data).toInt()

                val calExpiry = Calendar.getInstance()
                calExpiry.time =
                    DateTimeFormatter.date(
                        data.expiry_date,
                        DateTimeFormatter.FORMAT_yyyyMMdd
                    ).date!!

                val today = Calendar.getInstance()
                val remainingDays = DateTimeFormatter.getDiffInDays(today, calExpiry)


                if (remainingDays > 14) {
                    tvExpireTime.setTextColor(
                        ContextCompat.getColor(
                            context,
                            R.color.color_green
                        )
                    )
                    tvExpireTime.text = "Expires on ${
                        DateTimeFormatter.formatDate(
                            data?.expiry_date.toString(),
                            DateTimeFormatter.FORMAT_yyyyMMdd
                        )
                    }"
                    pbPlan.setIndicatorColor(ContextCompat.getColor(context, R.color.color_green))
                } else if (remainingDays > 7 && remainingDays <= 14) {
                    tvExpireTime.setTextColor(
                        ContextCompat.getColor(
                            context,
                            R.color.progress_orange
                        )
                    )
                    tvExpireTime.text = "${remainingDays} days(s) remaining"
                    pbPlan.setIndicatorColor(
                        ContextCompat.getColor(
                            context,
                            R.color.progress_orange
                        )
                    )
                } else if (remainingDays == 1) {
                    tvExpireTime.setTextColor(
                        ContextCompat.getColor(
                            context,
                            R.color.progress_red
                        )
                    )
                    tvExpireTime.text = "Expiring Tomorrow"
                    pbPlan.setIndicatorColor(ContextCompat.getColor(context, R.color.progress_red))
                } else if (remainingDays == 0) {
                    tvExpireTime.setTextColor(
                        ContextCompat.getColor(
                            context,
                            R.color.progress_red
                        )
                    )
                    tvExpireTime.text = "Expiring Today"
                    pbPlan.setIndicatorColor(ContextCompat.getColor(context, R.color.progress_red))
                } else if (remainingDays > 0 && remainingDays <= 7) {
                    tvExpireTime.setTextColor(
                        ContextCompat.getColor(
                            context,
                            R.color.progress_red
                        )
                    )
                    tvExpireTime.text = "${remainingDays} days(s) remaining"
                    pbPlan.setIndicatorColor(ContextCompat.getColor(context, R.color.progress_red))
                } else if (remainingDays < 0) {
                    tvExpireTime.setTextColor(
                        ContextCompat.getColor(
                            context,
                            R.color.progress_red
                        )
                    )
                    tvExpireTime.text = "Plan expired"
                    pbPlan.setIndicatorColor(ContextCompat.getColor(context, R.color.progress_red))
                }


                /*binding.tvExpireTime.text = getString(
                    R.string.home_label_date_of_plan_expiry,
                    DateTimeFormatter.formatDate(
                        it.patient_plans?.get(0)?.expiry_date.toString(),
                        FORMAT_yyyyMMdd
                    )
                )*/
                textViewLabelCarePlanForYourNeeds.text = data.plan_name
                //textViewTagActive.isVisible = true
                textViewLabelExplorePlan.text = data.sub_title

                /*try {
                    val calExpiry = Calendar.getInstance()
                    calExpiry.time =
                        DateTimeFormatter.date(
                            it.currentPlan?.expiry_date,
                            DateTimeFormatter.FORMAT_yyyyMMdd
                        ).date!!

                    val today = Calendar.getInstance()
                    val dayDiff = DateTimeFormatter.getDiffInDays(today, calExpiry)

                    if (dayDiff > 1) {
                        textViewLabelExplorePlan.text = getString(
                            R.string.home_label_expiring_in_days,
                            dayDiff.toString()
                        )
                    } else if (dayDiff == 1) {
                        textViewLabelExplorePlan.text =
                            getString(R.string.home_label_expiring_tomorrow)
                    } else if (dayDiff == 0) {
                        textViewLabelExplorePlan.text =
                            getString(R.string.home_label_expiring_today)
                    } else {
                        textViewLabelExplorePlan.text = ""
                    }

                } catch (e: Exception) {
                    e.printStackTrace()
                    textViewLabelExplorePlan.text =
                        getString(R.string.care_plan_for_your_need_label_explore_plan)
                }*/
            } else {
                textViewLabelCarePlanForYourNeeds.text =
                    context.getString(R.string.care_plan_for_your_need_label_care_plan)
                //textViewTagActive.isVisible = false
                textViewLabelExplorePlan.text =
                    context.getString(R.string.care_plan_for_your_need_label_explore_plan)
            }

        }
    }


    private fun setPlanProgress(plan: PatientPlanData?): Double {
        val startDate = Calendar.getInstance()
        val endDate = Calendar.getInstance()
        startDate.time =
            DateTimeFormatter.date(plan?.plan_start_date, DateTimeFormatter.FORMAT_yyyyMMdd).date!!
        endDate.time =
            DateTimeFormatter.date(plan?.plan_end_date, DateTimeFormatter.FORMAT_yyyyMMdd).date!!

        val planDuration = DateTimeFormatter.getDiffInDays(endDate, startDate)
        val completedPlanDuration =
            DateTimeFormatter.getDiffInDays(Calendar.getInstance(), startDate)

        return if (completedPlanDuration >= 0 && planDuration > 0) {
            (completedPlanDuration / planDuration.toDouble()) * 100
        } else {
            0.0
        }
    }


    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: HomeRowCarePurchasedPlanBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.root.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onClick(bindingAdapterPosition)
                }
            }
            binding.tvRenew.setOnClickListener {
                if (bindingAdapterPosition != RecyclerView.NO_POSITION) {
                    adapterListener.onRenewClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onRenewClick(position: Int)
    }
}