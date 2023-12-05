package com.mytatva.patient.utils.materialcalendar

import android.annotation.SuppressLint
import android.content.Context
import android.text.style.ForegroundColorSpan
import com.mytatva.patient.R
import com.prolificinteractive.materialcalendarview.CalendarDay
import com.prolificinteractive.materialcalendarview.DayViewDecorator
import com.prolificinteractive.materialcalendarview.DayViewFacade
import java.util.*

class CurrentDayDecorator(
    context: Context,
    val isBlueTheme: Boolean = false,/*, Collection<CalendarDay> dates*/
) : DayViewDecorator {
    private val dates: HashSet<CalendarDay> = HashSet()
    private val context: Context

    init {
        dates.add(CalendarDay.today())
        this.context = context
    }

    override fun shouldDecorate(day: CalendarDay): Boolean {
        return dates.contains(day)
    }

    @SuppressLint("UseCompatLoadingForDrawables")
    override fun decorate(view: DayViewFacade) {
        view.setSelectionDrawable(
            context.resources.getDrawable(
                R.drawable.current_day_selector,
                null
            )
        )
        view.addSpan(ForegroundColorSpan(context.resources.getColor(R.color.white, null)))
    }
}