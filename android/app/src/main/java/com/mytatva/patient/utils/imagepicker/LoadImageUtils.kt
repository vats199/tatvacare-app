package com.mytatva.patient.utils.imagepicker


import android.app.Activity
import android.content.Context
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.DrawableRes
import androidx.appcompat.widget.AppCompatImageView
import androidx.swiperefreshlayout.widget.CircularProgressDrawable
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.MultiTransformation
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.load.resource.bitmap.CenterCrop
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.RequestOptions
import com.bumptech.glide.request.target.Target
import com.mytatva.patient.R
import java.io.ByteArrayOutputStream
import java.io.File


fun isValidContextForGlide(context: Context?): Boolean {
    if (context == null) {
        return false
    }
    if (context is Activity) {
        val activity = context as Activity?
        if (activity!!.isDestroyed || activity.isFinishing) {
            return false
        }
    }
    return true
}

fun AppCompatImageView.load(url: File, isCenterCrop: Boolean = true) {
    if (isValidContextForGlide(this.context)) {

        if (isCenterCrop) {

            Glide.with(this.context)
                .asDrawable()
                .load(url)
                .placeholder(R.drawable.place_holder)
                .apply(RequestOptions().centerCrop())
                .transition(DrawableTransitionOptions.withCrossFade(200))
                .into(this)

        } else {

            Glide.with(this.context)
                .asDrawable()
                .load(url)
                .placeholder(R.drawable.place_holder)
                .transition(DrawableTransitionOptions.withCrossFade(200))
                .into(this)

        }

    }
}

fun AppCompatImageView.loadDrawable(drawableRes: Int, isCenterCrop: Boolean = true) {
    if (isValidContextForGlide(this.context)) {

        if (isCenterCrop) {
            Glide.with(this.context)
                .asDrawable()
                .load(drawableRes)
                .apply(RequestOptions().centerCrop())
                .transition(DrawableTransitionOptions.withCrossFade(200))
                .into(this)
        } else {
            Glide.with(this.context)
                .asDrawable()
                .load(drawableRes)
                .apply(RequestOptions().centerInside())
                .transition(DrawableTransitionOptions.withCrossFade(200))
                .into(this)
        }

    }
}

fun AppCompatImageView.load(strImage: String, isCenterCrop: Boolean = true) {
    if (isValidContextForGlide(this.context)) {
        if (isCenterCrop) {
            Glide.with(this.context)
                .asDrawable()
                .load(strImage)
                .apply(RequestOptions().centerCrop())
                .transition(DrawableTransitionOptions.withCrossFade(200))
                .into(this)
        } else {
            Glide.with(this.context)
                .asDrawable()
                .load(strImage)
                .transition(DrawableTransitionOptions.withCrossFade(200))
                .into(this)
        }
    }
}

fun AppCompatImageView.loadArticleImage(strImage: String) {
    if (isValidContextForGlide(this.context)) {
        Glide.with(this.context)
            .load(strImage)
            .apply(RequestOptions().centerCrop())
            .transition(DrawableTransitionOptions.withCrossFade(200))
            .into(this)
    }
}


fun AppCompatImageView.loadUrl(
    url: String,
    @DrawableRes placeHolder: Int = R.drawable.place_holder,/*, width: Int, height: Int*/
    isCenterCrop: Boolean = true,
) {
    if (isCenterCrop) {
        Glide.with(this)
            .load(url)
            .centerCrop()
            .placeholder(placeHolder)
            .error(placeHolder)
//            .transition(DrawableTransitionOptions.withCrossFade())
            .into(this)
    } else {
        Glide.with(this)
            .load(url)
            .centerInside()
            .placeholder(placeHolder)
            .error(placeHolder)
//            .transition(DrawableTransitionOptions.withCrossFade())
            .into(this)
    }
}

fun AppCompatImageView.loadWithoutPlaceHolder(
    url: String,
    isCenterCrop: Boolean = true,
) {
    if (isCenterCrop) {
        Glide.with(this)
            .load(url)
            .centerCrop()
            //.transition(DrawableTransitionOptions.withCrossFade())
            .into(this)
    } else {
        Glide.with(this)
            .load(url)
            .centerInside()
            //.transition(DrawableTransitionOptions.withCrossFade())
            .into(this)
    }
}

fun AppCompatImageView.loadUrlWithOverride(
    url: String,
    size: Int,
    @DrawableRes placeHolder: Int = R.drawable.place_holder,/*, width: Int, height: Int*/
    isCenterCrop: Boolean = true,
) {
    if (isCenterCrop) {
        Glide.with(this)
            .load(url)
            .centerCrop()
            .override(size)
            .placeholder(placeHolder)
            .error(placeHolder)
            .transition(DrawableTransitionOptions.withCrossFade())
            .into(this)
    } else {
        Glide.with(this)
            .load(url)
            .override(size)
            .fitCenter()
            .placeholder(placeHolder)
            .error(placeHolder)
            .transition(DrawableTransitionOptions.withCrossFade())
            .into(this)
    }
}

