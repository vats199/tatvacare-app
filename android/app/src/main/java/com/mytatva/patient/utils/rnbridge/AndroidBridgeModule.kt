package com.mytatva.patient.utils.rnbridge

import android.os.Bundle
import androidx.core.os.bundleOf
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.data.pojo.response.IncidentSurveyData
import com.mytatva.patient.ui.GenAIActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.appointment.fragment.AllAppointmentsFragment
import com.mytatva.patient.ui.appointment.fragment.BookAppointmentsFragment
import com.mytatva.patient.ui.auth.fragment.SelectYourLocationFragment
import com.mytatva.patient.ui.auth.fragment.SetupGoalsReadingsFragment
import com.mytatva.patient.ui.auth.fragment.SetupHeightWeightFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.careplan.fragment.AddIncidentFragment
import com.mytatva.patient.ui.engage.fragment.EngageFeedDetailsFragment
import com.mytatva.patient.ui.goal.fragment.FoodDiaryMainFragment
import com.mytatva.patient.ui.goal.fragment.UpdateGoalLogsFragment
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.home.fragment.DevicesFragment
import com.mytatva.patient.ui.home.fragment.SearchFragment
import com.mytatva.patient.ui.labtest.fragment.LabTestListFragment
import com.mytatva.patient.ui.menu.fragment.BookmarksFragment
import com.mytatva.patient.ui.menu.fragment.HelpSupportFAQFragment
import com.mytatva.patient.ui.menu.fragment.HistoryFragment
import com.mytatva.patient.ui.payment.fragment.v1.BcpPurchasedDetailsFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentCarePlanListingFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentPlanDetailsV1Fragment
import com.mytatva.patient.ui.profile.fragment.AccountSettingsFragment
import com.mytatva.patient.ui.profile.fragment.MyProfileFragment
import com.mytatva.patient.ui.profile.fragment.NotificationsFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingsMainFragment
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.openAppInStore
import com.mytatva.patient.utils.shareApp
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.json.JSONObject


