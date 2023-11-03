package com.mytatva.patient.ui.goal.adapter

import android.app.Activity
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.addTextChangedListener
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.AppDataProvider
import com.mytatva.patient.data.pojo.response.FoodItemData
import com.mytatva.patient.databinding.GoalRowAddedFoodItemsBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class AddedFoodItemsAdapter(
    var list: ArrayList<FoodItemData>,
    val analytics: AnalyticsClient,
    var activity: Activity,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<AddedFoodItemsAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = GoalRowAddedFoodItemsBinding.inflate(
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
            textViewItem.text = item.food_name
            textViewQty.text = item.quantity.toString().plus(" ${item.unit_name ?: ""}").trim()
            textViewCalorie.text = item.getCalculatedCalorieLabel

            if (item.isAddedByUser || item.food_item_id == "0") {
                editTextCalorie.visibility = View.VISIBLE
                editTextCalorie.setText(item.Energy_kcal)
                textViewCalorie.text = item.cal_unit_name
            } else {
                editTextCalorie.visibility = View.GONE
                textViewCalorie.text = item.getCalculatedCalorieLabel
            }
        }
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: GoalRowAddedFoodItemsBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            binding.apply {
                editTextCalorie.addTextChangedListener {
                    list[bindingAdapterPosition].Energy_kcal = it.toString()
                }

                imageViewRemove.setOnClickListener {
                    list.removeAt(bindingAdapterPosition)
                    notifyItemRemoved(bindingAdapterPosition)
                }
                textViewQty.setOnClickListener {
                    val qtyList = AppDataProvider.getNumberList(1, 99)
                    BottomSheet<String>().showBottomSheetDialog(activity as BaseActivity,
                        qtyList, "",
                        object : BottomSheetAdapter.ItemListener<String> {
                            override fun onItemClick(item: String, position: Int) {
                                analytics.logEvent(analytics.USER_ADDED_QUANTITY, Bundle().apply {
                                    putString(analytics.PARAM_FOOD_ITEM_ID,
                                        list[bindingAdapterPosition].food_item_id)
                                }, screenName = AnalyticsScreenNames.LogFood)

                                list[bindingAdapterPosition].quantity = item.toIntOrNull() ?: 1
                                notifyItemChanged(bindingAdapterPosition)
                            }

                            override fun onBindViewHolder(
                                holder: BottomSheetAdapter<String>.MyViewHolder,
                                position: Int,
                                item: String,
                            ) {
                                holder.textView.text =
                                    item.plus(" ${list[bindingAdapterPosition].unit_name}")
                            }
                        })

                }
            }
        }
    }

    interface AdapterListener {
        fun onRemoveClick(position: Int)
    }
}