fun AppCompatImageView.loadUrlIcon(url: String, isCenterCrop: Boolean = true) {

    val circularProgressDrawable = CircularProgressDrawable(context)
    circularProgressDrawable.strokeWidth = 2f
    circularProgressDrawable.centerRadius = 10f
    circularProgressDrawable.setColorSchemeColors(
        resources.getColor(R.color.colorPrimary, null)
        /*,resources.getColor(R.color.redLight),resources.getColor(R.color.yellow)*/
    )
    circularProgressDrawable.start()

    if (isCenterCrop) {
        Glide.with(this)
            .asDrawable()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            //.skipMemoryCache(true)
            //.dontAnimate()
            .load(url)
            .centerCrop()
            .placeholder(circularProgressDrawable)
            .error(ColorDrawable(Color.TRANSPARENT))
            //.transition(DrawableTransitionOptions.withCrossFade(80))
            /*.listener(object : RequestListener<Drawable> {
                override fun onLoadFailed(
                    e: GlideException?,
                    model: Any?,
                    target: Target<Drawable>?,
                    isFirstResource: Boolean,
                ): Boolean {
                    //return true if want to handle things
                    return false
                }

                override fun onResourceReady(
                    resource: Drawable?,
                    model: Any?,
                    target: Target<Drawable>?,
                    dataSource: DataSource?,
                    isFirstResource: Boolean,
                ): Boolean {
                    //return true if want to handle things
                    return false
                }
            })*/.into(this)
    } else {
        Glide.with(this)
            .asDrawable()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            //.skipMemoryCache(true)
            .fitCenter()
            //.dontAnimate()
            .load(url)
            .placeholder(circularProgressDrawable)
            .error(ColorDrawable(Color.TRANSPARENT))
            //.transition(DrawableTransitionOptions.withCrossFade(80))
            .into(this)

    }
}

fun AppCompatImageView.loadTopicIcon(url: String, isCenterCrop: Boolean = true) {

    val circularProgressDrawable = CircularProgressDrawable(context)
    circularProgressDrawable.strokeWidth = 2f
    circularProgressDrawable.centerRadius = 10f
    circularProgressDrawable.setColorSchemeColors(
        resources.getColor(R.color.colorPrimary, null)
        /*,resources.getColor(R.color.redLight),resources.getColor(R.color.yellow)*/
    )
    circularProgressDrawable.start()

    if (isCenterCrop) {
        Glide.with(this)
            .asDrawable()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            //.skipMemoryCache(true)
            //.dontAnimate()
            .load(url)
            .centerCrop()
            .apply(RequestOptions().override(80))
            .placeholder(circularProgressDrawable)
            .error(ColorDrawable(Color.TRANSPARENT))
            //.transition(DrawableTransitionOptions.withCrossFade(80))
            .listener(object : RequestListener<Drawable> {
                override fun onLoadFailed(
                    e: GlideException?,
                    model: Any?,
                    target: Target<Drawable>?,
                    isFirstResource: Boolean,
                ): Boolean {
                    //return true if want to handle things
                    return false
                }

                override fun onResourceReady(
                    resource: Drawable?,
                    model: Any?,
                    target: Target<Drawable>?,
                    dataSource: DataSource?,
                    isFirstResource: Boolean,
                ): Boolean {
                    //return true if want to handle things
                    return false
                }
            }).into(this)

    } else {
        Glide.with(this)
            .asDrawable()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            //.skipMemoryCache(true)
            //.dontAnimate()
            .load(url)
            .apply(RequestOptions().override(80))
            .placeholder(circularProgressDrawable)
            .error(ColorDrawable(Color.TRANSPARENT))
            //.transition(DrawableTransitionOptions.withCrossFade(80))
            .into(this)

    }
}

fun AppCompatImageView.loadSmallIcon(url: String, isCenterCrop: Boolean = true) {

    val circularProgressDrawable = CircularProgressDrawable(context)
    circularProgressDrawable.strokeWidth = 2f
    circularProgressDrawable.centerRadius = 10f
    circularProgressDrawable.setColorSchemeColors(
        resources.getColor(R.color.colorPrimary, null)
        /*,resources.getColor(R.color.redLight),resources.getColor(R.color.yellow)*/
    )
    circularProgressDrawable.start()

    if (isCenterCrop) {
        Glide.with(this)
            .asDrawable()
            .diskCacheStrategy(DiskCacheStrategy.AUTOMATIC)
            .skipMemoryCache(true)
            //.dontAnimate()
            .load(url)
            .centerCrop()
            .apply(RequestOptions().override(20))
            .placeholder(circularProgressDrawable)
            .error(ColorDrawable(Color.TRANSPARENT))
            //.transition(DrawableTransitionOptions.withCrossFade(80))
            .listener(object : RequestListener<Drawable> {
                override fun onLoadFailed(
                    e: GlideException?,
                    model: Any?,
                    target: Target<Drawable>?,
                    isFirstResource: Boolean,
                ): Boolean {
                    //return true if want to handle things
                    return false
                }

                override fun onResourceReady(
                    resource: Drawable?,
                    model: Any?,
                    target: Target<Drawable>?,
                    dataSource: DataSource?,
                    isFirstResource: Boolean,
                ): Boolean {
                    //return true if want to handle things
                    return false
                }
            }).into(this)

    } else {
        Glide.with(this)
            .asDrawable()
            .diskCacheStrategy(DiskCacheStrategy.AUTOMATIC)
            .skipMemoryCache(true)
            //.dontAnimate()
            .load(url)
            .apply(RequestOptions().override(20))
            .placeholder(circularProgressDrawable)
            .error(ColorDrawable(Color.TRANSPARENT))
            //.transition(DrawableTransitionOptions.withCrossFade(80))
            .into(this)

    }
}

