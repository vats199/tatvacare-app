package com.mytatva.patient.utils

import android.animation.AnimatorSet
import android.animation.ObjectAnimator
import android.annotation.SuppressLint
import android.os.Build
import android.view.MotionEvent
import android.view.View
import androidx.appcompat.app.AppCompatActivity

object DragViewHelper {

    @SuppressLint("ClickableViewAccessibility")
    fun View.cornerAnimationFromCenter(
        activity: AppCompatActivity,
        parent: View,
        animationEnable: Boolean
    ) {
        val actionBarHeight = getNavigationBarHeight(activity)
        val childView = this
        var dX = 0f
        var dY = 0f

        childView.setOnTouchListener { v, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    dX = childView.x - event.rawX
                    dY = childView.y - event.rawY
                }

                MotionEvent.ACTION_MOVE -> {
                    val newX = event.rawX + dX
                    val newY = event.rawY + dY

                    if (newX > 0 && newX + childView.width < parent.width) {
                        childView.x = newX
                    }
                    if (newY > actionBarHeight && newY + childView.height < parent.height) {
                        childView.y = newY
                    }
                }

                MotionEvent.ACTION_UP -> {
                    val screenWidth = parent.width
                    val screenHeight = parent.height

                    val centerX = event.rawX + dX / 2
                    val centerY = event.rawY + dY / 2

                    val isLeft = centerX < screenWidth / 2
                    val isTop = centerY < (screenHeight / 2) - actionBarHeight

                    if (isLeft) {
                        if (isTop) {
                            childView.viewMoveFromToPosition(0f, 0f, animationEnable)
                        } else {
                            childView.viewMoveFromToPosition(
                                0f,
                                (screenHeight - childView.height - actionBarHeight).toFloat(),
                                animationEnable
                            )
                        }
                    } else {
                        if (isTop) {
                            childView.viewMoveFromToPosition(
                                (screenWidth - childView.width).toFloat(),
                                0f,
                                animationEnable
                            )
                        } else {
                            childView.viewMoveFromToPosition(
                                (screenWidth - childView.width).toFloat(),
                                (screenHeight - childView.height - actionBarHeight).toFloat(),
                                animationEnable
                            )
                        }
                    }
                }
            }
            true
        }
    }

    private fun View.viewMoveFromToPosition(
        transactionX: Float,
        transactionY: Float,
        animationEnable: Boolean,
    ) {
        if (animationEnable) {
            val animatorSet = AnimatorSet()
            val currentX = this.x
            val currentY = this.y
            animatorSet.playTogether(
                ObjectAnimator.ofFloat(this, "x", currentX, transactionX),
                ObjectAnimator.ofFloat(this, "y", currentY, transactionY)
            )
            animatorSet.duration = 500
            animatorSet.start()
        } else {
            this.x = transactionX
            this.y = transactionY
        }
    }

    @SuppressLint("InternalInsetResource")
    private fun getNavigationBarHeight(activity: AppCompatActivity): Int {
        return if (hasSoftNavigationBar(activity)) {
            val resourceId =
                activity.resources.getIdentifier("navigation_bar_height", "dimen", "android")
            if (resourceId > 0) {
                activity.resources.getDimensionPixelSize(resourceId)
            } else 0
        } else 0
    }

    private fun hasSoftNavigationBar(activity: AppCompatActivity): Boolean {
        val id: Int =
            activity.resources.getIdentifier("config_showNavigationBar", "bool", "android")
        return Build.FINGERPRINT.startsWith("generic") || id > 0 && activity.resources.getBoolean(id)
    }

}