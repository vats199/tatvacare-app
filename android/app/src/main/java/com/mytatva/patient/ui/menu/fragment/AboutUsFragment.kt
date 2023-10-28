package com.mytatva.patient.ui.menu.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import com.google.android.material.tabs.TabLayout
import com.mytatva.patient.R
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.databinding.FragmentAboutUsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment

class AboutUsFragment : BaseFragment<FragmentAboutUsBinding>(), TabLayout.OnTabSelectedListener {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(inflater: LayoutInflater, container: ViewGroup?, attachToRoot: Boolean): FragmentAboutUsBinding {
        return FragmentAboutUsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        setUpToolbar()
        binding.tabLayout.addOnTabSelectedListener(this)
        binding.tabLayout.getTabAt(0)!!.select()
        loadUrl(URLFactory.AppUrls.ABOUT_US)
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { navigator.goBack() }
            imageViewFilter.visibility = View.GONE
            imageViewSearch.visibility = View.GONE
            imageViewNotification.visibility = View.GONE
            textViewToolbarTitle.visibility = View.GONE
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

    override fun onTabSelected(tab: TabLayout.Tab?) {
        when (binding.tabLayout.selectedTabPosition) {
            0 -> {
                loadUrl(URLFactory.AppUrls.ABOUT_US)
            }

            1 -> {
                loadUrl(URLFactory.AppUrls.TERMS_CONDITIONS)
            }

            2 -> {
                loadUrl(URLFactory.AppUrls.PRIVACY_POLICY)
            }
        }
    }

    override fun onTabUnselected(tab: TabLayout.Tab?) {
    }

    override fun onTabReselected(tab: TabLayout.Tab?) {
    }


}