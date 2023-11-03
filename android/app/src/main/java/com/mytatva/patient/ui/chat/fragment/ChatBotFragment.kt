package com.mytatva.patient.ui.chat.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebChromeClient
import android.webkit.WebViewClient
import com.mytatva.patient.R
import com.mytatva.patient.databinding.ChatFragmentChatBotBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class ChatBotFragment : BaseFragment<ChatFragmentChatBotBinding>() {

    val htmlDataString: String by lazy {
        "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<title>Page Title</title>" +
                "<script>(function (d, w, c) { if(!d.getElementById(\"spd-busns-spt\")) { var n = d.getElementsByTagName('script')[0], s = d.createElement('script'); var loaded = false; s.id = \"spd-busns-spt\"; s.async = \"async\"; s.setAttribute(\"data-self-init\", \"false\"); s.setAttribute(\"data-init-type\", \"opt\"); s.src = 'https://cdn.in-freshbots.ai/assets/share/js/freshbots.min.js'; s.setAttribute(\"data-client\", \"6b90669a23306ad7bf5d45c3c42bc8fa646135fb\"); s.setAttribute(\"data-bot-hash\", \"ff945406026d3b7cf7fc8953628101de492b5e93\"); s.setAttribute(\"data-env\", \"prod\"); s.setAttribute(\"data-region\", \"in\"); if (c) { s.onreadystatechange = s.onload = function () { if (!loaded) { c(); } loaded = true; }; } n.parentNode.insertBefore(s, n); } }) (document, window, function () { Freshbots.initiateWidget({ autoInitChat: false, getClientParams: function () { return {\"sn::cstmr::id\":\"" + (session.userId) +
                "\",\"cstmr::eml\":\"" + (session.user?.email ?: "") +
                "\",\"cstmr::phn\":\"" + (session.user?.country_code + session.user?.contact_no) +
                "\",\"cstmr::nm\":\"" + (session.user?.name) +
                "\"}; } }, function(successResponse) {" +
                "Freshbots.showWidget(true);" +
                "}, function(errorResponse) { }); });" +
                "</script>" +
                "</head>" +
                "<body>" +
                "<h1></h1>" +
                "<p></p>" +
                "</body>" +
                "</html>"
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ChatFragmentChatBotBinding {
        return ChatFragmentChatBotBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ChatBot)
    }

    override fun bindData() {
        analytics.logEvent(analytics.USER_CHAT_SUPPORT, screenName = AnalyticsScreenNames.ChatBot)

        setUpToolbar()
        loadData()
    }

    private fun setUpToolbar() {
        binding.apply {
            layoutHeader.apply {
                textViewToolbarTitle.text = ""
                imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    /*@SuppressLint("SetJavaScriptEnabled")
    private fun loadUrl(urlMain: String) {
        with(binding) {
            var url = urlMain

            webView.settings.javaScriptEnabled = true
            webView.webViewClient = WebViewClient()
            webView.webChromeClient = WebChromeClient()

            if (!url.startsWith("http://") && !url.startsWith("https://"))
                url = "http://$url"

            webView.loadUrl(url)
        }
    }*/

    @SuppressLint("SetJavaScriptEnabled")
    private fun loadData() {
        with(binding) {
            webView.settings.javaScriptEnabled = true
            webView.settings.domStorageEnabled = true
            webView.settings.allowContentAccess = true
            webView.settings.databaseEnabled = true
            //webView.settings.allowFileAccess = true
            webView.webViewClient = WebViewClient()
            webView.webChromeClient = WebChromeClient()

            webView.loadDataWithBaseURL("https://cdn.in-freshbots.ai",
                htmlDataString,
                "text/html; charset=utf-8", //; charset=utf-8
                "UTF-8",
                null)

            //Log.i("HtmlData", "loadData: $htmlDataString")
        }
    }
}