package com.mytatva.patient.utils

import android.Manifest
import android.annotation.SuppressLint
import android.app.DownloadManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import androidx.core.content.ContextCompat
import com.mytatva.patient.core.Session
import com.mytatva.patient.ui.base.BaseActivity
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class DownloadHelper @Inject constructor(val context: Context, val session: Session)
/*(val activity: Activity)*/ {

    val DIR_DIET_PLAN = "MyTatvaDietPlan"
    val DIR_REPORTS = "MyTatvaReports"
    val DIR_INVOICE = "MyTatvaInvoice"

    fun getFileNameForBcaReport(): String {
        val fName = session.user?.name
        //?.replace(" ","")
        //?.replace("'","")
        //?.replace(".","")
        return "${fName}'s Smart Analyser Report - ".plus(SimpleDateFormat("dd-MM-yyyy HH-mm", Locale.US).format(Date()))
    }

    fun getFileNameForSpirometerReport(): String {
        val fName = session.user?.name
        //?.replace(" ","")
        //?.replace("'","")
        //?.replace(".","")
        return "${fName}'s Spirometer Report - ".plus(SimpleDateFormat("dd-MM-yyyy HH-mm", Locale.US).format(Date())).plus(".pdf")
    }

    fun getFileNameForInvoice(): String {
        val fName = session.user?.name
        return "Invoice - ".plus(SimpleDateFormat("dd-MM-yyyy HH-mm", Locale.US).format(Date())).plus(".pdf")
    }


    private val REQUEST_PERMISSION_STORAGE = 1001

    var activity: BaseActivity? = null

    private var downloadFileName: String = ""
    private var downloadUrl: String = ""
    private var downloadDirName: String = ""
    private var mgr: DownloadManager? = null
    var onComplete: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(ctxt: Context, intent: Intent) {
            (activity as BaseActivity).showErrorMessage("Downloaded")
        }
    }

    init {
        //mgr = activity!!.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
    }

    fun registerReceiver() {
        activity?.registerReceiver(
            onComplete,
            IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE)
        )
    }

    fun unregisterReceiver() {
        try {
            activity?.unregisterReceiver(onComplete)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * *****************************************************
     * Download video methods
     * *****************************************************
     */
    fun startDownload(downloadUrl: String, downloadFileName: String, downloadDirName: String) {
        mgr = activity?.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager

        this.downloadUrl = downloadUrl
        this.downloadFileName = downloadFileName
        this.downloadDirName = downloadDirName

        if (!checkPermissionForStorage()) {

            activity?.requestPermissions(
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                REQUEST_PERMISSION_STORAGE
            )

        } else {

            /*if (downloadStorageDirectory == null) {
               downloadStorageDirectory = File(activity?.filesDir, Common.COURSE_VIDEO_DIRECTORY)
           }*/

            if (downloadFileName != null) {

                if (NetworkUtil.isNetworkAvailable(activity)) {

                    if (downloadUrl.isNotEmpty()) {

                        val uri = Uri.parse(downloadUrl)

                        /*if (downloadStorageDirectory?.exists() != true)
                            downloadStorageDirectory?.mkdirs()*/

                        val lastDownload =
                            mgr!!.enqueue(
                                DownloadManager.Request(uri)
                                    .setAllowedNetworkTypes(
                                        DownloadManager.Request.NETWORK_WIFI or
                                                DownloadManager.Request.NETWORK_MOBILE
                                    )
//                            .setAllowedOverRoaming(false)
                                    .setTitle(downloadFileName)
                                    .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
//                            .setDescription("Something useful. No, really.")
                                    /*.setDestinationInExternalFilesDir(activity, Common.COURSE_VIDEO_DIRECTORY, tutorCoursesData.title + "-" + uri.lastPathSegment)*/
                                    .setDestinationInExternalPublicDir(
                                        Environment.DIRECTORY_DOWNLOADS,
                                        "$downloadDirName/$downloadFileName"
                                    )
                            )//MyTatvaDietPlan

                    }

                } else {
                    (activity as BaseActivity).showErrorMessage("Connect to internet")
                }
            }

        }


    }

    @SuppressLint("ObsoleteSdkInt")
    private fun checkPermissionForStorage(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Build.VERSION.SDK_INT <= Build.VERSION_CODES.Q) {
            checkPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE))
        } else {
            true
        }
    }

    private fun checkPermissions(permissions: Array<String>): Boolean {
        var shouldCheck = true
        for (permission in permissions) {
            shouldCheck = shouldCheck and (PackageManager.PERMISSION_GRANTED ==
                    ContextCompat.checkSelfPermission(activity!!, permission))
        }
        return shouldCheck
    }

    /**
     * Handles the onRequestPermissionsResult
     */
    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        when (requestCode) {
            REQUEST_PERMISSION_STORAGE -> {
                if (PermissionUtil.verifyPermissions(grantResults)) {
                    startDownload(downloadUrl, downloadFileName, downloadDirName)
                } else {
                    activity?.showErrorMessage("Storage permission required")
                }
            }
        }
    }


}