class AndroidBridgeModule(var reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(
    reactContext
) {

    init {
        ContextHolder.reactContext = reactContext
    }

    override fun getName(): String {
        return "AndroidBridge"
    }


    @ReactMethod
    fun openNotificationScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_NOTIFICATION,
            Bundle()
        )
        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, NotificationsFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openMyProfileScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.USER_CLICKED_ON_MENU,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_PROFILE
                )
            })

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            MyProfileFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openSearchScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_SEARCH,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_SEARCH_TYPE,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_ATTEMPTED
                )
            })

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            SearchFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openAllPlanScreen(showPlanType: String) {
        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
        ).addBundle(Bundle().apply {
            putString(Common.BundleKey.SHOW_PLAN_TYPE, showPlanType)
        }).start()
    }

    @ReactMethod
    fun openConsultNutritionistScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_CONSULT_NUTRITIONIST,
            Bundle()
        )

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, BookAppointmentsFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openConsultPhysioScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_CONSULT_PHYSIO,
            Bundle()
        )

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, BookAppointmentsFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openLabTestScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_LAB_TESTS
                )
            })

        /*(currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, LabTestListFragment::class.java
        ).start()*/

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            HistoryFragment::class.java
        )
            .addBundle(Bundle().apply {
                putBoolean(Common.BundleKey.IS_SHOW_TEST, true)
            }).start()
    }

    @ReactMethod
    fun openBookDiagnosticScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.HOME_LABTEST_CARD_CLICKED,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_LAB_TESTS
                )
            })

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, LabTestListFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openDeviceScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_HEALTH_DIARY,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DEVICES
                )
            }
        )

        /*if ((currentActivity as BaseActivity?)!!.session.user!!.patient_plans.isEmpty()) {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
            ).start()
        } else if (!(currentActivity as BaseActivity?)!!.session.user!!.patient_plans.isEmpty() && (currentActivity as BaseActivity?)!!.session.user!!.patient_plans[0].plan_type == "Free") {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
            ).start()
        } else {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, DevicesFragment::class.java
            ).start()
        }*/

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, DevicesFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openBookDeviceScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_BOOK_DEVICES,
            Bundle()
        )

        /*if ((currentActivity as BaseActivity?)!!.session.user!!.patient_plans.isEmpty()) {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
            ).start()
        } else if (!(currentActivity as BaseActivity?)!!.session.user!!.patient_plans.isEmpty() && (currentActivity as BaseActivity?)!!.session.user!!.patient_plans[0].plan_type == "Free") {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
            ).start()
        } else {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, DevicesFragment::class.java
            ).start()
        }*/

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, DevicesFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openAccountSettingScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_ACCOUNT_SETTINGS
                )
            })

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, AccountSettingsFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openHelpSupportScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_CONTACT_US
                )
            })

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, HelpSupportFAQFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openHealthGoalScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_GOALS
                )
            })

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, SetupGoalsReadingsFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openAllAppointmentScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_CONSULTATIONS
                )
            })

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, AllAppointmentsFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openBookmarkScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_BOOKMARKS
                )
            })

        if ((currentActivity as BaseActivity?)!!.isFeatureAllowedAsPerPlan(
                PlanFeatures.bookmarks,
                "",
                true,
                null
            )
        ) {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, BookmarksFragment::class.java
            ).start()
        }
    }

    @ReactMethod
    fun openHealthRecordScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_HEALTH_RECORDS
                )
            })

        val bundle = Bundle()
        bundle.putBoolean(Common.BundleKey.IS_SHOW_RECORD, true)
        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            HistoryFragment::class.java
        ).addBundle(bundle).start()
    }

    @ReactMethod
    fun openLocationSelectionScreen() {
        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, SelectYourLocationFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openDietScreen(percentage: Int) {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.USER_CLICKED_ON_DIET_PLAN_CARD,
            Bundle()
        )

        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_HEALTH_DIARY,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIET
                )
                putInt(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM_COMPLETION,
                    percentage
                )
            }
        )

        if ((currentActivity as BaseActivity?)!!.isFeatureAllowedAsPerPlan(
                PlanFeatures.activity_logs, Goals.Diet.goalKey, true, null
            )
        ) {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, FoodDiaryMainFragment::class.java
            ).start()
        }
    }

    @ReactMethod
    fun openIncidentScreen(incidentData: String) {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_HEALTH_DIARY,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MY_INCIDENTS
                )
            }
        )

        /*runOnUiThread(Runnable {
            (currentActivity as HomeActivity?)!!.navigateToCarePlan()
        })*/

        val data = Gson().fromJson<IncidentSurveyData>(incidentData, IncidentSurveyData::class.java)

        (currentActivity as HomeActivity?)!!.loadActivity(
            TransparentActivity::class.java,
            AddIncidentFragment::class.java
        )
            .addBundle(
                bundleOf(
                    Pair(
                        Common.BundleKey.INCIDENT_SURVEY_DATA,
                        data
                    )
                )
            ).start()
    }

    @ReactMethod
    fun openLearnScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_CONTENT_VIEW_ALL,
            Bundle()
        )

        runOnUiThread(Runnable {
            (currentActivity as HomeActivity?)!!.navigateToDiscover()
        })
    }

    @ReactMethod
    fun openLearnDetailsScreen(contentId: String, contentType: String) {
        val bundle = Bundle()
        bundle.putString(Common.BundleKey.CONTENT_TYPE, contentType)
        bundle.putString(Common.BundleKey.CONTENT_ID, contentId)
        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            EngageFeedDetailsFragment::class.java
        ).addBundle(bundle).start()
    }

    @ReactMethod
    fun openExerciseDetailsScreen(exerciseList: String, index: Int, percentage: Int) {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_HEALTH_DIARY,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_EXERCISES
                )
                putInt(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM_COMPLETION,
                    percentage
                )
            }
        )

//        if ((currentActivity as BaseActivity?)!!.isFeatureAllowedAsPerPlan(
//                PlanFeatures.activity_logs,
//                Goals.Exercise.goalKey
//            )
//        )
//        {
//            runOnUiThread(Runnable {
//                (currentActivity as HomeActivity?)!!.navigateToExercise()
//            })
//        }
//        else {
        val token = object : TypeToken<ArrayList<GoalReadingData>>() {}
        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            UpdateGoalLogsFragment::class.java
        ).addBundle(
            bundleOf(
                Pair(
                    Common.BundleKey.POSITION, index
                ),
                Pair(Common.BundleKey.GOAL_LIST, Gson().fromJson(exerciseList, token.type))
            )
        ).start()
