package com.mytatva.patient.data.datasource

import android.text.TextUtils
import com.mytatva.patient.data.pojo.DataWrapper
import com.mytatva.patient.data.pojo.RazorPayResponseBody
import com.mytatva.patient.data.pojo.ResponseBody
import com.mytatva.patient.exception.ServerException
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.File

open class BaseDataSource {

    suspend fun <T> execute(callAPI: suspend () -> ResponseBody<T>): DataWrapper<T> {
        return try {
            val result = callAPI()

            when (result.responseCode) {
                0, 2, 3, 4, 6, /*7,*/ 8, 11, 12 -> {
                    DataWrapper(result, ServerException(result.message ?: "", result.responseCode))
                }
                else -> {
                    DataWrapper(result, null)
                }
            }
        } catch (e: Throwable) {
            DataWrapper(null, e)
        }
    }

    suspend fun <T : RazorPayResponseBody> executeCustom(callAPI: suspend () -> T): T {
        return try {
            val result = callAPI()

            if (result.error == null) {
                result
            } else {
                RazorPayResponseBody() as T
            }
        } catch (e: Throwable) {
            RazorPayResponseBody() as T
        }
    }

    protected fun arrayImagePart(key: String, path: List<String>?): List<MultipartBody.Part>? {

        var parts: MutableList<MultipartBody.Part>? = null

        if (path != null && !path.isEmpty()) {
            parts = ArrayList<MultipartBody.Part>()
            for (i in path.indices) {
                val file = File(path[i])
                val requestBody = file.asRequestBody("image/*".toMediaTypeOrNull())
                val formData = MultipartBody.Part.createFormData("$key[$i]", file.name, requestBody)
                parts.add(formData)

            }
        }
        return parts
    }

    protected fun formRequestBody(value: String): RequestBody {
        return value.toRequestBody(MultipartBody.FORM)
    }

    protected fun singleImagePart(key: String, path: String): MultipartBody.Part? {
        var formData: MultipartBody.Part? = null
        if (!TextUtils.isEmpty(path)) {
            val file = File(path)
            val requestBody = file.asRequestBody("image/*".toMediaTypeOrNull())
            formData = MultipartBody.Part.createFormData(key, file.name, requestBody)
        }
        return formData
    }

}