package com.mytatva.patient.ui.common.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.databinding.CommonFragmentWebViewBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel

class WebViewCommonFragment : BaseFragment<CommonFragmentWebViewBinding>() {

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
    }

    override fun bindData() {
        setUpToolbar()
        loadUrl(url)
    }

    private fun setUpToolbar() {
        with(binding.layoutHeader) {
            imageViewToolbarBack.setImageResource(R.drawable.ic_close_black)
            imageViewToolbarBack.setColorFilter(requireActivity().getColor(R.color.textGray6))
            imageViewToolbarBack.setOnClickListener { navigator.goBack() }
            //textViewToolbarTitle.text = pageTitle
        }
    }

    fun loadUrl(urlMain: String) {
        var url = urlMain
        with(binding) {
            webView.settings.builtInZoomControls = true
            webView.settings.displayZoomControls = false

            webView.settings.useWideViewPort = true
            webView.settings.loadWithOverviewMode = true

            webView.webViewClient = object : WebViewClient() {
                override fun shouldOverrideUrlLoading(
                    view: WebView?,
                    request: WebResourceRequest?,
                ): Boolean {
                    return false
                }
            }
            showLoader()
            webView.webChromeClient = object : WebChromeClient() {
                override fun onProgressChanged(view: WebView?, newProgress: Int) {
                    if (newProgress == 100) {
                        hideLoader()
                    }
                }
            }


            if (!url.startsWith("http://") && !url.startsWith("https://"))
                url = "http://$url"

            webView.loadUrl(url)
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }
}