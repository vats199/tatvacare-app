package com.mytatva.patient.ui.careplan.fragment

import android.annotation.SuppressLint
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.ColorUtils
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.viewpager.widget.ViewPager
import com.github.mikephil.charting.components.Legend
import com.github.mikephil.charting.components.XAxis
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.data.*
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet
import com.mytatva.patient.R
import com.mytatva.patient.data.model.ChartDurations
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.pojo.response.ChartRecordData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.CarePlanFragmentGoalSummaryCommonBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.chart.MyXAxisValueFormatter
import com.mytatva.patient.utils.chart.markerview.MyMarkerView
import com.mytatva.patient.utils.chart.renderer.BarChartRender
import com.mytatva.patient.utils.formatToDecimalPoint
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor
import java.util.*

class GoalSummaryCommonFragment : BaseFragment<CarePlanFragmentGoalSummaryCommonBinding>() {

    lateinit var callbackOnUpdate: () -> Unit

    //chart params
    private val AXIS_LINE_GRID_COLOR by lazy {
        requireContext().getColor(R.color.textBlack1Transparent20)
    }
    private val AXIS_TEXT_COLOR by lazy {
        requireContext().getColor(R.color.textBlack1)
    }
    private var CHART_COLOR = Color.parseColor("#760FB2")
    private val AXIS_TEXT_SIZE = 8
    private val CHART_ANIM_DURATION = 0
    //================================

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }
    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    var chartDuration: ChartDurations = ChartDurations.SEVEN_DAYS

    var goalReadingData: GoalReadingData? = null

    var chartRecordData: ChartRecordData? = null
    private val goalsChartData = arrayListOf<GoalReadingData>()

    private val avgGoalValue: String
        get() {
            /*return if (goalReadingData?.keys == Goals.Sleep.goalKey) {
                (chartRecordData?.average?.goal_value?.toDoubleOrNull()
                    ?.formatToDecimalPoint(1) ?: 0).toString()
            } else*/
            return (chartRecordData?.average?.goal_value?.toDoubleOrNull()?.toInt() ?: 0).toString()
        }

    private val avgAchievedGoalValue: String
        get() {
            return if (goalReadingData?.keys == Goals.Sleep.goalKey) {
                (goalReadingData?.todays_achieved_value?.toDoubleOrNull()
                    ?.formatToDecimalPoint(1) ?: 0).toString()
            } else
                return (goalReadingData?.todays_achieved_value?.toDoubleOrNull()?.toInt()
                    ?: 0).toString()
        }

    private val goalValueLabel: String
        get() {
            return (try {
                goalReadingData?.goal_value?.toDoubleOrNull()?.toInt()?.toString() ?: "0"
            } catch (e: Exception) {
                "0"
            }).plus(" ").plus(goalReadingData?.goal_measurement ?: "")
        }

    private val getAverageGoalLabel: String
        get() {
            return goalReadingData?.getStandardGoalLabel("") ?: ""
            //goalReadingData?.getGoalAverageLabel(requireContext()) ?: ""
        }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanFragmentGoalSummaryCommonBinding {
        return CarePlanFragmentGoalSummaryCommonBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun bindData() {
        if (goalReadingData?.color_code.isNullOrBlank().not()) {
            CHART_COLOR = goalReadingData?.color_code.parseAsColor()
        }
        setHeaderData()
        setViewListeners()
        //getGoalRecords()
        setUpChartTouchEventsForDrag()
        chartRecordData?.let {
            //setChartData(it,null)
        }
    }

    private fun setHeaderData() {
        with(binding) {
            goalReadingData?.let {
                imageViewIcon.loadUrlIcon(it.image_url ?: "", false)
                textViewTitle.setTextColor(CHART_COLOR)
                textViewTitle.text = it.goal_name
            }
        }
    }

    var parentViewPager: ViewPager? = null

    @SuppressLint("ClickableViewAccessibility")
    private fun setUpChartTouchEventsForDrag() {
        val onTouchListener = View.OnTouchListener { view, motionEvent ->
            when (motionEvent.action) {
                MotionEvent.ACTION_MOVE -> {
                    parentViewPager?.requestDisallowInterceptTouchEvent(true)
                }
                MotionEvent.ACTION_UP,
                MotionEvent.ACTION_CANCEL,
                -> {
                    parentViewPager?.requestDisallowInterceptTouchEvent(false)
                }
            }
            false
        }

        binding.lineChart.setOnTouchListener(onTouchListener)
        binding.barChart.setOnTouchListener(onTouchListener)
    }

    private fun setUpChart() {
        if (isAdded) {
            with(binding) {
                when (chartDuration) {
                    ChartDurations.SEVEN_DAYS -> {
                        setUpBarChart()
                    }
                    ChartDurations.THIRTY_DAYS -> {
                        setUpBarChart()
                        //setUpLineChart()
                    }
                    ChartDurations.NINETY_DAYS -> {
                        setUpBarChart()
                        //setUpLineChart()
                    }
                    ChartDurations.ONE_YEAR -> {
                        setUpBarChart()
                        //setUpLineChart()
                    }
                    /*ChartDurations.ALL -> {
                        setUpLineChart()
                    }*/
                    else -> {}
                }
            }
        }
    }

    //line chart methods
    private fun setUpLineChart() {
        with(binding) {
            barChart.visibility = View.GONE
            lineChart.visibility = View.VISIBLE

            lineChart.setExtraOffsets(0f, 0f, 20f, 0f)

            lineChart.clear()
            //chart
            lineChart.description.isEnabled = false
            lineChart.setDrawGridBackground(false)
            lineChart.animateXY(CHART_ANIM_DURATION, CHART_ANIM_DURATION)
            lineChart.isHighlightPerTapEnabled = true
            lineChart.isHighlightPerDragEnabled = true

            val tf = ResourcesCompat.getFont(requireContext(), R.font.sf_medium)
            val l: Legend = lineChart.legend
            l.typeface = tf

            //left axis
            val leftAxis: YAxis = lineChart.axisLeft
            leftAxis.typeface = tf
            leftAxis.gridColor = AXIS_LINE_GRID_COLOR
            leftAxis.textColor = AXIS_TEXT_COLOR
            leftAxis.textSize = AXIS_TEXT_SIZE.toFloat()
            leftAxis.setDrawAxisLine(false)
            lineChart.axisRight.isEnabled = false

            //X axis
            val xAxis: XAxis = lineChart.xAxis
            xAxis.typeface = tf
            xAxis.isEnabled = true
            xAxis.position = XAxis.XAxisPosition.BOTTOM
            xAxis.setDrawGridLines(false)
            xAxis.textColor = AXIS_TEXT_COLOR
            xAxis.axisLineColor = AXIS_LINE_GRID_COLOR
            xAxis.textSize = AXIS_TEXT_SIZE.toFloat()

            //set data
            lineChart.data = getLineData()

            lineChart.setScaleEnabled(false)
            lineChart.scaleX

            lineChart.legend.isEnabled = false

            lineChart.setDrawMarkers(true)
            val mv =
                MyMarkerView(requireContext(), R.layout.common_layout_chart_marker, CHART_COLOR)
            mv.chartView = lineChart
            lineChart.marker = mv

            lineChart.invalidate()

            /*lineChart.clearAnimation()
            lineChart.animateY(1500, Easing.EaseInQuad)*/
        }
    }

    private fun getLineData(): LineData {
        val sets = ArrayList<ILineDataSet>()

        val values1 = ArrayList<Entry>()

        // set xAxis labels
        val xLabels = arrayListOf<String>()

        goalsChartData.forEachIndexed { index, goalReadingData ->
            xLabels.add(goalReadingData.x_value ?: index.toString())

            /*if (index < 7) {
                xLabels.add("Week 1")
            } else if (index in 7..13) {
                xLabels.add("Week 2")
            } else if (index in 14..20) {
                xLabels.add("Week 3")
            } else if (index in 21..27) {
                xLabels.add("Week 4")
            } else {
                xLabels.add("Week 5")
            }*/

            values1.add(Entry(index.toFloat(),
                goalReadingData.achieved_value?.toFloatOrNull() ?: 0f))
        }

        val xAxis: XAxis = binding.lineChart.xAxis
        xAxis.valueFormatter = MyXAxisValueFormatter(xLabels)
        /*xAxis.isGranularityEnabled = false
        xAxis.granularity = 7f*/
        xAxis.setCenterAxisLabels(true)

        val ds1 = LineDataSet(values1, "")
        /*ds1.mode = LineDataSet.Mode.CUBIC_BEZIER
        ds1.cubicIntensity = 0.15f*/

        ds1.color = CHART_COLOR
        ds1.setDrawHighlightIndicators(false)
        /*ds1.setCircleColor(Color.parseColor("#750C21"))*/

        ds1.lineWidth = 2f
        ds1.circleRadius = 3f
        ds1.circleHoleRadius = 1.5f
        ds1.setCircleColor(Color.WHITE)
        ds1.setDrawCircleHole(true)
        ds1.circleHoleColor = CHART_COLOR

        val gradientEndColor = ColorUtils.setAlphaComponent(Color.WHITE, 0)
        ds1.setDrawFilled(true)
        ds1.fillDrawable = GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM,
            intArrayOf(CHART_COLOR, gradientEndColor))

        ds1.setDrawValues(true)
        ds1.valueTextColor = CHART_COLOR

        // load DataSets from files in assets folder
        sets.add(ds1)

        val d = LineData(sets)
        /*d.setValueTypeface(tf)*/
        return d
    }
    //=========

    //bar chart methods
    private fun setUpBarChart() {
        with(binding) {
            lineChart.visibility = View.GONE
            barChart.visibility = View.VISIBLE

            //barChart.setExtraOffsets(0f, 0f, 20f, 0f)
            //barChart.setViewPortOffsets(50f, 0f, 100f, 80f)

            barChart.clear()
            barChart.description.isEnabled = false
            barChart.isSelected = false
            barChart.isHighlightPerTapEnabled = true
            barChart.isHighlightPerDragEnabled = true
            barChart.animateXY(CHART_ANIM_DURATION, CHART_ANIM_DURATION)

            barChart.setPinchZoom(false)
            barChart.setScaleEnabled(false)
            //barChart.isDragEnabled = false

            barChart.isDoubleTapToZoomEnabled = false

            barChart.setDrawBarShadow(false)

            barChart.setDrawGridBackground(false)

            barChart.renderer = BarChartRender(barChart,
                barChart.animator,
                barChart.viewPortHandler,
                CHART_COLOR)

            val xAxis = barChart.xAxis
            xAxis.position = XAxis.XAxisPosition.BOTTOM
            //xAxis.granularity = 2f

            xAxis.setDrawGridLines(false)

            xAxis.typeface = ResourcesCompat.getFont(requireActivity(), R.font.sf_medium)
            xAxis.textColor = AXIS_TEXT_COLOR
            xAxis.isGranularityEnabled = true
            xAxis.granularity = 1f
            xAxis.textSize = AXIS_TEXT_SIZE.toFloat()
            when (chartDuration) {
                ChartDurations.SEVEN_DAYS -> {
                    xAxis.labelCount = 6
                    xAxis.setCenterAxisLabels(false)
                }
                ChartDurations.THIRTY_DAYS -> {
                    xAxis.labelCount = 10
                    xAxis.setCenterAxisLabels(false)
                }
                ChartDurations.NINETY_DAYS -> {
                    xAxis.labelCount = 3
                    xAxis.setCenterAxisLabels(true)
                }
                ChartDurations.ONE_YEAR -> {
                    xAxis.labelCount = 12
                    xAxis.setCenterAxisLabels(false)
                }

                else -> {}
            }
            //


            /*when (chartDuration) {
                ChartDurations.SEVEN_DAYS -> {
                    xAxis.setLabelCount(7, true)
                    xAxis.setCenterAxisLabels(false)
                }
                ChartDurations.THIRTY_DAYS -> {
                    xAxis.setLabelCount(10, true)
                    xAxis.setCenterAxisLabels(false)
                }
                ChartDurations.NINETY_DAYS -> {
                    xAxis.setLabelCount(3, true)
                    xAxis.setCenterAxisLabels(true)
                }
                ChartDurations.ONE_YEAR -> {
                    xAxis.setLabelCount(12, true)
                    xAxis.setCenterAxisLabels(false)
                }
            }*/


            val leftAxis = barChart.axisLeft
            leftAxis.setDrawGridLines(true)
            /*leftAxis.mAxisRange = 1.5f
            leftAxis.axisMaximum = 20f
            leftAxis.axisMinimum = 0f
            leftAxis.labelCount = 1*/
            leftAxis.typeface = ResourcesCompat.getFont(requireActivity(), R.font.sf_medium)
            /*leftAxis.textColor = AXIS_TEXT_COLOR
            leftAxis.axisLineColor = AXIS_TEXT_COLOR*/
            leftAxis.textSize = AXIS_TEXT_SIZE.toFloat()

            leftAxis.axisLineColor = AXIS_LINE_GRID_COLOR
            leftAxis.gridColor = AXIS_LINE_GRID_COLOR

            barChart.axisRight.isEnabled = false

            val l = barChart.legend
            l.isEnabled = false

            val xValues = arrayListOf<String>()
            val values1 = ArrayList<BarEntry>()

            goalsChartData.forEachIndexed { index, goalReadingData ->
                xValues.add(goalReadingData.x_value ?: index.toString())
                values1.add(BarEntry(index.toFloat(),
                    goalReadingData.achieved_value?.toFloatOrNull() ?: 0f))
            }

            /*values1.add(BarEntry(0f, 17f))
            values1.add(BarEntry(1f, 20f))
            values1.add(BarEntry(2f, 10f))
            values1.add(BarEntry(3f, 12f))
            values1.add(BarEntry(4f, 18f))
            values1.add(BarEntry(5f, 12f))
            values1.add(BarEntry(6f, 8f))*/

            xAxis.valueFormatter = MyXAxisValueFormatter(xValues)
            val set1 = BarDataSet(values1, "")
            set1.highLightColor = CHART_COLOR
            set1.color = CHART_COLOR
            set1.setDrawValues(false)
            set1.valueTextColor = CHART_COLOR

            val data = BarData(set1)

            data.barWidth = 0.5f

            barChart.data = data

            barChart.xAxis.setDrawAxisLine(false)
            barChart.axisLeft.setDrawAxisLine(false)
            barChart.axisRight.setDrawAxisLine(false)

            barChart.setDrawMarkers(true)
            val mv =
                MyMarkerView(requireContext(), R.layout.common_layout_chart_marker, CHART_COLOR)
            mv.chartView = barChart
            barChart.marker = mv

            barChart.description.isEnabled = false

            barChart.invalidate()
        }
    }
    //=========

    private fun setViewListeners() {
        binding.apply {
            buttonUpdate.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonUpdate -> {
                callbackOnUpdate.invoke()
            }
        }
    }


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    fun getGoalRecords() {
        /*val apiRequest = ApiRequest()
        apiRequest.goal_id = goalReadingData?.goal_master_id
        apiRequest.goal_time = chartDuration.durationKey
        //showLoader()
        goalReadingViewModel.getGoalRecords(apiRequest)*/
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        /*goalReadingViewModel.getGoalRecordsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { setChartData(it) }
            },
            onError = { throwable ->
                hideLoader()
                with(binding) {
                    barChart.visibility = View.GONE
                    lineChart.visibility = View.GONE
                }
                false
            })*/
    }

    fun setChartData(chartRecordData: ChartRecordData?, throwable: Throwable?) {
        binding.progressBar.isVisible = false
        if (isAdded) {
            if (chartRecordData != null) {
                binding.textViewNoData.visibility = View.GONE

                this.chartRecordData = chartRecordData
                goalsChartData.clear()
                chartRecordData.goal_data?.let { goalsChartData.addAll(it) }

                //binding.textViewLabelDailyGoal.visibility = View.VISIBLE
                setUpChart()
                setAvgData()
            } else {
                with(binding) {
                    barChart.visibility = View.GONE
                    lineChart.visibility = View.GONE
                    //textViewLabelDailyGoal.visibility = View.INVISIBLE
                    textViewNoData.visibility = View.VISIBLE
                    textViewNoData.text = throwable?.message
                }
            }

            binding.textViewGoalValue.text = goalValueLabel
            binding.textViewAverageGoal.text = getAverageGoalLabel
            /*avgAchievedGoalValue.plus(" ").plus(goalReadingData?.goal_measurement)*/
        }
    }

    private fun setAvgData() {
        with(binding) {
            textViewMessage.text = getAvgMessageForGoal()
        }
    }

    private fun getAvgMessageForGoal(): String {
        val durationMsg =
            (/*if (chartDuration == ChartDurations.ALL) "" else */"last")
                .plus(" ")
                .plus(chartDuration.durationTitle.lowercase(Locale.ENGLISH))

        if (goalReadingData?.keys == Goals.Diet.goalKey) {
            return "Over the $durationMsg, you have eaten on average of $avgGoalValue ${goalReadingData?.goal_measurement} of meals."
        } else {
            return "Over the $durationMsg, you have done an average of $avgGoalValue ${goalReadingData?.goal_measurement} of ${goalReadingData?.goal_name}."
        }
    }
}