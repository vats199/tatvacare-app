package devs.mulham.horizontalcalendar.adapter;

import android.graphics.Color;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.Calendar;
import java.util.Collections;
import java.util.List;

import devs.mulham.horizontalcalendar.HorizontalCalendar;
import devs.mulham.horizontalcalendar.HorizontalCalendarView;
import devs.mulham.horizontalcalendar.HorizontalLayoutManager;
import devs.mulham.horizontalcalendar.model.CalendarEvent;
import devs.mulham.horizontalcalendar.model.CalendarItemStyle;
import devs.mulham.horizontalcalendar.utils.CalendarEventsPredicate;
import devs.mulham.horizontalcalendar.utils.HorizontalCalendarListener;
import devs.mulham.horizontalcalendar.utils.HorizontalCalendarPredicate;
import devs.mulham.horizontalcalendar.utils.Utils;

/**
 * Base class for all adapters for {@link HorizontalCalendarView HorizontalCalendarView}
 *
 * @author Mulham-Raee
 * @since v1.3.0
 */
public abstract class HorizontalCalendarBaseAdapter<VH extends DateViewHolder, T extends Calendar> extends RecyclerView.Adapter<VH> {

    final HorizontalCalendar horizontalCalendar;
    private final int itemResId;
    private final HorizontalCalendarPredicate disablePredicate;
    private final CalendarEventsPredicate eventsPredicate;
    private final int cellWidth;
    protected Calendar startDate;
    protected int itemsCount;
    private CalendarItemStyle disabledItemStyle;


    protected HorizontalCalendarBaseAdapter(int itemResId, final HorizontalCalendar horizontalCalendar, Calendar startDate, Calendar endDate, HorizontalCalendarPredicate disablePredicate, CalendarEventsPredicate eventsPredicate) {
        this.itemResId = itemResId;
        this.horizontalCalendar = horizontalCalendar;
        this.disablePredicate = disablePredicate;
        this.startDate = startDate;
        if (disablePredicate != null) {
            this.disabledItemStyle = disablePredicate.style();
        }
        this.eventsPredicate = eventsPredicate;


        cellWidth = Utils.calculateCellWidthAsPerCalView(horizontalCalendar.getContext(), horizontalCalendar.getNumberOfDatesOnScreen());
        itemsCount = calculateItemsCount(startDate, endDate);
    }

    @Override
    public VH onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(itemResId, parent, false);

        final VH viewHolder = createViewHolder(itemView, cellWidth);
        viewHolder.itemView.setOnClickListener(new MyOnClickListener(viewHolder));
        viewHolder.itemView.setOnLongClickListener(new MyOnLongClickListener(viewHolder));

        if (eventsPredicate != null) {
            initEventsRecyclerView(viewHolder.eventsRecyclerView);
        } else {
            viewHolder.eventsRecyclerView.setVisibility(View.GONE);
        }

