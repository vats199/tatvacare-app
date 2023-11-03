package com.mytatva.patient.ui.payment.fragment.v1

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.databinding.PaymentFragmentTrackMyOrdersBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.payment.adapter.PaymentTrackMyOrdersAdapter

// not in used, this screen is removed currently from BCP flow
class PaymentTrackMyOrdersFragment:BaseFragment<PaymentFragmentTrackMyOrdersBinding>() {
    private var list = ArrayList<String>()
    private val paymentTrackMyOrdersAdapter by lazy {
        PaymentTrackMyOrdersAdapter(list)
    }
    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean
    ): PaymentFragmentTrackMyOrdersBinding {
        return PaymentFragmentTrackMyOrdersBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "My Orders"
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewTrackOrder.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = paymentTrackMyOrdersAdapter
        }
    }
}