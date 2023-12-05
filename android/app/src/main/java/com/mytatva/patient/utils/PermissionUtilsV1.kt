package com.mytatva.patient.utils

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity

object PermissionUtilsV1 {

    const val STORAGE_READ_PERMISSION_REQUEST_CODE = 100
    const val STORAGE_WRITE_PERMISSION_REQUEST_CODE = 101
    const val CAMERA_PERMISSION_REQUEST_CODE = 102
    const val DOCUMENT_PERMISSION_REQUEST_CODE = 103

    var IMAGE_PERMISSIONS: String =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            Manifest.permission.READ_MEDIA_IMAGES
        } else {
            Manifest.permission.READ_EXTERNAL_STORAGE
        }


    var VIDEO_PERMISSIONS: String =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            Manifest.permission.READ_MEDIA_VIDEO
        } else {
            Manifest.permission.READ_EXTERNAL_STORAGE
        }


    var CAMERA_PERMISSIONS: String =
        Manifest.permission.CAMERA

    var READ_PERMISSIONS: String =
        Manifest.permission.READ_EXTERNAL_STORAGE

    var WRITE_PERMISSIONS: String =
        Manifest.permission.WRITE_EXTERNAL_STORAGE

    fun requestImagePermission(activity: FragmentActivity) {
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(IMAGE_PERMISSIONS),
            STORAGE_READ_PERMISSION_REQUEST_CODE
        )
    }

    fun requestVideoPermission(activity: FragmentActivity) {
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(VIDEO_PERMISSIONS),
            STORAGE_READ_PERMISSION_REQUEST_CODE
        )
    }

    fun requestWritePermission(activity: FragmentActivity) {
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(WRITE_PERMISSIONS),
            STORAGE_WRITE_PERMISSION_REQUEST_CODE
        )
    }

    fun requestCameraPermission(activity: FragmentActivity) {
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(CAMERA_PERMISSIONS),
            CAMERA_PERMISSION_REQUEST_CODE
        )
    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
        onStorageReadPermissionGranted: (isGrant: Boolean) -> Unit,
        onStorageWritePermissionGranted: (isGrant: Boolean) -> Unit,
        onCameraPermissionGranted: (isGrant: Boolean) -> Unit,
        onDocumentPermissionGranted: (isGrant: Boolean) -> Unit,
    ) {
        when (requestCode) {
            STORAGE_READ_PERMISSION_REQUEST_CODE -> {
                onStorageReadPermissionGranted.invoke(PermissionUtil.verifyPermissions(grantResults))
            }

            STORAGE_WRITE_PERMISSION_REQUEST_CODE -> {
                onStorageWritePermissionGranted.invoke(PermissionUtil.verifyPermissions(grantResults))
            }

            CAMERA_PERMISSION_REQUEST_CODE -> {
                onCameraPermissionGranted.invoke(PermissionUtil.verifyPermissions(grantResults))
            }

            DOCUMENT_PERMISSION_REQUEST_CODE -> {
                onDocumentPermissionGranted.invoke(PermissionUtil.verifyPermissions(grantResults))
            }
        }
    }

    fun isPermissionGrant(context: Context, permission: String): Boolean {
        return ContextCompat.checkSelfPermission(
            context,
            permission
        ) == PackageManager.PERMISSION_GRANTED
    }
}