        return viewHolder;
    }

    private void initEventsRecyclerView(RecyclerView recyclerView) {
        recyclerView.setHasFixedSize(true);
        recyclerView.setAdapter(new EventsAdapter(Collections.<CalendarEvent>emptyList()));
        GridLayoutManager layoutManager = new GridLayoutManager(recyclerView.getContext(), 4);
        recyclerView.setLayoutManager(layoutManager);
    }

    protected abstract VH createViewHolder(View itemView, int cellWidth);

    public abstract T getItem(int position);

    @Override
    public int getItemCount() {
        return itemsCount;
    }

    public boolean isDisabled(int position) {
        if (disablePredicate == null) {
            return false;
        }
        Calendar date = getItem(position);
        return disablePredicate.test(date);
    }

    protected void showEvents(VH viewHolder, Calendar date) {
        if (eventsPredicate == null) {
            return;
        }

        List<CalendarEvent> events = eventsPredicate.events(date);
        if ((events == null) || events.isEmpty()) {
            viewHolder.eventsRecyclerView.setVisibility(View.GONE);
        } else {
            viewHolder.eventsRecyclerView.setVisibility(View.VISIBLE);
            EventsAdapter eventsAdapter = (EventsAdapter) viewHolder.eventsRecyclerView.getAdapter();
            eventsAdapter.update(events);
        }
    }

    protected void applyStyle(VH viewHolder, Calendar date, int position) {
        int selectedItemPosition = horizontalCalendar.getSelectedDatePosition();

        if (disablePredicate != null) {
            boolean isDisabled = disablePredicate.test(date);
            viewHolder.itemView.setEnabled(!isDisabled);
            if (isDisabled && (disabledItemStyle != null)) {
                applyStyle(viewHolder, disabledItemStyle, false);
                // viewHolder.selectionView.setVisibility(View.INVISIBLE);
                return;
            }
        }

        // Selected Day
        if (position == selectedItemPosition) {
            applyStyle(viewHolder, horizontalCalendar.getSelectedItemStyle(), true);
            //     viewHolder.selectionView.setVisibility(View.VISIBLE);
        }
        // Unselected Days
        else {
            applyStyle(viewHolder, horizontalCalendar.getDefaultStyle(), false);
            //    viewHolder.selectionView.setVisibility(View.INVISIBLE);
        }
    }

    private void applyStyle(VH viewHolder, CalendarItemStyle itemStyle, Boolean isSelecteday) {
        viewHolder.textTop.setTextColor(itemStyle.getColorTopText());
        if (isSelecteday) {
            viewHolder.layoutContent.setSelected(true);
            //viewHolder.textMiddle.setTextColor(/*itemStyle.getColorMiddleText()*/Color.parseColor("#FA5B6F"));
            //viewHolder.textBottom.setTextColor(/*itemStyle.getColorBottomText()*/Color.parseColor("#FA5B6F"));
        } else {
            viewHolder.layoutContent.setSelected(false);
            //viewHolder.textMiddle.setTextColor(/*itemStyle.getColorMiddleText()*/Color.parseColor("#3D464B"));
            //viewHolder.textBottom.setTextColor(/*itemStyle.getColorBottomText()*/Color.parseColor("#9AA0B2"));
        }
        if (Build.VERSION.SDK_INT >= 16) {
            viewHolder.itemView.setBackground(itemStyle.getBackground());
        } else {
            viewHolder.itemView.setBackgroundDrawable(itemStyle.getBackground());
        }
    }

    public void update(Calendar startDate, Calendar endDate, boolean notify) {
        this.startDate = startDate;
        itemsCount = calculateItemsCount(startDate, endDate);
        if (notify) {
            notifyDataSetChanged();
        }
    }

    protected abstract int calculateItemsCount(Calendar startDate, Calendar endDate);

    private class MyOnClickListener implements View.OnClickListener {
        private final RecyclerView.ViewHolder viewHolder;

        MyOnClickListener(RecyclerView.ViewHolder viewHolder) {
            this.viewHolder = viewHolder;
        }

        @Override
        public void onClick(View v) {
            int position = viewHolder.getAdapterPosition();
            if (position == -1)
                return;

            horizontalCalendar.getCalendarView().setSmoothScrollSpeed(HorizontalLayoutManager.SPEED_NORMAL);
            horizontalCalendar.centerCalendarToPosition(position);
        }
    }

    private class MyOnLongClickListener implements View.OnLongClickListener {
        private final RecyclerView.ViewHolder viewHolder;

        MyOnLongClickListener(RecyclerView.ViewHolder viewHolder) {
            this.viewHolder = viewHolder;
        }

        @Override
        public boolean onLongClick(View v) {
            HorizontalCalendarListener calendarListener = horizontalCalendar.getCalendarListener();
            if (calendarListener == null) {
                return false;
            }

            int position = viewHolder.getAdapterPosition();
            Calendar date = getItem(position);

            return calendarListener.onDateLongClicked(date, position);
        }
    }
}
