package com.mytatva.patient.ui.common.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AppointmentData
import com.mytatva.patient.databinding.CommonFragmentWebViewBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel

class WebViewPaymentFragment : BaseFragment<CommonFragmentWebViewBinding>() {

    val url: String by lazy {
        arguments?.getString(Common.BundleKey.URL) ?: ""
    }

    val pageTitle: String by lazy {
        arguments?.getString(Common.BundleKey.TITLE) ?: ""
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CommonFragmentWebViewBinding {
        return CommonFragmentWebViewBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpToolbar()
        loadUrl(url)
    }

    private fun setUpToolbar() {
        with(binding.layoutHeader) {
            imageViewToolbarBack.setOnClickListener { navigator.goBack() }
            textViewToolbarTitle.text = pageTitle
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    fun loadUrl(urlMain: String) {
        var url = urlMain
        with(binding) {
            webView.settings.javaScriptEnabled = true
            webView.settings.domStorageEnabled = true
            webView.webViewClient = object : WebViewClient() {
                override fun shouldOverrideUrlLoading(
                    view: WebView?,
                    request: WebResourceRequest?,
                ): Boolean {
                    Log.e("WebView", "shouldOverrideUrlLoading: ${request?.url}")
                    if (request?.url?.toString()?.contains("appointmentpay-success.php") == true) {
                        fetchVideoCallData()
                    }
                    return false
                }
            }

            /*webView.webChromeClient = object : WebChromeClient() {
                override fun onJsAlert(
                    view: WebView?,
                    url: String?,
                    message: String?,
                    result: JsResult?,
                ): Boolean {
                    Log.e("WebView", "onJsAlert: ${message} :: ${result}")

                    navigator.showAlertDialog(message ?: "",
                        dialogOkListener = object : BaseActivity.DialogOkListener {
                            override fun onClick() {
                                fetchVideoCallData()
                            }
                        })

                    return true
                    //return super.onJsAlert(view, url, message, result)
                }

                override fun onJsConfirm(
                    view: WebView?,
                    url: String?,
                    message: String?,
                    result: JsResult?,
                ): Boolean {
                    Log.e("WebView", "onJsConfirm: ${message} :: ${result}")
                    return super.onJsConfirm(view, url, message, result)
                }

                override fun onJsPrompt(
                    view: WebView?,
                    url: String?,
                    message: String?,
                    defaultValue: String?,
                    result: JsPromptResult?,
                ): Boolean {
                    Log.e("WebView", "onJsPrompt: ${message} :: ${result}")
                    return super.onJsPrompt(view, url, message, defaultValue, result)
                }

                override fun onJsBeforeUnload(
                    view: WebView?,
                    url: String?,
                    message: String?,
                    result: JsResult?,
                ): Boolean {
                    Log.e("WebView", "onJsBeforeUnload: ${message} :: ${result}")
                    return super.onJsBeforeUnload(view, url, message, result)
                }
            }*/

            if (!url.startsWith("http://") && !url.startsWith("https://"))
                url = "http://$url"

            webView.loadUrl(url)
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun fetchVideoCallData() {
        val apiRequest = ApiRequest()
        showLoader()
        doctorViewModel.fetchVideoCallData(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //fetchVideocallDataLiveData
        doctorViewModel.fetchVideocallDataLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setResult(it)
                }
                //navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun setResult(appointmentData: AppointmentData) {
        val intent = Intent()
        intent.putExtra(Common.BundleKey.APPOINTMENT_DATA, appointmentData)
        requireActivity().setResult(Activity.RESULT_OK, intent)
        requireActivity().finish()
    }
}