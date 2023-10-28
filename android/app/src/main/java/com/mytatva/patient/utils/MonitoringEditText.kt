package com.mytatva.patient.utils

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Context.CLIPBOARD_SERVICE
import android.util.AttributeSet
import androidx.appcompat.widget.AppCompatEditText

/**
 * An EditText, which notifies when something was cut/copied/pasted inside it.
 * @author Lukas Knuth
 * @version 1.0
 */
class MonitoringEditText : AppCompatEditText {
    private val mContext: Context

    private var pasteCallback: (text: String) -> Unit = {}
    fun setPasteCallback(pasteCallback: (text: String) -> Unit) {
        this.pasteCallback = pasteCallback
    }

    /*
        Just the constructors to create a new EditText...
     */
    constructor(context: Context) : super(context) {
        this.mContext = context
    }

    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs) {
        this.mContext = context
    }

    constructor(context: Context, attrs: AttributeSet?, defStyle: Int) : super(context,
        attrs,
        defStyle) {
        this.mContext = context
    }

    /**
     *
     * This is where the "magic" happens.
     *
     * The menu used to cut/copy/paste is a normal ContextMenu, which allows us to
     * overwrite the consuming method and react on the different events.
     * @see [Original Implementation](http://grepcode.com/file/repository.grepcode.com/java/ext/com.google.android/android/2.3_r1/android/widget/TextView.java.TextView.onTextContextMenuItem%28int%29)
     */
    override fun onTextContextMenuItem(id: Int): Boolean {
        // Do your thing:
        val consumed = super.onTextContextMenuItem(id)
        when (id) {
            android.R.id.cut -> onTextCut()
            android.R.id.paste -> onTextPaste()
            android.R.id.copy -> onTextCopy()
        }
        return consumed
    }

    /**
     * Text was cut from this EditText.
     */
    private fun onTextCut() {
        //Toast.makeText(context, "Cut!", Toast.LENGTH_SHORT).show()
    }

    /**
     * Text was copied from this EditText.
     */
    private fun onTextCopy() {
        //Toast.makeText(context, "Copy!", Toast.LENGTH_SHORT).show()
    }

    /**
     * Text was pasted into the EditText.
     */
    private fun onTextPaste() {
        val clipboardManager: ClipboardManager =
            mContext.getSystemService(CLIPBOARD_SERVICE) as ClipboardManager
        val mydata: ClipData? = clipboardManager.primaryClip
        val item: ClipData.Item? = mydata?.getItemAt(0)
        val copiedText: String? = item?.text?.toString()
        copiedText?.let {
            pasteCallback.invoke(it)
        }
        //Toast.makeText(context, "Paste!", Toast.LENGTH_SHORT).show()
    }
}