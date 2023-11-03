package com.mytatva.patient.utils

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.text.*
import android.text.style.UnderlineSpan
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.TextView
import androidx.annotation.ColorRes
import androidx.appcompat.widget.AppCompatEditText
import androidx.core.content.ContextCompat
import androidx.core.view.updateMargins
import androidx.core.view.updateMarginsRelative
import androidx.fragment.app.Fragment
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.TopicsData
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.threeten.bp.DateTimeUtils
import org.threeten.bp.LocalDate
import org.threeten.bp.ZoneId
import java.math.RoundingMode
import java.text.DecimalFormat
import java.util.*
import kotlin.math.roundToLong
import kotlin.reflect.KProperty1

fun Int?.kFormat(): String {
    if (this == null)
        return ""

    /*var numberString = ""
    numberString = if (kotlin.math.abs(this / 1000000) > 1) {
        (this / 1000000).toString() + "m"
    } else if (kotlin.math.abs(this / 1000) > 1) {
        (this / 1000).toString() + "k"
    } else {
        this.toString()
    }
    return numberString*/

    // new
    /*if (this < 1000) return "" + this
    val exp = (ln(this.toDouble()) / ln(1000.0)).toInt()
    return String.format("%.1f %c", this / 1000.0.pow(exp.toDouble()), "kMGTPE"[exp - 1])*/

    // sync as per iOS code

    //val a = 32154587544
    val thousand = this /*a*/ / 1000
    val million = this /*a*/ / 1000000
    val billion = this /*a*/ / 1000000000

    return when {
        billion >= 1.0 -> {
            ((billion * 10).toDouble().roundToLong() / 10).toDouble().formatToDecimalPoint(1)
                .plus("B")
        }

        million >= 1.0 -> {
            ((million * 10).toDouble().roundToLong() / 10).toDouble().formatToDecimalPoint(1)
                .plus("M")
        }

        thousand >= 1.0 -> {
            ((thousand * 10).toDouble().roundToLong() / 10).toDouble().formatToDecimalPoint(1)
                .plus("K")
        }

        else -> {
            this.toString()
        }
    }

}

fun ArrayList<TopicsData>.copyList(): ArrayList<TopicsData> {
    val list = arrayListOf<TopicsData>()
    forEach { topicsData ->
        list.add(topicsData.doCopy())
    }
    return list
}

fun String?.parseAsColor(): Int {
    return try {
        if (this?.startsWith("#")?.not() == true) {
            this?.trim()
            Color.parseColor("#$this")
            /*ColorUtils.setAlphaComponent(Color.parseColor("#$this"),)*/
        } else {
            this?.trim()
            Color.parseColor(this)
        }
    } catch (e: Exception) {
        Common.Colors.COLOR_PRIMARY
    }
}

fun AppCompatEditText.setMaxLength(length: Int) {
    filters = arrayOf(InputFilter.LengthFilter(length))
}

fun String.doCapitalize(): String {
    return replaceFirstChar {
        if (it.isLowerCase())
            it.titlecase(Locale.ENGLISH)
        else
            it.toString()
    }

    //replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()

    //return this
    //capitalize()
}

fun Context.shareLink(url: String?) {
    val sharingIntent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
    //sharingIntent.type = "text/plain"
    if (sharingIntent.resolveActivity(packageManager) != null)
        startActivity(sharingIntent)
}

fun AppCompatEditText.dontAllowAsPrefix(prefix: String) {
    addTextChangedListener(object : TextWatcher {
        override fun beforeTextChanged(
            s: CharSequence?,
            start: Int,
            count: Int,
            after: Int,
        ) {

        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }

        override fun afterTextChanged(s: Editable) {
            if (s.length == 1 && s[0].toString() == prefix) {
                setText("");
            }
        }
    })
}

fun AppCompatEditText.setPrefix(prefix: String) {
    setText(prefix)
    addTextChangedListener(object : TextWatcher {
        override fun afterTextChanged(p0: Editable?) {
        }

        override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
        }

        override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            /*if (p0.toString().isNotEmpty() && !p0.toString().contains(prefix)) {
                setText(prefix.plus(p0.toString()))
                setSelection(text.toString().length)
            } else if (p0.toString().contains(prefix) && p0.toString().replace(prefix, "").isEmpty()) {
                setText("")
            }*/
            if (!text.toString().startsWith(prefix)) {
                setText(prefix)
                Selection.setSelection(text, text.toString().length)
            }
        }
    })
}

