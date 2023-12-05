package com.mytatva.patient.utils

import android.content.Context
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.animation.DecelerateInterpolator
import android.widget.Scroller
import androidx.viewpager.widget.ViewPager

class NonSwipeableViewPager(context: Context, attrs: AttributeSet?) : ViewPager(context, attrs) {

    override fun onInterceptTouchEvent(ev: MotionEvent?): Boolean {
        return false
    }

    override fun onTouchEvent(ev: MotionEvent?): Boolean {
        return false
    }

    public class MyScroller(context: Context?) : Scroller(context, DecelerateInterpolator()) {
        override fun startScroll(startX: Int, startY: Int, dx: Int, dy: Int, duration: Int) {
            super.startScroll(startX, startY, dx, dy, 350)
        }
    }

    /*private var currentView: View? = null

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {

        currentView?.let {
            it.measure(widthMeasureSpec, MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED))
            val h = it.measuredHeight
            val height = if (h > 0) h else 0
            val newHeightMeasureSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY)
            super.onMeasure(widthMeasureSpec, newHeightMeasureSpec)
            return
        }

        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
    }

    fun measureCurrentView(myCurrentView: View?) {
        this.currentView = myCurrentView
        requestLayout()
    }*/

}