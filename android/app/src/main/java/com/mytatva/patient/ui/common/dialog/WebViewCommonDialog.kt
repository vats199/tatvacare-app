package com.mytatva.patient.ui.common.dialog

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.util.DisplayMetrics
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.databinding.CommonDialogWebViewBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment

class WebViewCommonDialog : BaseDialogFragment<CommonDialogWebViewBinding>() {

    private val url: String by lazy {
        arguments?.getString(Common.BundleKey.URL) ?: ""
    }

    private val pageTitle: String by lazy {
        arguments?.getString(Common.BundleKey.TITLE) ?: ""
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CommonDialogWebViewBinding {
        return CommonDialogWebViewBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()

        dialog?.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        dialog?.setCancelable(true)
        dialog?.setCanceledOnTouchOutside(false)
        val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            requireContext().display
        } else {
            wm.defaultDisplay
        }
        val metrics = DisplayMetrics()
        display?.getMetrics(metrics)
        val width = metrics.widthPixels * .9
        val height = metrics.heightPixels * .8
        val win = dialog?.window
        win!!.setLayout(width.toInt(), height.toInt())
    }

    override fun bindData() {
        setViewListener()
        setUpToolbar()
        loadUrl(url)
    }

    private fun setViewListener() {
        binding.apply {
            buttonOkay.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpToolbar() {
        with(binding) {
            textViewTitle.text = pageTitle
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

            if (!url.startsWith("http://") && !url.startsWith("https://"))
                url = "http://$url"

            webView.loadUrl(url)
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonOkay -> {
                dismiss()
            }
        }
    }
}