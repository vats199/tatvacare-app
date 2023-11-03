package devs.mulham.horizontalcalendar.adapter;

import android.view.View;
import android.widget.TextView;

import androidx.appcompat.widget.AppCompatTextView;
import androidx.recyclerview.widget.RecyclerView;

import devs.mulham.horizontalcalendar.R;

/**
 * @author Mulham-Raee
 * @since v1.0.0
 */
class DateViewHolder extends RecyclerView.ViewHolder {

    TextView textTop;
    TextView textMiddle;
    TextView textBottom;
    //AppCompatTextView textViewCount;
    View selectionView;
    View layoutContent;
    RecyclerView eventsRecyclerView;

    DateViewHolder(View rootView) {
        super(rootView);
        textTop = rootView.findViewById(R.id.hc_text_top);
        textMiddle = rootView.findViewById(R.id.hc_text_middle);
        textBottom = rootView.findViewById(R.id.hc_text_bottom);
        //textViewCount = rootView.findViewById(R.id.textViewCount);
        layoutContent = rootView.findViewById(R.id.hc_layoutContent);
        selectionView = rootView.findViewById(R.id.hc_selector);
        eventsRecyclerView = rootView.findViewById(R.id.hc_events_recyclerView);
    }
}
