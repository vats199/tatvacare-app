package com.mytatva.patient.ui.labtest.adapter.v1

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.pojo.response.BcpTestMainData
import com.mytatva.patient.databinding.LabtestRowBcpTestMainBinding

class BcpLabtestCartMainAdapter(
    var list: ArrayList<BcpTestMainData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<BcpLabtestCartMainAdapter.ViewHolder>() {

    //var selectedPos = -1

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LabtestRowBcpTestMainBinding.inflate(
            LayoutInflater.from(parent.context), parent, false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        holder.binding.apply {
            checkBoxBcpTest.text = item.plan_name
            recyclerViewBcpTest.apply {
                layoutManager =
                    LinearLayoutManager(recyclerViewBcpTest.context, RecyclerView.VERTICAL, false)
                adapter =
                    LabtestCartTestV1Adapter(item.bcp_tests_list ?: arrayListOf(), false, null)
            }
            checkBoxBcpTest.isChecked = item.is_bcp_tests_added == "Y"
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: LabtestRowBcpTestMainBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                checkBoxBcpTest.setOnClickListener {
                    checkBoxBcpTest.isChecked =
                        list[bindingAdapterPosition].is_bcp_tests_added == "Y"
                    adapterListener.onItemClick(bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onItemClick(position: Int)
    }
}