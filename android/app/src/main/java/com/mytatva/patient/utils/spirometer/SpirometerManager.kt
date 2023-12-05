package com.mytatva.patient.utils.spirometer

import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.model.Device
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.mydevices.bottomsheet.ConnectSmartScaleBottomSheetDialog
import com.mytatva.patient.ui.spirometer.bottomsheet.TestTypeBottomSheetDialog
import com.mytatva.patient.ui.spirometer.dialog.EnterTargetVolumeDialog
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.sdk.alveoairsdk.StartSpirometryTest
import java.util.UUID
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class SpirometerManager @Inject constructor(
    val context: Context,
    val session: Session,
) {

    companion object {
        var isIncentive = false
        var spiroMeterTestUUID = ""
    }

    @Inject
    lateinit var locationManager: LocationManager

    @Inject
    lateinit var analytics: AnalyticsClient

    private var activity: AppCompatActivity? = null

    /*val age: Int by lazy {
        session.user?.getAgeValue ?: 0
    }

    val height: Int by lazy {
        session.user?.getHeightValue ?: 0
    }

    val weight: Int by lazy {
        session.user?.getWeightValue ?: 0
    }*/

    private fun log(msg: String) {
        Log.d(this::class.java.simpleName, ":: $msg")
    }

    var finishCallback: (() -> Unit)? = null
    fun initStartTestFlow(activity: AppCompatActivity, finishCallback: () -> Unit) {
        this.finishCallback = finishCallback
        this.activity = activity
        (activity as BaseActivity).toggleLoader(true)
        locationManager.startLocationUpdates({ location, exception ->
            activity.toggleLoader(false)
            location?.let {
                locationManager.stopFetchLocationUpdates()

                StartSpirometryTest.setLatLon(
                    it.latitude.toString(),
                    it.longitude.toString(),
                    activity
                )

                TestTypeBottomSheetDialog()
                    .setCallback { isIncentive ->

                        analytics.logEvent(
                            analytics.SELECT_TEST_TYPE,
                            Bundle().apply {
                                putString(
                                    analytics.PARAM_MEDICAL_DEVICE,
                                    Common.MedicalDevice.SPIROMETER
                                )
                                putString(
                                    analytics.PARAM_TEST_TYPE,
                                    if (isIncentive) "Incentive" else "Standard"
                                )
                            },
                            screenName = AnalyticsScreenNames.SelectTestType
                        )

                        if (isIncentive) {
                            //if isIncentive test, then ask for the target volume
                            EnterTargetVolumeDialog().setCallback { targetVolume ->
                                initiateBluetoothFlow(isIncentive, targetVolume = targetVolume)
                            }.show(
                                activity.supportFragmentManager,
                                EnterTargetVolumeDialog::class.java.simpleName
                            )
                        } else {
                            initiateBluetoothFlow(isIncentive)
                        }

                    }.show(activity.supportFragmentManager, null)

            }
            exception?.let {
                // location will not be updated
                if (it.status == LocationManager.Status.NO_PERMISSION) {
                    activity.showOpenPermissionSettingDialog()
                }
                //it.status==LocationManager.Status.DENIED_LOCATION_SETTING
            }
        }, true)
    }

    private fun initiateBluetoothFlow(incentive: Boolean, targetVolume: Int? = null) {
        activity?.supportFragmentManager?.let {
            ConnectSmartScaleBottomSheetDialog().apply {
                this.deviceKey = Device.Spirometer.deviceKey
                this.spiroProceedCallback = {
                    startTest(incentive, targetVolume)
                }
            }.show(it, ConnectSmartScaleBottomSheetDialog::class.java.simpleName)
        }
    }

    private fun startTest(incentive: Boolean, targetVolume: Int? = null) {

        val spiroClientId = if (MyTatvaApp.IS_SPIRO_PROD)
            BuildConfig.SPIROMETER_CLIENT_ID_PROD
        else
            BuildConfig.SPIROMETER_CLIENT_ID

        val spiroServerKey = if (MyTatvaApp.IS_SPIRO_PROD)
            BuildConfig.SPIROMETER_SERVER_KEY_PROD
        else
            BuildConfig.SPIROMETER_SERVER_KEY

        val spiroAccountId = if (MyTatvaApp.IS_SPIRO_PROD)
            BuildConfig.SPIROMETER_ACCOUNT_ID_PROD
        else
            BuildConfig.SPIROMETER_ACCOUNT_ID

        val age = session.user?.getAgeValue ?: 0
        val height = session.user?.getHeightValue ?: 0
        val weight = session.user?.getWeightValue ?: 0

        val uuID = UUID.randomUUID().toString()
        log(
            "initAlveoAir data:" +
                    "\n spiroClientId $spiroClientId" +
                    "\n spiroServerKey $spiroServerKey" +
                    "\n spiroAccountId $spiroAccountId" +
                    "\n UUID $uuID" +
                    "\n userId ${session.userId}" +
                    "\n height ${height.toFloat()}" +
                    "\n weight ${weight.toFloat()}" +
                    "\n age $age" +
                    "\n ethnicity ${session.user?.ethnicity}" +
                    "\n GenderCode ${session.user?.getGenderCodeForSpirometer}"
        )

        isIncentive = incentive
        spiroMeterTestUUID = uuID

        if (incentive) {//incentive

            val spirometeryTest = StartSpirometryTest()
            spirometeryTest.initSDKCall(activity)
            spirometeryTest.setCallback {
                log("Spirometry Callback Incentive")
                finishCallback?.invoke()
            }

            spirometeryTest.startIncentive(
                activity,
                spiroClientId,
                spiroServerKey,
                spiroAccountId,
                session.userId /*"af282574-edc0-11ed-1ab2-211e1aed"*/,
                session.user?.name,
                session.user?.getGenderCodeForSpirometer /*"MALE"*/,
                age,
                session.user?.ethnicity,/*"NORTH_INDIAN",*/
                height.toFloat() /*180f*/, // height(CM)
                weight.toFloat() /*75f*/, // weight(KG)
                uuID,
                targetVolume ?: 1000
            )

//            EnterTargetVolumeDialog().setCallback { targetVolume ->
//
//                val spirometeryTest = StartSpirometryTest()
//                spirometeryTest.initSDKCall(activity)
//                spirometeryTest.setCallback {
//                    log("Spirometry Callback Incentive")
//                    finishCallback?.invoke()
//                }
//
//                spirometeryTest.startIncentive(
//                    activity,
//                    spiroClientId,
//                    spiroServerKey,
//                    spiroAccountId,
//                    session.userId /*"af282574-edc0-11ed-1ab2-211e1aed"*/,
//                    session.user?.name,
//                    session.user?.getGenderCodeForSpirometer /*"MALE"*/,
//                    age,
//                    session.user?.ethnicity,/*"NORTH_INDIAN",*/
//                    height.toFloat() /*180f*/, // height(CM)
//                    weight.toFloat() /*75f*/, // weight(KG)
//                    uuID,
//                    targetVolume
//                )
//
//            }.show(
//                activity!!.supportFragmentManager,
//                EnterTargetVolumeDialog::class.java.simpleName
//            )

        } else {//standard

            val spirometeryTest = StartSpirometryTest()
            spirometeryTest.initSDKCall(activity)
            spirometeryTest.setCallback {
                log("Spirometry Callback Standard")
                finishCallback?.invoke()
            }
            spirometeryTest.startStandard(
                activity,
                spiroClientId,
                spiroServerKey,
                spiroAccountId,
                session.userId, //"af282574-edc0-11ed-1ab2-022e1vbc",
                session.user?.name,
                session.user?.getGenderCodeForSpirometer/*"MALE"*/,
                age,
                session.user?.ethnicity,/*"NORTH_INDIAN",*/
                height.toFloat(), // height(CM)
                weight.toFloat(), // weight(KG)
                uuID
            )
        }
    }

}