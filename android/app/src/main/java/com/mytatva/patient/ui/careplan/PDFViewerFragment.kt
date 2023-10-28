package com.mytatva.patient.ui.careplan

import android.annotation.SuppressLint
import android.app.DownloadManager
import android.content.Context
import android.net.Uri
import android.os.Environment
import android.view.LayoutInflater
import android.view.ViewGroup
import com.mytatva.patient.core.Common
import com.mytatva.patient.databinding.LayoutShowPdfBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

class PDFViewerFragment : BaseFragment<LayoutShowPdfBinding>() {

    private val uri :String by lazy {
        arguments?.getString(Common.BundleKey.URL) ?: ""
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LayoutShowPdfBinding {
        return LayoutShowPdfBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        /*binding.pdfView.fromUri(Uri.parse("https://www.africau.edu/images/default/sample.pdf"))
            .defaultPage(0)
            .enableSwipe(true)
            .swipeHorizontal(false)
            .onPageChange { page, pageCount ->
                // Handle page change events
                Log.e(PDFViewerFragment::class.java.simpleName,"PageChange")
            }
            .onError{
                Log.e(PDFViewerFragment::class.java.simpleName,"${it.message}")
            }
            .scrollHandle(DefaultScrollHandle(requireContext()))
            .onPageError { page, t ->
                Log.e(PDFViewerFragment::class.java.simpleName,"${t.message}")
            }
            .load()*/
        downloadPdf(uri)
    }

    private fun downloadPdf(url: String) {
        val request = DownloadManager.Request(Uri.parse(url))
            .setTitle("Sample PDF")
            .setDescription("Downloading")
            .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            .setDestinationInExternalFilesDir(requireContext(), Environment.DIRECTORY_DOWNLOADS, "sample.pdf")

        val downloadManager = requireContext().getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
        val downloadId = downloadManager.enqueue(request)

        // Wait for the download to complete and display the PDF file in the PDFView
        /*GlobalScope.launch(Dispatchers.IO) {
            val pdfFile = waitForDownloadCompletion(downloadManager, downloadId)
            withContext(Dispatchers.Main) {
                binding.pdfView.fromFile(pdfFile).load()
            }
        }*/
    }

    @SuppressLint("Range")
    private fun waitForDownloadCompletion(downloadManager: DownloadManager, downloadId: Long): File {
        var downloading = true
        while (downloading) {
            val query = DownloadManager.Query().apply { setFilterById(downloadId) }
            val cursor = downloadManager.query(query)
            if (cursor.moveToFirst()) {
                val status = cursor.getInt(cursor.getColumnIndex(DownloadManager.COLUMN_STATUS))
                if (status == DownloadManager.STATUS_SUCCESSFUL) {
                    downloading = false
                    val uri = cursor.getString(cursor.getColumnIndex(DownloadManager.COLUMN_LOCAL_URI))
                    return File(Uri.parse(uri).path!!)
                }
            }
            cursor.close()
            Thread.sleep(500)
        }
        throw RuntimeException("Download failed")
    }
}