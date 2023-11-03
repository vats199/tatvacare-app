package com.prolificinteractive.materialcalendarview.spans;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.text.style.LineBackgroundSpan;

import com.prolificinteractive.materialcalendarview.R;

import androidx.core.content.ContextCompat;

/**
 * Span to draw a dot centered under a section of text
 */
public class LineSpan implements LineBackgroundSpan {

    /**
     * Default radius used
     */
    public static final float DEFAULT_RADIUS = 3;

    private final float radius;
    private final int color;

    /**
     * Create a span to draw a dot using default radius and color
     *
     * @see #LineSpan(float, int)
     * @see #DEFAULT_RADIUS
     */
    public LineSpan() {
        this.radius = DEFAULT_RADIUS;
        this.color = 0;
    }

    /**
     * Create a span to draw a dot using a specified color
     *
     * @param color color of the dot
     * @see #LineSpan(float, int)
     * @see #DEFAULT_RADIUS
     */
    public LineSpan(int color) {
        this.radius = DEFAULT_RADIUS;
        this.color = color;
    }

    /**
     * Create a span to draw a dot using a specified radius
     *
     * @param radius radius for the dot
     * @see #LineSpan(float, int)
     */
    public LineSpan(float radius) {
        this.radius = radius;
        this.color = 0;
    }

    /**
     * Create a span to draw a dot using a specified radius and color
     *
     * @param radius radius for the dot
     * @param color  color of the dot
     */
    public LineSpan(float radius, int color) {
        this.radius = radius;
        this.color = color;
    }

    @Override
    public void drawBackground(
            Canvas canvas, Paint paint,
            int left, int right, int top, int baseline, int bottom,
            CharSequence charSequence,
            int start, int end, int lineNum
    ) {
        int oldColor = paint.getColor();
        if (color != 0) {
            paint.setColor(color);
        }
//        canvas.drawCircle((left + right) / 2, bottom + radius, radius, paint);
//        canvas.drawRect(left,top,right,bottom,paint);

        canvas.drawRect(((left + right) / 2) - 10, bottom, ((left + right) / 2) + 10, bottom + 4, paint);
        paint.setColor(oldColor);
    }
}
