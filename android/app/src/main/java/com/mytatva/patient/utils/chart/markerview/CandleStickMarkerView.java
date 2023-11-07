package com.mytatva.patient.utils.chart.markerview;

import android.content.Context;
import android.content.res.ColorStateList;

import androidx.appcompat.widget.AppCompatTextView;

import com.github.mikephil.charting.components.MarkerView;
import com.github.mikephil.charting.data.CandleEntry;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.utils.MPPointF;
import com.github.mikephil.charting.utils.Utils;
import com.mytatva.patient.R;


public class CandleStickMarkerView extends MarkerView {

    private AppCompatTextView tvContent;

    public CandleStickMarkerView(Context context, int layoutResource, int color) {
        super(context, layoutResource);
        this.tvContent = /*layoutResource.*/this.findViewById(R.id.textViewGraphPrice);
        tvContent.setBackgroundTintList(ColorStateList.valueOf(color));
        //tvContent.setTextColor(context.getResources().getColor(R.color.light_theme_color));
    }

    // callbacks everytime the MarkerView is redrawn, can be used to update the
    // content (user-interface)
    @Override
    public void refreshContent(Entry e, Highlight highlight) {

        if (e instanceof CandleEntry) {
            CandleEntry ce = (CandleEntry) e;
            tvContent.setText(Utils.formatNumber(ce.getLow(), 0, true) + "-" + Utils.formatNumber(ce.getHigh(), 0, true));
        } else {
            tvContent.setText(Utils.formatNumber(e.getY(), 0, true));
        }

        super.refreshContent(e, highlight);
    }

    @Override
    public MPPointF getOffset() {
        return new MPPointF(-(getWidth() / 2), -getHeight());
    }



}
