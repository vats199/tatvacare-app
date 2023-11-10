package com.mytatva.patient.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.ViewGroup
import com.mytatva.patient.databinding.FragmentGenAIBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment

class GenAIFragment : BaseFragment<FragmentGenAIBinding>() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean
    ): FragmentGenAIBinding {
        return FragmentGenAIBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {

    }

}