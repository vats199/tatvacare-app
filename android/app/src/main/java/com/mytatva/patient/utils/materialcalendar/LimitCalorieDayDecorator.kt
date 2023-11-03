package com.mytatva.patient.utils.materialcalendar

import android.annotation.SuppressLint
import android.content.Context
import com.mytatva.patient.R
import com.prolificinteractive.materialcalendarview.CalendarDay
import com.prolificinteractive.materialcalendarview.DayViewDecorator
import com.prolificinteractive.materialcalendarview.DayViewFacade

class LimitCalorieDayDecorator(
    val context: Context,
    val dates:Collection<CalendarDay>
) : DayViewDecorator {

    override fun shouldDecorate(day: CalendarDay): Boolean {
        return dates.contains(day)
    }

    @SuppressLint("UseCompatLoadingForDrawables")
    override fun decorate(view: DayViewFacade) {
        view.setSelectionDrawable(context.resources.getDrawable(R.drawable.calorie_limit_day_selector,
            null))
        //view.addSpan(ForegroundColorSpan(context.resources.getColor(R.color.white, null)))
    }
}