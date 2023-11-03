package com.mytatva.patient.ui.common.dialog

import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.*
import androidx.fragment.app.DialogFragment
import com.mytatva.patient.databinding.CommonDialogImageViewerBinding
import com.mytatva.patient.ui.common.adapter.FullScreenImageAdapter


class ImageViewerDialog : DialogFragment() {


    private var _binding: CommonDialogImageViewerBinding? = null

    protected val binding: CommonDialogImageViewerBinding
        get() = _binding!!

    internal var list: ArrayList<String> = ArrayList()
    internal var pos: Int = 0

    lateinit var fullScreenImageAdapter: FullScreenImageAdapter

    fun setImageList(list: List<String>): ImageViewerDialog {
        this.list.addAll(list)
        return this
    }

    fun setCurrentPos(position: Int): ImageViewerDialog {
        pos = position
        return this
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        //val view = inflater.inflate(R.layout.common_dialog_image_viewer, container, false)
        dialog?.requestWindowFeature(Window.FEATURE_NO_TITLE)

        val wmlp = dialog?.window?.attributes
        wmlp?.gravity = Gravity.FILL_HORIZONTAL
        dialog?.window?.requestFeature(STYLE_NO_TITLE)
        dialog?.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))

        _binding = CommonDialogImageViewerBinding.inflate(inflater, container, false)
        return binding.root

        //return view
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        /*if (dialog?.window != null)
                   dialog?.window!!.attributes.windowAnimations = R.style.DialogAnimation*/

        fullScreenImageAdapter = FullScreenImageAdapter(requireActivity(), list, object : FullScreenImageAdapter.OnOutSideClick {
            override fun goBack() {
//                dismiss()
            }
        })

        with(binding) {
            pager.adapter = fullScreenImageAdapter
            pager.currentItem = pos

            /*if (resources.getBoolean(R.bool.is_right_to_left)) {
            pager.rotationY = 180F
        }*/

            imageViewClose.setOnClickListener {
                dismiss()
            }
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
    }



   /* override fun onResume() {
        super.onResume()
        dialog?.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))

        dialog?.setCancelable(true)

        val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = wm.defaultDisplay
        val metrics = DisplayMetrics()
        display.getMetrics(metrics)
        val width = metrics.widthPixels * 1
        val height = metrics.heightPixels * 1
        val win = dialog?.window

        win!!.setLayout(width.toInt(), height.toInt())

    }*/

}