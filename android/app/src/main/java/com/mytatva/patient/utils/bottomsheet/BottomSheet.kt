package com.mytatva.patient.utils.bottomsheet

import android.view.View
import android.widget.TextView
import androidx.core.view.isVisible
import androidx.fragment.app.FragmentActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.mytatva.patient.R


/**
 * Created by  on 29/10/16.
 */

class BottomSheet<T> {

    fun showBottomSheetDialog(
        activity: FragmentActivity,
        list: ArrayList<T>,
        title: String,
        listener: BottomSheetAdapter.ItemListener<T>,
        noDataMessage: String = "No data found",
    ) {

        val view = activity.layoutInflater.inflate(R.layout.common_bottomsheet_layout, null)

        val recyclerView = view.findViewById<View>(R.id.recyclerView) as RecyclerView
        val textView = view.findViewById<View>(R.id.dilogHeading) as TextView
        val textViewNoData = view.findViewById<View>(R.id.textViewNoData) as TextView

        textView.text = title

        if (title.isEmpty()) {
            val divider = view.findViewById<View>(R.id.divider) as View
            divider.visibility = View.GONE

            textView.visibility = View.GONE
        }

        recyclerView.setHasFixedSize(true)
        recyclerView.layoutManager = LinearLayoutManager(activity.applicationContext)

        val mBottomSheetDialog = BottomSheetDialog(activity)
        recyclerView.adapter = BottomSheetAdapter(list, listener, mBottomSheetDialog)
        mBottomSheetDialog.setContentView(view)
        val mDialogBehavior = BottomSheetBehavior.from(view.parent as View)

        mDialogBehavior.skipCollapsed = true
        mDialogBehavior.state = BottomSheetBehavior.STATE_EXPANDED

        if (list.isEmpty()) {
            textViewNoData.isVisible = true
            textViewNoData.text = noDataMessage
        } else {
            textViewNoData.isVisible = false
        }
        /*

        final int screenOrientation = ((WindowManager) new App().getApplicationContext().getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay().getRotation();
        mBottomSheetDialog.setOnShowListener(new DialogInterface.OnShowListener() {
            @Override
            public void onShow(DialogInterface dialogInterface) {
                switch (screenOrientation) {
                    case Surface.ROTATION_0:
                        break;
                    case Surface.ROTATION_90:
                        mDialogBehavior.setPeekHeight(200);//get the height dynamically
                        break;
                    case Surface.ROTATION_180:
                        break;
                    case Surface.ROTATION_270:
                        mDialogBehavior.setPeekHeight(200);//get the height dynamically
                        break;
                    default:
                        break;
                }
               */
        /* if (screenOrientation == Configuration.ORIENTATION_LANDSCAPE)
                    mDialogBehavior.setPeekHeight(200);//get the height dynamically*//*

            }
        });
*/

        mBottomSheetDialog.show()

    }

    /*
    public static void showBottomSheetDialog(Activity activity, List<wineName> list, String title, BottomSheetAdapter.ItemListener listner) {

        View view = activity.getLayoutInflater().inflate(R.layout.bottomsheet_layout, null);

        RecyclerView recyclerView = (RecyclerView) view.findViewById(R.id.recyclerView);
        TextView textView = (TextView) view.findViewById(R.id.dilogHeading);
        textView.setText(title);

        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(activity.getApplicationContext()));

        BottomSheetDialog mBottomSheetDialog = new BottomSheetDialog(activity);
        recyclerView.setAdapter(new BottomSheetAdapter(list, listner, mBottomSheetDialog));
        mBottomSheetDialog.setContentView(view);
        BottomSheetBehavior mDialogBehavior = BottomSheetBehavior.from((View) view.getParent());

        mDialogBehavior.setSkipCollapsed(true);

        mBottomSheetDialog.show();

    }
*/
}
