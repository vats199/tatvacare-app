package com.mytatva.patient.data.pojo.response

import com.google.gson.*
import com.google.gson.annotations.JsonAdapter
import com.google.gson.annotations.SerializedName
import com.mytatva.patient.fcm.Notification
import com.mytatva.patient.utils.TimeAgo
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.lang.reflect.Type


class NotificationResData(
    @SerializedName("unread_counts")
    val unread_counts: String? = null,
    @SerializedName("list")
    val list: ArrayList<NotificationData>? = null,
)

class NotificationData(
    @SerializedName("_id")
    val _id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("mesage")
    val mesage: String? = null,
    @SerializedName("we_notification_id")
    val we_notification_id: String? = null,
    @SerializedName("deep_link")
    val deep_link: String? = null,
    @SerializedName("createdAt")
    val createdAt: String? = null,
    @SerializedName("updatedAt")
    val updatedAt: String? = null,
    @SerializedName("is_read")
    val is_read: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
    @SerializedName("__v")
    val __v: String? = null,
    @JsonAdapter(CustomDataDeserializer::class)
    @SerializedName("data")
    val data: Data? = null,
) {
    val formattedUpdatedDate: String
        get() {
            return try {
                TimeAgo.getTimeAgoElseDate(
                    DateTimeFormatter
                        //dateUTC
                        .dateUTC(
                            createdAt,
                            DateTimeFormatter.FORMAT_NODE
                        ).date!!.time,
                    DateTimeFormatter.FORMAT_ddMMMyyyy
                ) ?: ""
            } catch (e: Exception) {
                ""
            }
        }
}

class Data(
    /*@SerializedName("custom")*/
    @SerializedName("custom")
    var custom: CustomData? = null,
)

class CustomData(
    @SerializedName("message")
    val notification: Notification? = null,
)


class CustomDataDeserializer : /*JsonSerializer<Data>,*/ JsonDeserializer<Data?> {
    /*override fun serialize(
        src: Data?,
        typeOfSrc: Type?,
        context: JsonSerializationContext?,
    ): JsonElement {
        val jsonObject = JsonObject()
        return jsonObject
    }*/

    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?,
    ): Data? {
        if (json?.asJsonObject?.get("custom") is JsonObject) {
            val data = Data()
            val customJsonObjectString = json.asJsonObject?.get("custom").toString()
            data.custom = Gson().fromJson(customJsonObjectString, CustomData::class.java)
            return data
        } else {
            return null
        }
    }

}