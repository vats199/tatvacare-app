package com.mytatva.patient.core

import okhttp3.Interceptor
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import okhttp3.ResponseBody.Companion.toResponseBody
import okio.Buffer
import java.io.IOException
import javax.inject.Inject

/**
 * Created by hlink21 on 29/11/17.
 */

class AESCryptoInterceptor @Inject
constructor(private val aes: AES) : Interceptor {

    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()

        val plainQueryParameters = request.url.queryParameterNames
        var httpUrl = request.url
        // Check Query Parameters and encrypt
        if (plainQueryParameters != null && !plainQueryParameters.isEmpty()) {
            val httpUrlBuilder = httpUrl.newBuilder()
            for (i in plainQueryParameters.indices) {
                val name = httpUrl.queryParameterName(i)
                val value = httpUrl.queryParameterValue(i)
                httpUrlBuilder.setQueryParameter(name, aes.encrypt(value))
            }
            httpUrl = httpUrlBuilder.build()
        }

        // Get Header for encryption
        val apiKey = request.headers[Session.API_KEY]
        val currentDateTime = request.headers[Session.CURRENT_DATETIME] ?: ""
        val token = request.headers[Session.USER_SESSION]
        val authUserToken = request.headers[Session.AUTH_USER_SESSION]
        val language = request.headers.get(Session.LANGUAGE) ?: ""
        val contentType = request.headers.get(Session.CONTENT_TYPE) ?: ""
        val newRequest: Request
        val requestBuilder = request.newBuilder()

        // Check if any body and encrypt
        val requestBody = request.body
        if (requestBody?.contentType() != null) {
            // bypass multipart parameters for encryption
            val isMultipart =
                !requestBody.contentType()!!.type.equals("multipart", ignoreCase = true)
            val bodyPlainText =
                if (isMultipart) transformInputStream(bodyToString(requestBody)) else bodyToString(
                    requestBody
                )

            if (bodyPlainText != null) {
                if (isMultipart) {
                    requestBuilder
                        .post(bodyPlainText.toRequestBody("text/plain".toMediaType()))
                } else {
                    requestBuilder
                        .post(bodyPlainText.toRequestBody(requestBody.contentType()))
                }
            }
        }

        /*var encryptedToken = ""
        if (token != null && token.isNotEmpty()) {
            encryptedToken = aes.encrypt(token) ?: ""
        }*/
        // Build the final request
        if (token.isNullOrBlank().not()) {
            newRequest = requestBuilder.url(httpUrl)
                .header(Session.API_KEY, aes.encrypt(apiKey)!!)
                .header(Session.CURRENT_DATETIME, currentDateTime)
                .header(Session.USER_SESSION, token!!)
                .header(Session.LANGUAGE, language)
                .header(Session.CONTENT_TYPE, contentType)
                .build()
        } else if (authUserToken.isNullOrBlank().not()) {
            newRequest = requestBuilder.url(httpUrl)
                .header(Session.API_KEY, aes.encrypt(apiKey)!!)
                .header(Session.CURRENT_DATETIME, currentDateTime)
                .header(Session.AUTH_USER_SESSION, authUserToken!!)
                .header(Session.LANGUAGE, language)
                .header(Session.CONTENT_TYPE, contentType)
                .build()
        } else {
            newRequest = requestBuilder.url(httpUrl)
                .header(Session.API_KEY, aes.encrypt(apiKey)!!)
                .header(Session.CURRENT_DATETIME, currentDateTime)
                .header(Session.LANGUAGE, language)
                .header(Session.CONTENT_TYPE, contentType)
                .build()
        }

        // execute the request
        val proceed = chain.proceed(newRequest)
        // get the response body and decrypt it.
        val cipherBody = proceed.body!!.string()
        val plainBody = aes.decrypt(cipherBody)

        // create new Response with plaint text body for further process
        return proceed.newBuilder()
            .body(
                plainBody!!.trim { it <= ' ' }
                    .toResponseBody("text/plain".toMediaType())
            ).build()

        /* ResponseBody.create(
                     "text/json".toMediaTypeOrNull(),
                     plainBody!!.trim { it <= ' ' })*/

    }

    private fun bodyToString(request: RequestBody?): ByteArray? {
        try {
            val buffer = Buffer()
            if (request != null)
                request.writeTo(buffer)
            else
                return null
            return buffer.readByteArray()
        } catch (e: IOException) {
            return null
        }
    }

    private fun transformInputStream(inputStream: ByteArray?): ByteArray? {
        return aes.encrypt(inputStream!!)
    }
}