fun LocalDate.convertToDate(): Date {
    return DateTimeUtils.toDate(
        atStartOfDay(
            ZoneId.systemDefault()
        ).toInstant()
    )
}

fun AppCompatEditText.enableFocus() {
    isFocusable = true
    isCursorVisible = true
    isLongClickable = true
}

fun AppCompatEditText.disableFocus() {
    isFocusable = false
    isCursorVisible = false
    isLongClickable = false
}

fun TextInputLayout.triggerError(msg:String){
    isErrorEnabled = true
    val tv = findViewById<TextView>(com.google.android.material.R.id.textinput_error)
    val lp: FrameLayout.LayoutParams? = tv?.layoutParams as FrameLayout.LayoutParams?
    //lp?.updateMargins(0,0,0,0)
    lp?.updateMarginsRelative(6,0,0,0)
    clipToPadding = false
    error = msg
}

fun TextInputLayout.disableErrorAnimation() {
    try {
        // Find the errorView member and make it accessible to change its properties
        val field = TextInputLayout::class.java.getDeclaredField("indicatorViewController").apply {
            isAccessible = true
        }
        val value = field.get(this)
        val errorViewField = value::class.java.getDeclaredField("errorView").apply {
            isAccessible = true
        }
        val errorView = errorViewField.get(value) as? TextView

        // Find the setAnimation method of the errorView (it's an AppCompatTextView) and nullify it
        errorView?.let {
            it.setAnimation(null)
        }
    } catch (e: Exception) {
        // Log the exception if needed
        e.printStackTrace()
    }
}

fun View.enableShadow() {
    setBackgroundColor(Color.WHITE)
    elevation = context.resources.getDimension(R.dimen.dp_4)
}

fun AppCompatEditText.disableEmoji() {
    val emojiFilter = InputFilter { source, start, end, dest, dstart, dend ->
        for (index in start until end) {
            val type = Character.getType(source[index])

            when (type) {
                '*'.code,
                Character.OTHER_SYMBOL.toInt(),
                Character.SURROGATE.toInt() -> {
                    return@InputFilter ""
                }

                Character.LOWERCASE_LETTER.toInt() -> {
                    val index2 = index + 1
                    if (index2 < end && Character.getType(source[index + 1]) == Character.NON_SPACING_MARK.toInt())
                        return@InputFilter ""
                }

                Character.DECIMAL_DIGIT_NUMBER.toInt() -> {
                    val index2 = index + 1
                    val index3 = index + 2
                    if (index2 < end && index3 < end &&
                        Character.getType(source[index2]) == Character.NON_SPACING_MARK.toInt() &&
                        Character.getType(source[index3]) == Character.ENCLOSING_MARK.toInt()
                    )
                        return@InputFilter ""
                }

                Character.OTHER_PUNCTUATION.toInt() -> {
                    val index2 = index + 1

                    if (index2 < end && Character.getType(source[index2]) == Character.NON_SPACING_MARK.toInt()) {
                        return@InputFilter ""
                    }
                }

                Character.MATH_SYMBOL.toInt() -> {
                    val index2 = index + 1
                    if (index2 < end && Character.getType(source[index2]) == Character.NON_SPACING_MARK.toInt())
                        return@InputFilter ""
                }
            }
        }
        return@InputFilter null
    }
    filters = arrayOf(emojiFilter)
}


fun Fragment.toColor(@ColorRes color: Int): Int {
    return ContextCompat.getColor(this.requireContext(), color)
}

fun Fragment.toColorDrawable(@ColorRes color: Int): ColorDrawable {
    return ColorDrawable(toColor(color))
}

fun Fragment?.setAdjustPan() {
    this?.activity?.window?.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN or WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN)
}

fun Fragment?.setAdjustResize() {
    this?.activity?.window?.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE or WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN)
}

fun Fragment?.setAdjustNothing() {
    this?.activity?.window?.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING or WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN)
}

fun Fragment?.setUnspecified() {
    this?.activity?.window?.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_UNSPECIFIED)
}

fun Double?.formatToDecimalPoint(decimalPoint: Int): String {
    return when (decimalPoint) {
        1 -> String.format("%.1f", this)
        2 -> String.format("%.2f", this)
        3 -> String.format("%.3f", this)
        4 -> String.format("%.4f", this)
        else -> this.toString()
    }
}

