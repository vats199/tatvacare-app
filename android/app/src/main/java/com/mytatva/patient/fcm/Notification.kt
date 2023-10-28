package com.mytatva.patient.fcm

import android.annotation.SuppressLint
import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@SuppressLint("ParcelCreator")
@Parcelize
class Notification(
    @SerializedName("flag")
    var flag: String? = null,
    @SerializedName("other_details")
    var other_details: OtherDetails? = null,
    @SerializedName("title")
    var title: String? = null,
    @SerializedName("message")
    var message: String? = null,
) : Parcelable

@SuppressLint("ParcelCreator")
@Parcelize
class OtherDetails(
    @SerializedName("goal_master_id")
    var goal_master_id: String? = null,
    @SerializedName("readings_master_id")
    var readings_master_id: String? = null,
    @SerializedName("deep_link")
    var deep_link: String? = null,
    @SerializedName("key")
    var key: String? = null,
) : Parcelable


/*
"other_details": {
      "goal_master_id": "25b7f7cc-1a16-11ec-9b7c-02004825dc14"
    },
    "flag": "ExerciseReminder",
    "title": "MyTatva",
    "message": "Update your exercise logs"
  }
 */