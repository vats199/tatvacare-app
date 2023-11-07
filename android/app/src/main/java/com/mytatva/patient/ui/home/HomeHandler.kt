package com.mytatva.patient.ui.home

import com.facebook.react.ReactInstanceManager
import com.mytatva.patient.fcm.Notification
import com.mytatva.patient.ui.careplan.fragment.CarePlanFragment
import com.mytatva.patient.ui.engage.fragment.EngageFragment
import com.mytatva.patient.ui.exercise.ExerciseFragment
import com.mytatva.patient.ui.home.fragment.HomeFragment
import com.mytatva.patient.ui.manager.FragmentHandler
import com.mytatva.patient.utils.FirebaseConfigUtil
import com.mytatva.patient.utils.apputils.AppFlagHandler

class HomeHandler {
    val rnHomeFragment: RNHomeFragment//HomeFragment
    val homeFragment: HomeFragment//HomeFragment
    val carePlanFragment: CarePlanFragment//CarePlanFragment
    val engageFragment: EngageFragment//EngageFragment
    val exerciseFragment: ExerciseFragment//ExerciseFragment
    val moreFragment: HomeFragment//MoreFragment
    val fragmentHandler: FragmentHandler
    val firebaseConfigUtil: FirebaseConfigUtil

    constructor(fragmentHandler: FragmentHandler, firebaseConfigUtil: FirebaseConfigUtil) {
        this.fragmentHandler = fragmentHandler
        rnHomeFragment = RNHomeFragment()
        homeFragment = HomeFragment()
        carePlanFragment = CarePlanFragment()
        engageFragment = EngageFragment()
        exerciseFragment = ExerciseFragment()
        moreFragment = HomeFragment()
        this.firebaseConfigUtil = firebaseConfigUtil
    }

    fun showHomeFragment(
        notification: Notification? = null,
        reactInstanceManager: ReactInstanceManager
    ) {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            val fragment = rnHomeFragment
            fragment.setReactInstanceManager(reactInstanceManager, null)
            homeFragment.notification = notification
            fragmentHandler.showFragment(
                fragment,
                carePlanFragment,
                engageFragment,
                exerciseFragment,
                moreFragment
            )
        } else {
            homeFragment.notification = notification
            fragmentHandler.showFragment(
                homeFragment,
                carePlanFragment,
                engageFragment,
                exerciseFragment,
                moreFragment
            )
        }
    }

    fun showCarePlanFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                carePlanFragment,
                engageFragment,
                exerciseFragment,
                moreFragment,
                rnHomeFragment
            )
        } else {
            fragmentHandler.showFragment(
                carePlanFragment,
                engageFragment,
                exerciseFragment,
                moreFragment,
                homeFragment
            )
        }
    }

    fun showMyCircleFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                engageFragment,
                exerciseFragment,
                moreFragment,
                rnHomeFragment,
                carePlanFragment
            )
        } else {
            fragmentHandler.showFragment(
                engageFragment,
                exerciseFragment,
                moreFragment,
                homeFragment,
                carePlanFragment
            )
        }
    }

    fun showExerciseFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                exerciseFragment,
                moreFragment,
                rnHomeFragment,
                carePlanFragment,
                engageFragment
            )
        } else {
            fragmentHandler.showFragment(
                exerciseFragment,
                moreFragment,
                homeFragment,
                carePlanFragment,
                engageFragment
            )
        }
    }

    fun showMoreFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                moreFragment,
                rnHomeFragment,
                carePlanFragment,
                engageFragment,
                exerciseFragment
            )
        } else {
            fragmentHandler.showFragment(
                moreFragment,
                homeFragment,
                carePlanFragment,
                engageFragment,
                exerciseFragment
            )
        }
    }

}