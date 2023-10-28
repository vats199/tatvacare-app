package com.mytatva.patient.utils

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.os.Handler
import android.os.Looper
import android.view.View
import android.view.animation.BounceInterpolator
import android.view.animation.LinearInterpolator

fun View.animationOne() {
    animate()
        .scaleX(0.5f)
        .scaleY(0.5f)
        .setDuration(100)
        .setInterpolator(BounceInterpolator())
        .setListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                /*super.onAnimationEnd(animation)*/
                this@animationOne.animate()
                    .scaleX(1f)
                    .scaleY(1f)
                    .setDuration(400)
                    .setInterpolator(BounceInterpolator())
                    .setListener(null)
                    .start()
            }
        }).start()
}

fun View.animationTwo() {
    //clipBounds=false
    clipToOutline = false
    animate()
        .rotationBy(180f)
        .translationYBy(-40f)
        .setDuration(400)
        .setInterpolator(LinearInterpolator())
        .setListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                /*super.onAnimationEnd(animation)*/
                this@animationTwo.animate()
                    .rotationBy(180f)
                    .translationYBy(40f)
                    .setDuration(400)
                    .setInterpolator(LinearInterpolator())
                    .setListener(null)
                    .start()

                Handler(Looper.getMainLooper())
                    .postDelayed({
                        this@animationTwo.rotationX = 0f
                        this@animationTwo.rotationY = 0f
                        this@animationTwo.rotation = 0f
                        //this@animationTwo.translationY = 0f
                    }, 400)
            }
        }).start()
}

/*
fun EditText.onTextChanged(): ReceiveChannel<String> =
    Channel<String>(capacity = Channel.UNLIMITED).also { channel ->
        addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                editable?.toString().orEmpty().let(channel::offer)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

        })
    }

fun <T> ReceiveChannel<T>.debounce(time: Long, unit: TimeUnit = TimeUnit.MILLISECONDS): ReceiveChannel<T> =
    Channel<T>(capacity = Channel.CONFLATED).also { channel ->
        GlobalScope.launch {
            var value = receive()
            whileSelect {
                onTimeout(time, unit) {
                    channel.offer(value)
                    value = receive()
                    true
                }
                onReceive {
                    value = it
                    true
                }
            }
        }
    }*/
