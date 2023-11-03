package devs.mulham.horizontalcalendar.adapter;

import android.text.format.DateFormat;
import android.util.TypedValue;
import android.view.View;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import devs.mulham.horizontalcalendar.HorizontalCalendar;
import devs.mulham.horizontalcalendar.HorizontalCalendarView;
import devs.mulham.horizontalcalendar.R;
import devs.mulham.horizontalcalendar.model.HorizontalCalendarConfig;
import devs.mulham.horizontalcalendar.utils.CalendarEventsPredicate;
import devs.mulham.horizontalcalendar.utils.HorizontalCalendarPredicate;
import devs.mulham.horizontalcalendar.utils.Utils;

/**
 * custom adapter for {@link HorizontalCalendarView HorizontalCalendarView}
 *
 * @author Mulham-Raee
 * @since v1.0.0
 * <p>
 * See {devs.mulham.horizontalcalendar.R.layout#hc_item_calendar} Calendar CustomItem Layout
 */
public class DaysAdapter extends HorizontalCalendarBaseAdapter<DateViewHolder, Calendar> {

    /*int todayPosition = -2;
    int tomorrowPosition = -3;*/

    public ArrayList<String> dataLists = new ArrayList<String>();

    public DaysAdapter(HorizontalCalendar horizontalCalendar, Calendar startDate, Calendar endDate, HorizontalCalendarPredicate disablePredicate, CalendarEventsPredicate eventsPredicate) {
        super(R.layout.hc_item_calendar, horizontalCalendar, startDate, endDate, disablePredicate, eventsPredicate);
    }

    @Override
    protected DateViewHolder createViewHolder(View itemView, int cellWidth) {
        final DateViewHolder holder = new DateViewHolder(itemView);
        holder.layoutContent.setMinimumWidth(cellWidth);

        return holder;
    }

    @Override
    public void onBindViewHolder(DateViewHolder holder, int position) {
        Calendar day = getItem(position);
        HorizontalCalendarConfig config = horizontalCalendar.getConfig();

        final Integer selectorColor = horizontalCalendar.getConfig().getSelectorColor();
        if (selectorColor != null) {
            holder.selectionView.setBackgroundColor(selectorColor);
        }
        // Fri Dec 06 00:00:00 GMT + 05:30 2019
        // Fri Dec 06 15:22:32 GMT + 05:30 2019
        holder.textMiddle.setText(DateFormat.format(config.getFormatMiddleText(), day));
        //holder.textMiddle.setTextSize(TypedValue.COMPLEX_UNIT_SP, config.getSizeMiddleText());

        if (config.isShowTopText()) {
            holder.textTop.setText(DateFormat.format(config.getFormatTopText(), day));
            holder.textTop.setTextSize(TypedValue.COMPLEX_UNIT_SP, config.getSizeTopText());
        } else {
            holder.textTop.setVisibility(View.GONE);
        }
        int count = 0;

        for (String s : dataLists) {
            if (s.contains((new SimpleDateFormat("yyyy-MM-dd").format(day.getTime()))) || s.contains("0000-00-00 00:00:00")) {
                count = count + 1;
            }
        }


        if (config.isShowBottomText()) {
            /*if (day.get(Calendar.YEAR) == Calendar.getInstance().get(Calendar.YEAR)
                    && day.get(Calendar.MONTH) == Calendar.getInstance().get(Calendar.MONTH)
                    && day.get(Calendar.DATE) == Calendar.getInstance().get(Calendar.DATE)) {
                todayPosition = position;
                holder.textBottom.setText("Today");
            } else if (*//*todayPosition + 1 == position*//*day.get(Calendar.YEAR) == Calendar.getInstance().get(Calendar.YEAR)
                    && day.get(Calendar.MONTH) == Calendar.getInstance().get(Calendar.MONTH)
                    && day.get(Calendar.DATE) == Calendar.getInstance().get(Calendar.DATE) + 1) {
                tomorrowPosition = position;
                holder.textBottom.setText("Tomorrow");
            } else*/
            holder.textBottom.setText(DateFormat.format(config.getFormatBottomText(), day));

            //holder.textBottom.setTextSize(TypedValue.COMPLEX_UNIT_SP, config.getSizeBottomText());
        } else {
            holder.textBottom.setVisibility(View.GONE);
        }

        showEvents(holder, day);
        applyStyle(holder, day, position);

    }

    @Override
    public void onBindViewHolder(DateViewHolder holder, int position, List<Object> payloads) {
        if ((payloads == null) || payloads.isEmpty()) {
            onBindViewHolder(holder, position);
            return;
        }

        Calendar date = getItem(position);
        applyStyle(holder, date, position);
    }

    @Override
    public Calendar getItem(int position) throws IndexOutOfBoundsException {
        if (position >= itemsCount) {
            throw new IndexOutOfBoundsException();
        }

        int daysDiff = position - horizontalCalendar.getShiftCells();

        Calendar calendar = (Calendar) startDate.clone();
        calendar.add(Calendar.DATE, daysDiff);

        return calendar;
    }

    @Override
    protected int calculateItemsCount(Calendar startDate, Calendar endDate) {
        int days = Utils.daysBetween(startDate, endDate) + 1;
        return days + (horizontalCalendar.getShiftCells() * 2);
    }
}
