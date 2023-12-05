package com.mytatva.patient.utils.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView

import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.mytatva.patient.R

/**
 * Created by  on 31/1/18.
 */

class BottomSheetAdapter<T>(
    var modeldata: List<T>,
    var itemListener: ItemListener<T>,
    internal var mBottomSheetDialog: BottomSheetDialog,
) : RecyclerView.Adapter<BottomSheetAdapter<T>.MyViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        return MyViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.comon_row_bottomsheet_layout, parent, false)
        )
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        itemListener.onBindViewHolder(holder, position, modeldata[position])

    }

    override fun getItemCount(): Int {
        return modeldata.size
    }

    interface ItemListener<T> {
        fun onItemClick(item: T, position: Int)
        fun onBindViewHolder(
            holder: BottomSheetAdapter<T>.MyViewHolder,
            position: Int,
            item: T,
        )
    }

    inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView),
        View.OnClickListener {
        internal var textView: TextView

        init {
            textView = itemView.findViewById<View>(R.id.itemtext) as TextView
            itemView.setOnClickListener(this)
        }

        override fun onClick(view: View) {
            mBottomSheetDialog.dismiss()
            itemListener.onItemClick(modeldata[adapterPosition], adapterPosition)
        }
    }
}
