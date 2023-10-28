package com.mytatva.patient.ui.mydevices.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.LearnHowToConnectData
import com.mytatva.patient.databinding.HomeBottomsheetLearnHowToConnectSmartScaleBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.mydevices.adapter.LearnHowToConnectAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class LearnHowToConnectBottomSheetDialog:
    BaseBottomSheetDialogFragment<HomeBottomsheetLearnHowToConnectSmartScaleBinding>()  {
    private val list = arrayListOf(
        LearnHowToConnectData("1","Insert the batteries into your weighing scale"),
        LearnHowToConnectData("2","Place the scale on a flat surface"),
        LearnHowToConnectData("3","Ensure your phone’s Bluetooth is turned on"),
        LearnHowToConnectData("4","Ensure your phone’s Location is turned on"),
        LearnHowToConnectData("5","Remove footwear and/or socks"),
    )
    private val learnHowToConnectAdapter by lazy {
        LearnHowToConnectAdapter(list)
    }
    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean
    ): HomeBottomsheetLearnHowToConnectSmartScaleBinding {
        return HomeBottomsheetLearnHowToConnectSmartScaleBinding.inflate(layoutInflater)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LearnToConnectSmartScale)
    }

    override fun bindData() {
        setUpRecyclerView()
        setUpViewListeners()
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewHowToConnect.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = learnHowToConnectAdapter
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}