package com.mytatva.patient.di.module

import com.mytatva.patient.BuildConfig
import com.mytatva.patient.core.AESCryptoInterceptor
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.exception.AuthenticationException
import com.mytatva.patient.exception.ServerError
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import dagger.Module
import dagger.Provides
import okhttp3.*
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.*
import java.util.concurrent.TimeUnit
import javax.inject.Named
import javax.inject.Singleton


@Module(includes = [(ApplicationModule::class)])
class NetModule {

    @Singleton
    @Provides
    @Named("client_app")
    internal fun provideClient(
        @Named("header") headerInterceptor: Interceptor,
        @Named("pre_validation") networkInterceptor: Interceptor,
        @Named("aes") aesInterceptor: Interceptor,
    ): OkHttpClient {
        //val httpLoggingInterceptor = HttpLoggingInterceptor(ApiLogger())
        val httpLoggingInterceptor = HttpLoggingInterceptor()
        httpLoggingInterceptor.level = HttpLoggingInterceptor.Level.BODY

        /*val spec: ConnectionSpec = ConnectionSpec.Builder(ConnectionSpec.MODERN_TLS)
            .tlsVersions(TlsVersion.TLS_1_3)
            .cipherSuites(
                CipherSuite.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
                CipherSuite.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
                CipherSuite.TLS_DHE_RSA_WITH_AES_128_GCM_SHA256)
            .build()*/

        return OkHttpClient.Builder()
            .addInterceptor(headerInterceptor)
            .apply { if (BuildConfig.DEBUG) addInterceptor(httpLoggingInterceptor) }
            //.addInterceptor(httpLoggingInterceptor)
            .addInterceptor(aesInterceptor)
            .apply { if (BuildConfig.DEBUG) addInterceptor(httpLoggingInterceptor) }
            //.addInterceptor(httpLoggingInterceptor)
            .addNetworkInterceptor(networkInterceptor)
            .connectTimeout(2, TimeUnit.MINUTES)
            .writeTimeout(2, TimeUnit.MINUTES)
            .readTimeout(2, TimeUnit.MINUTES)
            //.connectionSpecs(listOf(spec))
            .build()
    }

    @Provides
    @Singleton
    @Named("retrofit_app")
    internal fun provideRetrofit(@Named("client_app") okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl(URLFactory.provideHttpUrl())
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }


    @Provides
    @Singleton
    @Named("header")
    internal fun provideHeaderInterceptor(session: Session): Interceptor {

        return Interceptor { chain ->
            val build =
                if (session.userSession.isNotBlank()) {
                    chain.request().newBuilder()
                        .addHeader(Session.API_KEY, session.apiKey)
                        .addHeader(Session.CURRENT_DATETIME, DateTimeFormatter.currentLocalDate)
                        .addHeader(Session.LANGUAGE, session.language)
                        .addHeader(Session.CONTENT_TYPE, "text/plain")
                        .addHeader(Session.USER_SESSION, session.userSession)
                        .build()
                } else if (session.authUserSession.isNotBlank()) {
                    chain.request().newBuilder()
                        .addHeader(Session.API_KEY, session.apiKey)
                        .addHeader(Session.CURRENT_DATETIME, DateTimeFormatter.currentLocalDate)
                        .addHeader(Session.LANGUAGE, session.language)
                        .addHeader(Session.CONTENT_TYPE, "text/plain")
                        .addHeader(Session.AUTH_USER_SESSION, session.authUserSession)
                        .build()
                } else {
                    chain.request().newBuilder()
                        .addHeader(Session.API_KEY, session.apiKey)
                        .addHeader(Session.CURRENT_DATETIME, DateTimeFormatter.currentLocalDate)
                        .addHeader(Session.LANGUAGE, session.language)
                        .addHeader(Session.CONTENT_TYPE, "text/plain")
                        .build()
                }
            chain.proceed(build)
        }
    }

    @Provides
    @Singleton
    @Named("pre_validation")
    internal fun provideNetworkInterceptor(): Interceptor {
        return Interceptor { chain ->
            val response = chain.proceed(chain.request())
            val code = response.code
            if (code >= 500)
                throw ServerError("$code : Server Issue", response.body!!.string())
            else if (code == 401 || code == 403)
                throw AuthenticationException()
            response
        }
    }

    @Provides
    @Singleton
    @Named("aes")
    internal fun provideAesCryptoInterceptor(aesCryptoInterceptor: AESCryptoInterceptor): Interceptor {
        return aesCryptoInterceptor
    }


    @Singleton
    @Provides
    @Named("client_razorpay")
    internal fun provideClientRazorPay(
        @Named("header_razorpay") headerInterceptor: Interceptor,
        @Named("pre_validation_razorpay") networkInterceptor: Interceptor,
    ): OkHttpClient {
        val httpLoggingInterceptor = HttpLoggingInterceptor()
        httpLoggingInterceptor.level = HttpLoggingInterceptor.Level.BODY
        return OkHttpClient.Builder()
            .addInterceptor(headerInterceptor)
            .addInterceptor(httpLoggingInterceptor)
            .addNetworkInterceptor(networkInterceptor)
            .connectTimeout(1, TimeUnit.MINUTES)
            .writeTimeout(1, TimeUnit.MINUTES)
            .readTimeout(1, TimeUnit.MINUTES)
            .build()
    }

    @Provides
    @Singleton
    @Named("retrofit_razorpay")
    internal fun provideRetrofitRazorPay(@Named("client_razorpay") okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl("https://api.razorpay.com/v1/")
            .client(okHttpClient)
            //.addCallAdapterFactory(RxJava2CallAdapterFactory.create())
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    @Provides
    @Singleton
    @Named("header_razorpay")
    internal fun provideRazorPayHeaderInterceptor(session: Session): Interceptor {
        return Interceptor { chain ->
            val build =
                chain.request().newBuilder()
                    //.addHeader("Authorization", "Basic $base64")
                    .build()
            chain.proceed(build)
        }
    }

    @Provides
    @Singleton
    @Named("pre_validation_razorpay")
    internal fun provideNetworkInterceptorRazorPay(): Interceptor {
        return Interceptor { chain ->
            val response = chain.proceed(chain.request())
            val code = response.code
            if (code >= 500 || code == 400)
                throw ServerError("$code : Server Issue", response.body!!.string())
            else if (code == 401 || code == 403)
                throw AuthenticationException()
            response
        }
    }
}
