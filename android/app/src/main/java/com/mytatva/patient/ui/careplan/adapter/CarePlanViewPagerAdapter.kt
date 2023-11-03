package com.mytatva.patient.ui.careplan.adapter

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentStatePagerAdapter


class CarePlanViewPagerAdapter(fm: FragmentManager) :
    FragmentStatePagerAdapter(fm, Behavior@ BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT) {

    private val mFragmentList = ArrayList<Fragment>()
    private val mTitleList = ArrayList<String>()

    private var currentPosition = -1

    override fun getItem(position: Int): Fragment {
        return mFragmentList[position]
    }

    override fun getCount(): Int {
        return mFragmentList.size
    }

    override fun getPageTitle(position: Int): CharSequence? {
        return mTitleList[position]
    }

    override fun getItemPosition(`object`: Any): Int {
        return POSITION_NONE
    }

    fun addFrag(fragment: Fragment, title: String = "") {
        if (!mFragmentList.contains(fragment)) {
            mFragmentList.add(fragment)
            mTitleList.add(title)
        }
    }

    fun clear() {
        mFragmentList.clear()
        mTitleList.clear()
    }

}