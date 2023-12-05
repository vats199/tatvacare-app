package com.mytatva.patient.utils.chart.renderer;

import android.graphics.Canvas;

import com.github.mikephil.charting.animation.ChartAnimator;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.ScatterData;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.interfaces.dataprovider.ScatterDataProvider;
import com.github.mikephil.charting.interfaces.datasets.IScatterDataSet;
import com.github.mikephil.charting.renderer.ScatterChartRenderer;
import com.github.mikephil.charting.utils.MPPointD;
import com.github.mikephil.charting.utils.ViewPortHandler;

import java.util.List;

public class MyScatterChartRenderer extends ScatterChartRenderer {

    public MyScatterChartRenderer(ScatterDataProvider chart, ChartAnimator animator, ViewPortHandler viewPortHandler) {
        super(chart, animator, viewPortHandler);
    }

    @Override
    public void drawHighlighted(Canvas c, Highlight[] indices) {

        ScatterData scatterData = mChart.getScatterData();

        for (Highlight high : indices) {

            IScatterDataSet set = scatterData.getDataSetByIndex(high.getDataSetIndex());

            if (set == null || !set.isHighlightEnabled())
                continue;

            List<Entry> list = set.getEntriesForXValue(high.getX());

            // this method(getEntryForXValue) returns wrong entry for more then 2nd Y item for same X values.
            // Hence added for loop below to get proper entry matching with high Y value
            Entry entry = set.getEntryForXValue(high.getX(), high.getY());

            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getY() == high.getY()) {
                    entry = list.get(i);
                }
            }

            if (!isInBoundsX(entry, set))
                continue;

            MPPointD pix = mChart.getTransformer(set.getAxisDependency())
                    .getPixelForValues(entry.getX(), entry.getY() * mAnimator.getPhaseY());

            high.setDraw((float) pix.x, (float) pix.y);

            // draw the lines
            //drawHighlightLines(c, (float) pix.x, (float) pix.y, set);
        }

    }


    /*@Override
    public void drawHighlighted(Canvas c, Highlight[] indices) {

        ScatterData scatterData = mChart.getScatterData();

        for (Highlight high : indices) {

            IScatterDataSet set = scatterData.getDataSetByIndex(high.getDataSetIndex());

            if (set == null || !set.isHighlightEnabled())
                continue;

            final Entry e = new Entry(high.getX(), high.getY()); //set.getEntryForXValue(high.getX(), high.getY());

            if (!isInBoundsX(e, set))
                continue;

            MPPointD pix = mChart.getTransformer(set.getAxisDependency()).getPixelForValues(e.getX(), e.getY() * mAnimator
                    .getPhaseY());

            high.setDraw((float) pix.x, (float) pix.y);

            // draw the lines
            drawHighlightLines(c, (float) pix.x, (float) pix.y, set);
        }

    }*/


}
