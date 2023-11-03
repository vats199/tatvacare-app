package com.mytatva.patient.ui.payment.adapter.v1

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewGroup.MarginLayoutParams
import androidx.core.view.isVisible
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.BcpFeatureTableData
import com.mytatva.patient.databinding.PaymentRowPlanDetailsFeaturesMainBinding
import com.mytatva.patient.utils.imagepicker.dpToPx

class PlanFeaturesMainAdapter(
    var list: ArrayList<BcpFeatureTableData>,
    var recyclerViewFeatures: RecyclerView,
    var recyclerViewHeader: RecyclerView,
    /*val adapterListener: AdapterListener,*/
) : RecyclerView.Adapter<PlanFeaturesMainAdapter.ViewHolder>() {

    var cellWidth: Int = 0

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = PaymentRowPlanDetailsFeaturesMainBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        binding.recyclerViewContent.removeOnScrollListener(syncScrollListener)
        binding.recyclerViewContent.addOnScrollListener(syncScrollListener)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            val isHeader = item.type == "header" //header,label

            /*item == "Health Coach Sessions"
                || item == "Diagnostic Tests"
                || item == "Integrate Your Smart Watch"
                || item == "MyTatva’s Smart Analyser"
                || item == "Additional App Features"
                || item == "Book a Consultation with your prescribing Doctor"*/

            viewLine.isVisible = if (position == 0) false else isHeader

            //handle spacing
            val lp = viewLine.layoutParams as MarginLayoutParams
            lp.topMargin = if (position > 0 && list[position - 1].type != "header") dpToPx(8) else 0
            viewLine.layoutParams = lp

            if (isHeader) {
                textViewFeatureTitle.isVisible = true
                textViewFeature.isVisible = false
                textViewFeatureTitle.text = item.title
            } else {
                textViewFeatureTitle.isVisible = false
                textViewFeature.isVisible = true
                textViewFeature.text = item.title
            }

            val isToHideContent = item.data.isNullOrEmpty()
            /*item == "Health Coach Sessions"
                || item == "Diagnostic Tests"
                || item == "Additional App Features"*/
            recyclerViewContent.visibility = if (isToHideContent) View.INVISIBLE else View.VISIBLE

            recyclerViewContent.apply {
                layoutManager = LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
                adapter = PlanFeaturesSubAdapter(
                    list[position].data ?: arrayListOf(),
                    cellWidth = cellWidth
                )
            }
        }
    }

    override fun getItemCount(): Int = list.size

    @SuppressLint("NotifyDataSetChanged")
    inner class ViewHolder(val binding: PaymentRowPlanDetailsFeaturesMainBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
    }

    /**
     * syncScrollListener
     * handle sync scrolling of all recyclerviews
     */
    val syncScrollListener = object : RecyclerView.OnScrollListener() {
        override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
            super.onScrolled(recyclerView, dx, dy)
            scrollAllRecyclerView(recyclerView, dx, dy);
        }

        private fun scrollAllRecyclerView(recyclerView: RecyclerView, dx: Int, dy: Int) {
            // Scroll children RecyclerViews except the recyclerView that is listened.
            for (i in 0 until recyclerViewFeatures.childCount) {
                val child: RecyclerView = recyclerViewFeatures.getChildAt(i)
                    .findViewById(R.id.recyclerViewContent)
                if (child != recyclerView) {
                    scroll(child, dx, dy)
                }
            }
            if (recyclerViewHeader != recyclerView) {
                scroll(recyclerViewHeader, dx, dy)
            }
        }

        private fun scroll(recyclerView: RecyclerView, dx: Int, dy: Int) {
            recyclerView.removeOnScrollListener(this)
            recyclerView.scrollBy(dx, dy);
            recyclerView.addOnScrollListener(this)
        }
    }
}