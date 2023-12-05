package com.mytatva.patient.ui.base

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer
import com.mytatva.patient.data.pojo.DataWrapper
import com.mytatva.patient.data.pojo.ResponseBody
import com.mytatva.patient.exception.AuthenticationException


class APILiveData<T> : MutableLiveData<DataWrapper<T>>() {

    /**
     *  @param owner : Life Cycle Owner
     *  @param onChange : live data
     *  @param onError : Server and App error -> return true to handle error by base else return false to handle error by your self
     *
     */
    /*fun observe(owner: BaseDialog, onChange: (ResponseBody<T>) -> Unit, onError: (Throwable) -> Boolean = { true }) {
        super.observe(owner, Observer<DataWrapper<T>> {
            if (it?.throwable != null) {
                if (onError(it.throwable)) owner.onError(it.throwable)
            } else if (it?.responseBody != null) {
                onChange(it.responseBody)
            }
        })
    }*/

    /**
     *  @param owner : Life Cycle Owner
     *  @param onChange : live data
     *  @param onError : Server and App error -> return true to handle error by base else return false to handle error by your self
     *
     */
    fun observe(
        owner: BaseFragment<*>,
        onChange: (ResponseBody<T>) -> Unit,
        onError: (Throwable) -> Boolean = { true },
    ) {
        super.observe(owner, Observer<DataWrapper<T>> {
            if (it?.throwable != null) {
                Log.d(
                    "TIMEOUT",
                    ":: observe :: ${owner::class.java.simpleName} :: ${it.throwable.message}"
                )
                if (it.throwable is AuthenticationException) {
                    owner.onError(it.throwable)
                } else {
                    if (onError(it.throwable)) owner.onError(it.throwable)
                }
            } else if (it?.responseBody != null) {

                /*if (BuildConfig.DEBUG) {
                    val gson = GsonBuilder().setPrettyPrinting().create()
                    val result: String = gson.toJson(it.responseBody)
                    Log.d("API", "Response: $result")
                }*/

                onChange(it.responseBody)
            }
        })
    }

    /**
     *  @param owner : Life Cycle Owner
     *  @param onChange : live data
     *  @param onError : Server and App error -> return true to handle error by base else return false to handle error by your self
     *
     */
    fun observe(
        owner: BaseBottomSheetDialogFragment<*>,
        onChange: (ResponseBody<T>) -> Unit,
        onError: (Throwable) -> Boolean = { true },
    ) {
        super.observe(owner, Observer<DataWrapper<T>> {
            if (it?.throwable != null) {
                if (onError(it.throwable)) owner.onError(it.throwable)
            } else if (it?.responseBody != null) {
                onChange(it.responseBody)
            }
        })
    }

    /**
     *  @param owner : Life Cycle Owner
     *  @param onChange : live data
     *  @param onError : Server and App error -> return true to handle error by base else return false to handle error by your self
     *
     */
    fun observe(
        owner: BaseDialogFragment<*>,
        onChange: (ResponseBody<T>) -> Unit,
        onError: (Throwable) -> Boolean = { true },
    ) {
        super.observe(owner, Observer<DataWrapper<T>> {
            if (it?.throwable != null) {
                if (onError(it.throwable)) owner.onError(it.throwable)
            } else if (it?.responseBody != null) {
                onChange(it.responseBody)
            }
        })
    }

    /**
     *  @param owner : Life Cycle Owner
     *  @param onChange : live data
     *  @param onError : Server and App error -> return true to handle error by base else return false to handle error by your self
     *
     */
    fun observe(
        owner: BaseActivity,
        onChange: (ResponseBody<T>) -> Unit,
        onError: (Throwable) -> Boolean = { true },
    ) {
        super.observe(owner, Observer<DataWrapper<T>> {
            if (it?.throwable != null) {
                if (onError(it.throwable)) owner.onError(it.throwable)
            } else if (it?.responseBody != null) {
                onChange(it.responseBody)
            }
        })
    }
}

/*
fun APILiveData<*>.isSuccess() = this.value?.responseBody?.responseCode == StatusCode.CODE_SUCCESS

fun APILiveData<*>.isNoData() = this.value?.responseBody?.responseCode == StatusCode.CODE_NO_DATA*/
