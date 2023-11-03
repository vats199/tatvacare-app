package com.mytatva.patient.ui.engage.adapter

import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import java.util.*

class CommonViewPager2Adapter(fragment: Fragment) : FragmentStateAdapter(fragment) {

    private val mFragmentList = ArrayList<Fragment>()
    private val mTitleList = ArrayList<String>()

    override fun getItemCount(): Int = mFragmentList.size

    override fun createFragment(position: Int): Fragment {
        return mFragmentList[position]
    }

    fun addFrag(fragment: Fragment, title: String = "") {
        mFragmentList.add(fragment)
        mTitleList.add(title)
    }

    fun clear() {
        mFragmentList.clear()
        mTitleList.clear()
    }
}
