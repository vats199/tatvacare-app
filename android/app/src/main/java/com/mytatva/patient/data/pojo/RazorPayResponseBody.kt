package com.mytatva.patient.data.pojo

import com.google.gson.annotations.SerializedName

open class RazorPayResponseBody {
    @SerializedName("error")
    var error: Error? = null

    /*@SerializedName("id")
    val id: String? = null*/
    /*
    {"error":{"code":"BAD_REQUEST_ERROR","description":"The requested URL was not found on the server.","source":"NA","step":"NA","reason":"NA","metadata":{}}}
     */
}

class Error(
    @SerializedName("code")
    val code: String? = null,
    @SerializedName("description")
    var description: String? = null,
    @SerializedName("source")
    val source: String? = null,
    @SerializedName("step")
    val step: String? = null,
    @SerializedName("reason")
    val reason: String? = null,
)