fun AppCompatImageView.loadRounded(strImageUrl: String, radius: Int, isCenterCrop: Boolean = true) {
    if (isValidContextForGlide(this.context)) {

        if (isCenterCrop) {

            val multiTransformation = MultiTransformation(CenterCrop(), RoundedCorners(radius))

            Glide.with(this.context)
                .load(
                    if (strImageUrl.isEmpty() || strImageUrl == "null")
                        R.drawable.place_holder
                    else
                        strImageUrl
                )
                .error(R.drawable.place_holder)
                .apply(RequestOptions.bitmapTransform(multiTransformation))
                .into(this)

        } else {

            val multiTransformation = MultiTransformation(RoundedCorners(radius))

            Glide.with(this.context)
                .load(
                    if (strImageUrl.isEmpty() || strImageUrl == "null")
                        R.drawable.place_holder
                    else
                        strImageUrl
                )
                .error(R.drawable.place_holder)
                .apply(RequestOptions.bitmapTransform(multiTransformation))
                .into(this)

        }

    }
}

fun AppCompatImageView.loadBitmapRounded(
    strImageUrl: Bitmap,
    radius: Int,
    isCenterCrop: Boolean = true,
) {
    if (isValidContextForGlide(this.context)) {

        if (isCenterCrop) {

            val multiTransformation = MultiTransformation(CenterCrop(), RoundedCorners(radius))
            Glide.with(this.context)
                .load(strImageUrl)
                .apply(RequestOptions.bitmapTransform(multiTransformation))
                .into(this)

        } else {

            val multiTransformation = MultiTransformation(RoundedCorners(radius))

            Glide.with(this.context)
                .load(strImageUrl)
                .apply(RequestOptions.bitmapTransform(multiTransformation))
                .into(this)

        }

    }
}

fun AppCompatImageView.loadDrawableRounded(
    drawableRes: Int,
    radius: Int,
    isCenterCrop: Boolean = true,
) {
    if (isValidContextForGlide(this.context)) {

        if (isCenterCrop) {

            val multiTransformation = MultiTransformation(CenterCrop(), RoundedCorners(radius))

            Glide.with(this.context)
                .load(drawableRes)
                .apply(RequestOptions.bitmapTransform(multiTransformation))
                .into(this)

        } else {

            val multiTransformation = MultiTransformation(RoundedCorners(radius))

            Glide.with(this.context)
                .load(drawableRes)
                .apply(RequestOptions.bitmapTransform(multiTransformation))
                .into(this)

        }

    }
}


fun AppCompatImageView.loadCircleDrawable(
    drawableRes: Int?,
) {
    if (isValidContextForGlide(this.context)) {
        Glide.with(this.context)
            .load(drawableRes)
            .apply(RequestOptions.circleCropTransform())
            .into(this)
    }
}


fun AppCompatImageView.loadCircle(strImageUrl: String) {
    if (isValidContextForGlide(this.context)) {
        Glide.with(this.context)
            .load(
                if (strImageUrl.isEmpty() || strImageUrl == "null")
                    R.drawable.place_holder
                else
                    strImageUrl
            )
            .apply(RequestOptions.circleCropTransform())
            .into(this)
    }
}


fun AppCompatImageView.loadBitmap(bitmap: Bitmap) {

    val byteArrayOutputStream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)

    val multiTransformation = MultiTransformation(
        CenterCrop(),
        RoundedCorners(context.resources.getDimension(R.dimen.dp_8).toInt())
    )

    if (isValidContextForGlide(this.context)) {

        Glide.with(this.context)
            .asBitmap()
            .load(byteArrayOutputStream.toByteArray())
            .apply(RequestOptions.bitmapTransform(multiTransformation))
//                .animate(R.anim.load_image_animation)
            .into(this)

    }

}

fun AppCompatImageView.loadFile(url: File) {

    val multiTransformation = MultiTransformation(
        CenterCrop(),
        RoundedCorners(context.resources.getDimension(R.dimen.dp_8).toInt())
    )

    if (isValidContextForGlide(this.context)) {

        Glide.with(this.context)
            .asDrawable()
            .load(url)
            .apply(RequestOptions.bitmapTransform(multiTransformation))
            .transition(DrawableTransitionOptions.withCrossFade(200))
            .into(this)

    }
}


fun ViewGroup.inflate(layoutRes: Int): View {
    return LayoutInflater.from(context).inflate(layoutRes, this, false)
}

fun dpToPx(dp: Int): Int {
    return (dp * Resources.getSystem().displayMetrics.density).toInt()
}