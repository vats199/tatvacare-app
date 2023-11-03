package com.mytatva.patient.ui.common.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RelativeLayout
import androidx.viewpager.widget.PagerAdapter
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.mytatva.patient.R
import com.mytatva.patient.utils.TouchImageView

class FullScreenImageAdapter(private val _activity: Context, private val _imagePaths: List<String>, private val onOutSideClick: OnOutSideClick?) : PagerAdapter() {

    private lateinit var imageViewPeopleImage: TouchImageView

    override fun getCount(): Int {
        return this._imagePaths.size
    }

    override fun isViewFromObject(view: View, `object`: Any): Boolean {
        return view === `object`
    }

    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        val imgDisplay: TouchImageView

        val inflater = _activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val viewLayout = inflater.inflate(R.layout.common_row_full_screen_imageview, container, false)

        /*if (_activity.resources.getBoolean(R.bool.is_right_to_left)) {
            viewLayout.rotationY = 180F
        }*/

        imageViewPeopleImage = viewLayout.findViewById(R.id.imageViewPeopleImage)

        Glide.with(_activity)
                .asBitmap()
                .load(_imagePaths[position])
                .apply(RequestOptions()
                        .fitCenter()
                        .placeholder(R.drawable.place_holder))
//                .animate(R.anim.load_image_animation)
//                .placeholder(R.drawable.defaultimage)
                .into(imageViewPeopleImage)

        imageViewPeopleImage.setOnClickListener { v ->
            onOutSideClick?.goBack()
        }

        container.addView(viewLayout)

        return viewLayout
    }

    /*override fun destroyItem(container: ViewGroup, position: Int, `object`: Any) {
        container.removeView(`object` as RelativeLayout)
    }*/

    override fun destroyItem(container: ViewGroup, position: Int, `object`: Any) {
        container.removeView(`object` as RelativeLayout)
    }

    interface OnOutSideClick {
        fun goBack()
    }
}