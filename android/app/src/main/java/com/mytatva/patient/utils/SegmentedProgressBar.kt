package com.mytatva.patient.utils

import android.content.Context
import android.graphics.BlurMaskFilter
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.graphics.Shader
import android.util.AttributeSet
import android.view.View
import com.mytatva.patient.utils.imagepicker.dpToPx


class SegmentedProgressBar(context: Context?, attributeSet: AttributeSet? = null) :
    View(context, attributeSet) {
    private var cornerRadius = 43f // set corner radius for your segmented progress bar

    private var paint = Paint()
    var strokePaint = Paint()
    private var barContexts: List<BarContext> = listOf()
    private var indicatorPoint: Float = 0f
    private var indicatorPointColor: Int = Color.parseColor("#760FB2")

    private val segment = RectF(
        0f,
        0f,
        0f,
        height.toFloat()
    )

    override fun onDraw(canvas: Canvas) {
        val horizontalSpacing = dpToPx(16)
        val actualBarWidth = width - dpToPx(32)

        var filling = horizontalSpacing.toFloat() //0f
        cornerRadius = dpToPx(8).toFloat()
        val barContextsLastIndex = barContexts.lastIndex
        barContexts.forEachIndexed { i, bar ->

            val shader: Shader = LinearGradient(
                0f, 0f, 5f, height.toFloat(),
                intArrayOf(bar.colorTo, bar.colorFrom), null, Shader.TileMode.CLAMP
            )

            paint.shader = shader

            segment.top = dpToPx(8).toFloat()
            segment.right = actualBarWidth * bar.percentage + filling
            segment.left = filling
            segment.bottom = height.toFloat() - dpToPx(8).toFloat()

            strokePaint.style = Paint.Style.STROKE
            strokePaint.color = Color.BLACK
            strokePaint.strokeWidth = 10f
            var topLeftRadius = 0f
            var bottomLeftRadius = 0f
            var topRightRadius = 0f
            var bottomRightRadius = 0f
            when (i) {
                0 -> {
                    topLeftRadius = cornerRadius
                    bottomLeftRadius = cornerRadius
                }

                barContextsLastIndex -> {
                    topRightRadius = cornerRadius
                    bottomRightRadius = cornerRadius
                }
            }

            canvas.drawPath(
                getPathOfRoundedRectF(
                    segment,
                    topLeftRadius = topLeftRadius,
                    bottomLeftRadius = bottomLeftRadius,
                    topRightRadius = topRightRadius,
                    bottomRightRadius = bottomRightRadius
                ), paint
            )

            strokePaint.shader = LinearGradient(
                0f,
                0f,
                0f,
                height.toFloat(),
                intArrayOf(Color.parseColor("#80FFFFFF"), Color.parseColor("#33000000")),
                null,
                Shader.TileMode.CLAMP
            )
            strokePaint.maskFilter = BlurMaskFilter(18f, BlurMaskFilter.Blur.INNER)
            strokePaint.strokeWidth = 12f
            canvas.drawPath(
                getPathOfRoundedRectF(
                    segment,
                    topLeftRadius = topLeftRadius + topLeftRadius * 0.2f,
                    bottomLeftRadius = bottomLeftRadius + bottomLeftRadius * 0.2f,
                    topRightRadius = topRightRadius + topRightRadius * 0.2f,
                    bottomRightRadius = bottomRightRadius + bottomRightRadius * 0.2f,
                    excludeVertical = true
                ),
                strokePaint
            )

            filling += actualBarWidth * bar.percentage
        }


        val circleCenterY = (height / 2).toFloat()
        val circleCenterX =
            ((actualBarWidth * indicatorPoint) + horizontalSpacing) //(width / 2).toFloat()

        //gray outline
        paint = Paint()
        paint.color = Color.parseColor("#10000000")
        paint.style = Paint.Style.FILL
        canvas.drawCircle(circleCenterX, circleCenterY, dpToPx(16).toFloat(), paint)

        //white border
        paint = Paint()
        paint.color = Color.WHITE
        paint.style = Paint.Style.FILL
        canvas.drawCircle(circleCenterX, circleCenterY, dpToPx(15).toFloat(), paint)

        //ineer circle
        paint = Paint()
        paint.color = indicatorPointColor
        paint.style = Paint.Style.FILL
        canvas.drawCircle(circleCenterX, circleCenterY, dpToPx(12).toFloat(), paint)
    }

    fun setContexts(
        barContexts: List<BarContext>,
        indicatorPoint: Float,
        indicatorPointColor: Int
    ) {
        this.barContexts = barContexts
        this.indicatorPoint = indicatorPoint
        this.indicatorPointColor = indicatorPointColor

        invalidate()
    }

    private fun getPathOfRoundedRectF(
        rect: RectF,
        topLeftRadius: Float = 0f,
        topRightRadius: Float = 0f,
        bottomRightRadius: Float = 0f,
        bottomLeftRadius: Float = 0f,
        excludeVertical: Boolean = false,
    ): Path {
        val tlRadius = topLeftRadius.coerceAtLeast(0f)
        val trRadius = topRightRadius.coerceAtLeast(0f)
        val brRadius = bottomRightRadius.coerceAtLeast(0f)
        val blRadius = bottomLeftRadius.coerceAtLeast(0f)

        with(Path()) {
            moveTo(rect.left + tlRadius, rect.top)


            //setup top border
            lineTo(rect.right - trRadius, rect.top)

            //setup top-right corner
            arcTo(
                RectF(
                    rect.right - trRadius * 2f,
                    rect.top,
                    rect.right,
                    rect.top + trRadius * 2f
                ), -90f, 90f
            )
            if (trRadius != 0f || !excludeVertical) {
                //setup right border
                lineTo(rect.right, rect.bottom - brRadius)

                //setup bottom-right corner
                arcTo(
                    RectF(
                        rect.right - brRadius * 2f,
                        rect.bottom - brRadius * 2f,
                        rect.right,
                        rect.bottom
                    ), 0f, 90f
                )
            } else {
                moveTo(rect.right, rect.bottom - brRadius)
            }

            //setup bottom border
            lineTo(rect.left + blRadius, rect.bottom)

            //setup bottom-left corner
            arcTo(
                RectF(
                    rect.left,
                    rect.bottom - blRadius * 2f,
                    rect.left + blRadius * 2f,
                    rect.bottom
                ), 90f, 90f
            )

            if (tlRadius != 0f || !excludeVertical) {
                //setup left border
                lineTo(rect.left, rect.top + tlRadius)

                //setup top-left corner
                arcTo(
                    RectF(
                        rect.left,
                        rect.top,
                        rect.left + tlRadius * 2f,
                        rect.top + tlRadius * 2f
                    ),
                    180f,
                    90f
                )
            } else {
                moveTo(rect.left, rect.top + tlRadius)
            }

            return this
        }
    }


    class BarContext(val colorFrom: Int, val colorTo: Int, val percentage: Float)
}