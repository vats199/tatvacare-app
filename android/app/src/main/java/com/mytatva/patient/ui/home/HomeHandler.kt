package com.mytatva.patient.ui.home

import com.facebook.react.ReactInstanceManager
import com.mytatva.patient.fcm.Notification
import com.mytatva.patient.ui.GenAIFragment
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
    val genAIFragment: GenAIFragment
    val fragmentHandler: FragmentHandler
    val firebaseConfigUtil: FirebaseConfigUtil

    constructor(fragmentHandler: FragmentHandler, firebaseConfigUtil: FirebaseConfigUtil) {
        this.fragmentHandler = fragmentHandler
        rnHomeFragment = RNHomeFragment()
        homeFragment = HomeFragment()
        carePlanFragment = CarePlanFragment()
        engageFragment = EngageFragment()
        exerciseFragment = ExerciseFragment()
        genAIFragment = GenAIFragment()
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
                genAIFragment
            )
        } else {
            homeFragment.notification = notification
            fragmentHandler.showFragment(
                homeFragment,
                carePlanFragment,
                engageFragment,
                exerciseFragment,
                genAIFragment
            )
        }
    }

    fun showCarePlanFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                carePlanFragment,
                engageFragment,
                exerciseFragment,
                genAIFragment,
                rnHomeFragment
            )
        } else {
            fragmentHandler.showFragment(
                carePlanFragment,
                engageFragment,
                exerciseFragment,
                genAIFragment,
                homeFragment
            )
        }
    }

    fun showMyCircleFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                engageFragment,
                exerciseFragment,
                genAIFragment,
                rnHomeFragment,
                carePlanFragment
            )
        } else {
            fragmentHandler.showFragment(
                engageFragment,
                exerciseFragment,
                genAIFragment,
                homeFragment,
                carePlanFragment
            )
        }
    }

    fun showExerciseFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                exerciseFragment,
                genAIFragment,
                rnHomeFragment,
                carePlanFragment,
                engageFragment
            )
        } else {
            fragmentHandler.showFragment(
                exerciseFragment,
                genAIFragment,
                homeFragment,
                carePlanFragment,
                engageFragment
            )
        }
    }

    fun showGenAIFragment() {
        if (AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
            fragmentHandler.showFragment(
                genAIFragment,
                rnHomeFragment,
                carePlanFragment,
                engageFragment,
                exerciseFragment
            )
        } else {
            fragmentHandler.showFragment(
                genAIFragment,
                homeFragment,
                carePlanFragment,
                engageFragment,
                exerciseFragment
            )
        }
    }

}