//        }
    }

    @ReactMethod
    fun openMedicationScreen(exerciseList: String, index: Int, percentage: Int) {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_HEALTH_DIARY,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MEDICINE
                )
                putInt(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM_COMPLETION,
                    percentage
                )
            }
        )

        val token = object : TypeToken<ArrayList<GoalReadingData>>() {}
        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            UpdateGoalLogsFragment::class.java
        ).addBundle(
            bundleOf(
                Pair(
                    Common.BundleKey.POSITION, index
                ),
                Pair(Common.BundleKey.GOAL_LIST, Gson().fromJson(exerciseList, token.type))
            )
        ).start()
    }

    @ReactMethod
    fun openCheckAllPlanScreen() {
        if ((currentActivity as BaseActivity?)!!.session.user?.currentPlan?.plan_master_id.isNullOrBlank()
                .not()
        ) {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java,
                BcpPurchasedDetailsFragment::class.java
            ).addBundle(Bundle().apply {
                putString(
                    Common.BundleKey.PATIENT_PLAN_REL_ID,
                    (currentActivity as BaseActivity?)!!.session.user?.currentPlan?.patient_plan_rel_id
                )
            }).start()
        } else {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java,
                PaymentCarePlanListingFragment::class.java
            ).start()
        }
    }

    @ReactMethod
    fun openFreePlanDetailScreen(planDetails: String) {
        val obj = JSONObject(planDetails)

        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.HOME_CARE_PLAN_CARD_CLICKED,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_PLAN_ID,
                    obj.getString("plan_master_id")
                )
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_PLAN_TYPE,
                    obj.getString("plan_type")
                )
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_CURRENT_PLAN_TYPE,
                    "free"
                )
            }
        )

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            PaymentPlanDetailsV1Fragment::class.java
        ).addBundle(

            bundleOf(
                Pair(Common.BundleKey.PLAN_ID, obj.getString("plan_master_id")),
                Pair(Common.BundleKey.PLAN_TYPE, obj.getString("plan_type")),
                Pair(
                    Common.BundleKey.PATIENT_PLAN_REL_ID, if (obj.has("patient_plan_rel_id")) {
                        obj.getString("patient_plan_rel_id")
                    } else {
                        ""
                    }
                ),
                Pair(
                    Common.BundleKey.ENABLE_RENT_BUY,
                    obj.getString("enable_rent_buy")
                ),
            )
        ).start()
    }

    @ReactMethod
    fun openPurchasedPlanDetailScreen(planDetails: String) {
        val obj = JSONObject(planDetails)

        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.HOME_CARE_PLAN_CARD_CLICKED,
            Bundle()
        )

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java,
            BcpPurchasedDetailsFragment::class.java
        ).addBundle(
            bundleOf(
                Pair(
                    Common.BundleKey.PATIENT_PLAN_REL_ID,
                    if (obj.has("patient_plan_rel_id")) {
                        obj.getString("patient_plan_rel_id")
                    } else {
                        ""
                    }
                ),
            )
        ).start()
    }


    @ReactMethod
    fun openGoalItemDetailScreen(goalList: String, keys: String, index: Int) {
        val token = object : TypeToken<ArrayList<GoalReadingData>>() {}
        if ((currentActivity as BaseActivity?)!!.isFeatureAllowedAsPerPlan(
                PlanFeatures.activity_logs,
                keys
            )
        ) {

            (currentActivity as BaseActivity?)!!.loadActivity(
                TransparentActivity::class.java,
                UpdateGoalLogsFragment::class.java
            ).addBundle(
                bundleOf(
                    Pair(Common.BundleKey.POSITION, index),
                    Pair(Common.BundleKey.GOAL_LIST, Gson().fromJson(goalList, token.type))
                )
            ).start()

        }
    }

    @ReactMethod
    fun openReadingsItemDetailScreen(goalList: String, keys: String, index: Int) {
        val token = object : TypeToken<ArrayList<GoalReadingData>>() {}

        if ((currentActivity as BaseActivity?)!!.isFeatureAllowedAsPerPlan(
                PlanFeatures.reading_logs,
                keys
            )
        ) {

            if (keys == Readings.CAT.readingKey) {
                //todo
            } else {
                (currentActivity as BaseActivity?)!!.loadActivity(
                    TransparentActivity::class.java,
                    UpdateReadingsMainFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.POSITION, index),
                            Pair(
                                Common.BundleKey.READING_LIST,
                                Gson().fromJson(goalList, token.type)
                            )
                        )
                    ).start()
            }
        }
    }


    @ReactMethod
    fun openBMIScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_BMI
                )
            })

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, SetupHeightWeightFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openShareAppScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_SHARE_APP
                )
            })

        (currentActivity as BaseActivity?)!!.shareApp()
    }

    @ReactMethod
    fun openRateAppScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_RATE_APP
                )
            })

        (currentActivity as BaseActivity?)!!.openAppInStore()
    }

    @ReactMethod
    fun triggerUserToken() {
        val map = Arguments.createMap()
        map.putString("Token", (currentActivity as BaseActivity?)!!.session.user?.token.toString())
        map.putBoolean(
            "IsHideIncident",
            AppFlagHandler.isToHideIncidentSurvey((currentActivity as BaseActivity?)!!.firebaseConfigUtil)
        )

        ContextHolder.reactContext?.let {
            (currentActivity as BaseActivity?)!!.sendEventToRN(
                it,
                "UserToken",
                map
            )
        }

        GlobalScope.launch(Dispatchers.Main) {
            if (currentActivity is HomeActivity) {
                (currentActivity as HomeActivity).initLocation()
            }
        }
    }

    @ReactMethod
    fun onBackPressed() {
        if (currentActivity is GenAIActivity) {
            (currentActivity as BaseActivity?)!!.analytics.logEvent(
                AnalyticsClient.BACK_BUTTON_CLICK,
                Bundle(), (currentActivity as BaseActivity?)!!.analytics.PARAM_CHATBOT_SCREEN
            )

            (currentActivity as GenAIActivity).finish()
        }
    }


}