package com.mytatva.patient.ui.home

import com.facebook.react.ReactInstanceManager
import com.mytatva.patient.ui.home.fragment.HomeFragment
import com.mytatva.patient.ui.manager.FragmentHandler
import com.mytatva.patient.utils.FirebaseConfigUtil
import com.mytatva.patient.utils.apputils.AppFlagHandler

class HomeHandler {
    val rnHomeFragment: RNHomeFragment//HomeFragment
    val homeFragment: HomeFragment//HomeFragment
    val fragmentHandler: FragmentHandler
    val firebaseConfigUtil: FirebaseConfigUtil

    constructor(fragmentHandler: FragmentHandler, firebaseConfigUtil: FirebaseConfigUtil) {
        this.fragmentHandler = fragmentHandler
        rnHomeFragment = RNHomeFragment()
        homeFragment = HomeFragment()
        this.firebaseConfigUtil = firebaseConfigUtil
    }

    fun showHomeFragment(
        reactInstanceManager: ReactInstanceManager
    ) {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            val fragment = rnHomeFragment
            fragment.setReactInstanceManager(reactInstanceManager, null)
            fragmentHandler.showFragment(
                fragment
            )
        } else {
            fragmentHandler.showFragment(
                homeFragment
            )
        }
    }

    fun showCarePlanFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                rnHomeFragment
            )
        } else {
            fragmentHandler.showFragment(
                homeFragment
            )
        }
    }

    fun showMyCircleFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                rnHomeFragment
            )
        } else {
            fragmentHandler.showFragment(
                homeFragment
            )
        }
    }

    fun showExerciseFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                rnHomeFragment,
            )
        } else {
            fragmentHandler.showFragment(
                homeFragment
            )
        }
    }

}