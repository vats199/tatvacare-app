package com.mytatva.patient.ui.common.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.databinding.CommonFragmentBlankBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment

class BlankFragment : BaseFragment<CommonFragmentBlankBinding>() {

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CommonFragmentBlankBinding {
        return CommonFragmentBlankBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun bindData() {

    }


    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }


}