fun Double?.formatToDecimalPointSkipRounding(decimalPoint: Int): String {
    val df = when (decimalPoint) {
        1 -> DecimalFormat("0.0")
        2 -> DecimalFormat("0.00")
        3 -> DecimalFormat("0.000")
        4 -> DecimalFormat("0.0000")
        else -> DecimalFormat("0.00000")
    }
    df.roundingMode = RoundingMode.DOWN
    return df.format(this)
}

/*fun Long?.formatToDecimalPoint(decimalPoint: Int): String {
    return when (decimalPoint) {
        1 -> String.format("%.1f", this)
        2 -> String.format("%.2f", this)
        3 -> String.format("%.3f", this)
        4 -> String.format("%.4f", this)
        else -> this.toString()
    }
}*/

inline fun <reified T, Y> MutableList<T>.listOfField(property: KProperty1<T, Y?>): ArrayList<Y> {
    val yy = ArrayList<Y>()
    this.forEach { t: T ->
        yy.add(property.get(t) as Y)
    }
    return yy
}

inline fun <reified T, Y> MutableList<T>.appendFieldAsString(
    property: KProperty1<T, Y?>,
    separator: String = ",",
): String {
    val sb = StringBuilder()
    this.forEach { t: T ->
        sb.append(property.get(t) as Y).append(separator)
    }
    return sb.toString().trim().removeSuffix(separator)
}

fun String.doUnderline(): SpannableStringBuilder {
    val nameString = SpannableStringBuilder(this)
    nameString.setSpan(UnderlineSpan(), 0, this.length, Spanned.SPAN_EXCLUSIVE_INCLUSIVE)
    return nameString
}

/**
 *
 */
fun Context.openBrowser(url: String) {
    try {
        var urlString = url
        if (!url.startsWith("http://") && !url.startsWith("https://"))
            urlString = "http://$url"

        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(urlString))
        this.startActivity(browserIntent)
    } catch (e: ActivityNotFoundException) {
        e.printStackTrace()
    }
}

fun Context.openBrowserTest() {
    try {
        var urlString = "mytatva://mytatva.page.link?operation=signup_link_doctor&access_code=GDBDEGC"
        /*if (!url.startsWith("http://") && !url.startsWith("https://"))
            urlString = "http://$url"*/

        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(urlString))
        this.startActivity(browserIntent)
    } catch (e: ActivityNotFoundException) {
        e.printStackTrace()
    }
}

fun Context.openAppInStore() {
    val uri: Uri = Uri.parse("market://details?id=${BuildConfig.APPLICATION_ID}")
    val goToMarket = Intent(Intent.ACTION_VIEW, uri)
    // To count with Play market backstack, After pressing back button,
    // to taken back to our application, we need to add following flags to intent.
    /*goToMarket.addFlags(
        Intent.FLAG_ACTIVITY_NO_HISTORY or
                Intent.FLAG_ACTIVITY_NEW_DOCUMENT or
                Intent.FLAG_ACTIVITY_MULTIPLE_TASK
    )*/
    try {
        startActivity(goToMarket)
    } catch (e: ActivityNotFoundException) {
        startActivity(
            Intent(
                Intent.ACTION_VIEW,
                Uri.parse("http://play.google.com/store/apps/details?id=${BuildConfig.APPLICATION_ID}")
            )
        )
    }
}

/**
 *
 */
fun Context.shareApp() {
    //val message = "https://play.google.com/store/apps/details?id=" + BuildConfig.APPLICATION_ID
    val message = "https://mytatva.page.link/Tqvv"
    val intent = Intent(Intent.ACTION_SEND).apply {
        type = "text/plain"
        putExtra(Intent.EXTRA_SUBJECT, getString(R.string.app_name))
        putExtra(Intent.EXTRA_TEXT, message)
    }
    this.startActivity(Intent.createChooser(intent, "Choose One"))
}

fun Context.shareText(message: String) {
    val intent = Intent(Intent.ACTION_SEND).apply {
        type = "text/plain"
        putExtra(Intent.EXTRA_TEXT, message)
    }

    this.startActivity(Intent.createChooser(intent, "Choose One"))
}

fun Context.openWhatsApp() {
    val packageManager: PackageManager = packageManager
    val i = Intent(Intent.ACTION_VIEW)

    try {
        val url =
            "https://api.whatsapp.com/send?phone=" + "1234567890"
        i.setPackage("com.whatsapp")
        i.data = Uri.parse(url)
        if (i.resolveActivity(packageManager) != null) {
            startActivity(i)
        }
    } catch (e: java.lang.Exception) {
        e.printStackTrace()
    }
}

fun Context.openEmail(email: String) {
    try {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("mailto:$email"))
        intent.putExtra(Intent.EXTRA_SUBJECT, "")
        intent.putExtra(Intent.EXTRA_TEXT, "")
        this.startActivity(intent)
    } catch (e: ActivityNotFoundException) {
        e.printStackTrace()
    }
}

fun Context.openDialer(phoneNo: String) {
    try {
        val intent = Intent(Intent.ACTION_DIAL)
        intent.data = Uri.parse("tel:$phoneNo")
        startActivity(intent)
    } catch (e: ActivityNotFoundException) {
        e.printStackTrace()
    }
}

/**
 * Sets status bar color on API level 21 and above.
 */
fun Activity.setStatusBarColor(@ColorRes color: Int, isStatusBarLight: Boolean = false) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        val window = this.window
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
        window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)

        if (isStatusBarLight && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
        } else {
            window.decorView.systemUiVisibility = 0
        }

        window.statusBarColor = ContextCompat.getColor(this, color)
    }
}

/**
 *
 */
@Suppress("DEPRECATION")
fun Context.getDefaultLocale(): String {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        this.resources.configuration.locales.get(0).country
    } else {
        this.resources.configuration.locale.country
    }
}

fun Activity.googleFitInstalled(): Boolean {
    val url: String = "com.google.android.apps.fitness"
    val packageManager: PackageManager = applicationContext.packageManager
    val app_installed: Boolean
    app_installed = try {
        packageManager.getPackageInfo(url, PackageManager.GET_ACTIVITIES)
        true
    } catch (e: PackageManager.NameNotFoundException) {
        false
    }
    return app_installed
}

fun Context.openGoogleFitInStore() {
    val uri: Uri = Uri.parse("market://details?id=com.google.android.apps.fitness")
    val goToMarket = Intent(Intent.ACTION_VIEW, uri)
    // To count with Play market backstack, After pressing back button,
    // to taken back to our application, we need to add following flags to intent.
    /*goToMarket.addFlags(
        Intent.FLAG_ACTIVITY_NO_HISTORY or
                Intent.FLAG_ACTIVITY_NEW_DOCUMENT or
                Intent.FLAG_ACTIVITY_MULTIPLE_TASK
    )*/
    try {
        startActivity(goToMarket)
    } catch (e: ActivityNotFoundException) {
        startActivity(
            Intent(
                Intent.ACTION_VIEW,
                Uri.parse("http://play.google.com/store/apps/details?id=com.google.android.apps.fitness")
            )
        )
    }
}

/**
 * encode/decode using Base64
 */
fun String.encodeBase64(): String {
    return android.util.Base64.encodeToString(this.toByteArray(), android.util.Base64.DEFAULT)
}

fun String.decodeBase64(): String {
    return android.util.Base64.decode(this.toByteArray(), android.util.Base64.DEFAULT)
        .toString(Charsets.UTF_8)
}

/*fun Activity.openAlexa() {
    val isAppInstalled = appInstalledOrNot("com.amazon.dee.app")
    if (isAppInstalled) {
        val launchIntent: Intent? = packageManager
            .getLaunchIntentForPackage("com.amazon.dee.app")
        launchIntent?.let {
            startActivity(launchIntent)
        }
    } else {
        Toast.makeText(
            this,
            getString(R.string.msg_app_not_installed),
            Toast.LENGTH_SHORT
        ).show()
    }
}*/


fun <T> debounce(
    waitMs: Long = 4000L,
    scope: CoroutineScope,
    destinationFunction: (T) -> Unit,
): (T) -> Unit {
    var debounceJob: Job? = null
    return { param: T ->
        debounceJob?.cancel()
        debounceJob = scope.launch {
            delay(waitMs)
            destinationFunction(param)
        }
    }
}

fun debounce(
    waitMs: Long = 4000L,
    scope: CoroutineScope,
    destinationFunction: () -> Unit,
) {
    var debounceJob: Job? = null
    debounceJob?.cancel()
    debounceJob = scope.launch {
        delay(waitMs)
        destinationFunction()
    }
}

fun Context.openAppSystemSettings() {
    startActivity(Intent().apply {
        action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
        data = Uri.fromParts("package", packageName, null)
    })
}

fun Date.formatToDateTime(format: String = DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss): String {
    return DateTimeFormatter.date(this).formatDateToLocalTimeZone(format)
}