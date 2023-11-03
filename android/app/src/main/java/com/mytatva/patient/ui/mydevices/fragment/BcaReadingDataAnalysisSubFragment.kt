package com.mytatva.patient.ui.mydevices.fragment

import android.annotation.SuppressLint
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.ColorUtils
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.github.mikephil.charting.components.Legend
import com.github.mikephil.charting.components.LimitLine
import com.github.mikephil.charting.components.XAxis
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.data.LineData
import com.github.mikephil.charting.data.LineDataSet
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet
import com.mytatva.patient.R
import com.mytatva.patient.data.model.BcaReadingRange
import com.mytatva.patient.data.model.ChartDurations
import com.mytatva.patient.data.model.FattyLiverUSGGrades
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.model.getColorsAsPerStatus
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcaReadingsTrendsData
import com.mytatva.patient.data.pojo.response.ChartRecordData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.MydeviceFragmentBcaReadingDataAnalysisSubBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.SegmentedProgressBar
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.chart.MyXAxisValueFormatter
import com.mytatva.patient.utils.chart.MyYAxisValueFormatter
import com.mytatva.patient.utils.chart.markerview.MyMarkerView
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.formatToDecimalPoint
import com.mytatva.patient.utils.listOfField
import com.mytatva.patient.utils.parseAsColor

class BcaReadingDataAnalysisSubFragment :
    BaseFragment<MydeviceFragmentBcaReadingDataAnalysisSubBinding>() {

    private var bcaReadingsTrendsData: BcaReadingsTrendsData? = null
    private var chartRecordData: ChartRecordData? = null
    val avgReadingValue
        get() = chartRecordData?.average?.reading_value?.toDoubleOrNull()?.formatToDecimalPoint(2)
            ?: "0"

    lateinit var goalReadingViewModel: GoalReadingViewModel
    var goalReadingData: GoalReadingData? = null
    var chartDuration = ChartDurations.SEVEN_DAYS

    //chart params
    private val AXIS_LINE_GRID_COLOR by lazy {
        requireContext().getColor(R.color.textBlack1Transparent20)
    }
    private val AXIS_TEXT_COLOR by lazy {
        requireContext().getColor(R.color.textBlack1)
    }
    private var CHART_COLOR = Color.parseColor("#760FB2")
    private var CHART_COLOR_2 = Color.parseColor("#760FB2")
    private val AXIS_TEXT_SIZE = 8
    private val CHART_ANIM_DURATION = 0
    //================================


    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MydeviceFragmentBcaReadingDataAnalysisSubBinding {
        return MydeviceFragmentBcaReadingDataAnalysisSubBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        goalReadingViewModel =
            ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        vitalsTrendAnalysis()
        with(binding) {
            if (goalReadingData?.keys == Readings.BasalMetabolicRate.readingKey) {
                segmentProgressBar.isVisible = false
                textViewNormalRange.isVisible = false
            } else {
                //segmentProgressBar.isVisible = true
                textViewNormalRange.isVisible = true
            }
        }
    }

    override fun bindData() {
        setUpViewListeners()
        setUpChartTouchEventsForDrag()
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun setUpChartTouchEventsForDrag() {
        val onTouchListener = View.OnTouchListener { view, motionEvent ->
            when (motionEvent.action) {
                MotionEvent.ACTION_MOVE -> {
                    binding.nestedScrollView.requestDisallowInterceptTouchEvent(true)
                }

                MotionEvent.ACTION_UP,
                MotionEvent.ACTION_CANCEL,
                -> {
                    binding.nestedScrollView.requestDisallowInterceptTouchEvent(false)
                }
            }
            false
        }

        binding.lineChart.setOnTouchListener(onTouchListener)
    }

    private fun setUpViewListeners() {
        with(binding) {
            textViewChartDuration.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewChartDuration -> {
                showDurationSelection()
            }
        }
    }

    private fun showDurationSelection() {
        BottomSheet<ChartDurations>().showBottomSheetDialog(requireActivity(),
            ChartDurations.values().toList() as ArrayList<ChartDurations>,
            "",
            object : BottomSheetAdapter.ItemListener<ChartDurations> {
                override fun onItemClick(item: ChartDurations, position: Int) {
                    chartDuration = item
                    vitalsTrendAnalysis()

                    analytics.logEvent(
                        analytics.USER_CHANGES_DATE_RANGE, Bundle().apply {
                            putString(
                                analytics.PARAM_DATE_RANGE_VALUE, chartDuration.durationTitle
                            )
                            putString(
                                analytics.PARAM_MODULE, "BCA"
                            )
                        }, screenName = AnalyticsScreenNames.SmartScaleReadingAnalysis
                    )

                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<ChartDurations>.MyViewHolder,
                    position: Int,
                    item: ChartDurations,
                ) {
                    holder.textView.text = item.durationTitle
                }
            })
    }

    private fun setupSegmentedBarUI() {
        binding.segmentProgressBar.visibility = View.VISIBLE
        val bcaValuesList = bcaReadingsTrendsData?.bca_standard_values?.sortedBy { it.fromValue }

        val minRangeValue = bcaValuesList?.minByOrNull { it.fromValue }?.fromValue ?: 0.0
        val maxRangeValue = bcaValuesList?.maxByOrNull { it.toValue }?.toValue ?: 0.0
        val maxMinDiff = maxRangeValue - minRangeValue
        Log.d(
            "RangeIndicator",
            "minRangeValue: $minRangeValue, maxRangeValue : $maxRangeValue, maxMinDiff: $maxMinDiff"
        )
        if (maxMinDiff > 0.0) {
            //set from to range percentage based on from & to values
            bcaValuesList?.forEachIndexed { index, rangeData ->
                val toValueDiff = if (index == 0)
                    rangeData.toValue - minRangeValue
                else
                    rangeData.toValue - bcaValuesList[index - 1].toValue

                bcaValuesList[index].fromToRangePercentage = toValueDiff / maxMinDiff
                Log.d(
                    "RangeIndicator",
                    "rangeData.to: ${rangeData.toValue}, rangeData.from : ${rangeData.fromValue}, rangeData.percentage: ${bcaValuesList[index].fromToRangePercentage}"
                )
            }
        }

        val barContexts = arrayListOf<SegmentedProgressBar.BarContext>()
        bcaValuesList?.forEachIndexed { index, rangeData ->
            barContexts.add(
                SegmentedProgressBar.BarContext(
                    resources.getColor(
                        rangeData.label.getColorsAsPerStatus(),
                        null
                    ), //gradient start
                    resources.getColor(
                        rangeData.label.getColorsAsPerStatus(),
                        null
                    ), //gradient stop
                    rangeData.fromToRangePercentage?.toFloat() ?: 0f //percentage for segment
                )
            )
            Log.d("RangeIndicator", "barContextPercentage: ${barContexts[index].percentage}")
        }

        try {

            var indicatorPointerColor = goalReadingData?.reading_range.getColorsAsPerStatus()
            var indicatorPercent =
                (goalReadingData?.getReadingValueDouble!! - minRangeValue) / maxMinDiff
            Log.d("RangeIndicator", "indicatorPercent: $indicatorPercent")
            if (indicatorPercent > 1) {
                // if value goes above the maxRange, set max percent and max range color
                indicatorPercent = 1.0
                //indicatorPointerColor = bcaValuesList?.lastOrNull()?.label.getColorsAsPerStatus()
            } else if (indicatorPercent < 0) {
                // if value goes below the minRange, set min percent and min range color
                indicatorPercent = 0.0
                //indicatorPointerColor = bcaValuesList?.firstOrNull()?.label.getColorsAsPerStatus()
            }

            Log.d("RangeIndicator", "indicatorPercent: $indicatorPercent")
            binding.segmentProgressBar.setContexts(
                barContexts = barContexts,
                indicatorPoint = indicatorPercent.toFloat(),
                indicatorPointColor = resources.getColor(indicatorPointerColor, null)
            )
        } catch (e: Exception) {
        }


        /*binding.segmentProgressBar.setContexts(
            barContexts = listOf(
                SegmentedProgressBar.BarContext(
                    Color.parseColor("#F48A26"), //gradient start
                    Color.parseColor("#F48A26"), //gradient stop
                    0.33f //percentage for segment
                ),
                SegmentedProgressBar.BarContext(
                    Color.parseColor("#12BA12"),
                    Color.parseColor("#12BA12"),
                    0.33f
                ),
                SegmentedProgressBar.BarContext(
                    Color.parseColor("#F94E4E"),
                    Color.parseColor("#F94E4E"),
                    0.34f
                ),
            ),
            indicatorPoint = 0.4f,
            indicatorPointColor = Color.parseColor("#12BA12")
        )*/
    }

    //line chart methods
    private fun setUpLineChart() {
        with(binding) {
            lineChart.visibility = View.VISIBLE

            lineChart.setExtraOffsets(0f, 0f, 10f, 0f)

            lineChart.clear()
            //chart
            lineChart.description.isEnabled = false
            lineChart.setDrawGridBackground(false)
            lineChart.animateXY(CHART_ANIM_DURATION, CHART_ANIM_DURATION)

            //lineChart.setDrawBorders(true)
            //lineChart.setWillNotDraw()


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
            leftAxis.setDrawGridLines(true)

            if (chartRecordData?.threshold_show == "Y") {
                handleLimitLines(leftAxis)
            }

            lineChart.axisRight.isEnabled = false

            if (goalReadingData?.keys == Readings.FattyLiverUSGGrade.readingKey) {
                //To show formatted FattyLiverUSGGrade on chart Y Axis
                val yAxis = lineChart.axisLeft
                yAxis.valueFormatter =
                    MyYAxisValueFormatter(
                        java.util.ArrayList(FattyLiverUSGGrades.values().toList())
                            .listOfField(FattyLiverUSGGrades::title)
                    )
                yAxis.isGranularityEnabled = true
                yAxis.granularity = 1f
                yAxis.labelCount = 4
                yAxis.setCenterAxisLabels(false)
                yAxis.setDrawZeroLine(true)
                yAxis.axisMinimum = 0f
                yAxis.axisMaximum = 3f
            }

            //X axis
            val xAxis: XAxis = lineChart.xAxis
            xAxis.typeface = tf
            xAxis.isEnabled = true
            xAxis.position = XAxis.XAxisPosition.BOTTOM
            xAxis.setDrawGridLines(false)
            xAxis.textColor = AXIS_TEXT_COLOR
            xAxis.axisLineColor = AXIS_LINE_GRID_COLOR
            xAxis.textSize = AXIS_TEXT_SIZE.toFloat()

            xAxis.isGranularityEnabled = true
            xAxis.granularity = 1f
            when (chartDuration) {
                ChartDurations.SEVEN_DAYS -> {
                    xAxis.labelCount = 6
                    xAxis.setCenterAxisLabels(false)
                }

                ChartDurations.FIFTEEN_DAYS -> {
                    xAxis.labelCount = 15
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
            }

            //set data
            lineChart.data = getLineData()

            lineChart.setScaleEnabled(false)

            lineChart.legend.isEnabled = false

            lineChart.setDrawMarkers(true)
            val mv = MyMarkerView(
                requireContext(),
                R.layout.common_layout_chart_marker,
                CHART_COLOR,
                CHART_COLOR_2
            )

            mv.readingKey = goalReadingData?.keys ?: ""

            mv.chartView = lineChart
            lineChart.marker = mv
            lineChart.invalidate()
        }
    }

    private fun handleLimitLines(leftAxis: YAxis) {
        leftAxis.removeAllLimitLines()
        when (goalReadingData?.keys) {
            /* Readings.BloodPressure.readingKey -> {
                 chartRecordData?.diastolic_standard_max?.toDoubleOrNull()?.toFloat()?.let {
                     leftAxis.addLimitLine(getLimitLine(it, "Max Diastolic"))
                 }
                 chartRecordData?.diastolic_standard_min?.toDoubleOrNull()?.toFloat()?.let {
                     leftAxis.addLimitLine(getLimitLine(it, "Min Diastolic"))
                 }
                 chartRecordData?.systolic_standard_max?.toDoubleOrNull()?.toFloat()?.let {
                     leftAxis.addLimitLine(getLimitLine(it, "Max Systolic"))
                 }
                 chartRecordData?.systolic_standard_min?.toDoubleOrNull()?.toFloat()?.let {
                     leftAxis.addLimitLine(getLimitLine(it, "Min Systolic"))
                 }
             }

             Readings.BloodGlucose.readingKey -> {
                 chartRecordData?.fast_standard_max?.toDoubleOrNull()?.toFloat()?.let {
                     leftAxis.addLimitLine(getLimitLine(it, "Max Fast"))
                 }
                 chartRecordData?.fast_standard_min?.toDoubleOrNull()?.toFloat()?.let {
                     leftAxis.addLimitLine(getLimitLine(it, "Min Fast"))
                 }
                 chartRecordData?.pp_standard_max?.toDoubleOrNull()?.toFloat()?.let {
                     leftAxis.addLimitLine(getLimitLine(it, "Max PP"))
                 }
                 chartRecordData?.pp_standard_min?.toDoubleOrNull()?.toFloat()?.let {
                     leftAxis.addLimitLine(getLimitLine(it, "Min PP"))
                 }
             }

             Readings.FibroScan.readingKey -> {
                 if (fibroScanType == FibroScanType.CAP) {
                     chartRecordData?.cap_standard_max?.toDoubleOrNull()?.toFloat()?.let {
                         leftAxis.addLimitLine(getLimitLine(it, "Max"))
                     }
                     chartRecordData?.cap_standard_min?.toDoubleOrNull()?.toFloat()?.let {
                         leftAxis.addLimitLine(getLimitLine(it, "Min"))
                     }
                 } else {
                     chartRecordData?.lsm_standard_max?.toDoubleOrNull()?.toFloat()?.let {
                         leftAxis.addLimitLine(getLimitLine(it, "Max"))
                     }
                     chartRecordData?.lsm_standard_min?.toDoubleOrNull()?.toFloat()?.let {
                         leftAxis.addLimitLine(getLimitLine(it, "Min"))
                     }
                 }
             }*/

            // as only BCA readings will be here, no extra cases required to handle
            else -> {
                chartRecordData?.standard_max?.toDoubleOrNull()?.toFloat()?.let {
                    leftAxis.addLimitLine(getLimitLine(it, "Max"))
                }
                chartRecordData?.standard_min?.toDoubleOrNull()?.toFloat()?.let {
                    leftAxis.addLimitLine(getLimitLine(it, "Min"))
                }
            }
        }
    }

    private fun getLimitLine(limit: Float, label: String): LimitLine {
        val ll1 = LimitLine(limit, label)
        ll1.lineColor = ContextCompat.getColor(requireContext(), R.color.red)
        ll1.lineWidth = 1f
        //ll1.enableDashedLine(10f, 10f, 0f)
        ll1.textSize = 9f
        ll1.textColor = ContextCompat.getColor(requireContext(), R.color.textBlack1)
        ll1.typeface = ResourcesCompat.getFont(requireActivity(), R.font.sf_bold)
        //ll1.xOffset = requireActivity().windowManager.defaultDisplay.width
        ll1.labelPosition = LimitLine.LimitLabelPosition.LEFT_TOP
        //ll1.yOffset
        return ll1
    }

    private fun getLineData(): LineData {
        val sets = java.util.ArrayList<ILineDataSet>()

        val values1 = java.util.ArrayList<Entry>()
        val values2 = java.util.ArrayList<Entry>() // used for dual line chart values

        // set xAxis labels
        val xLabels = arrayListOf<String>()

        chartRecordData?.readings_data?.forEachIndexed { index, goalReadingData ->
            xLabels.add(goalReadingData.x_value ?: index.toString())
            when (goalReadingData.keys) {
                else -> {
                    values1.add(
                        Entry(
                            index.toFloat(),
                            goalReadingData.reading_value?.toFloatOrNull() ?: 0f
                        )
                    )
                }
            }
        }

        // set xLabels
        val xAxis: XAxis = binding.lineChart.xAxis
        xAxis.valueFormatter = MyXAxisValueFormatter(xLabels)

        // Set Data set 1
        val ds1 = LineDataSet(values1, "")
        /*ds1.mode = LineDataSet.Mode.CUBIC_BEZIER
        ds1.cubicIntensity = 0.15f*/
        ds1.setDrawHighlightIndicators(false)
        ds1.color = CHART_COLOR
        ds1.lineWidth = 2f
        ds1.circleRadius = 4f
        ds1.circleHoleRadius = 2f
        ds1.setCircleColor(Color.WHITE)
        ds1.setDrawCircleHole(true)
        ds1.circleHoleColor = CHART_COLOR
        ds1.setDrawValues(false)
        ds1.valueTextColor = CHART_COLOR
        val gradientEndColor = ColorUtils.setAlphaComponent(Color.WHITE, 0)
        ds1.setDrawFilled(true)
        ds1.fillDrawable = GradientDrawable(
            GradientDrawable.Orientation.TOP_BOTTOM,
            intArrayOf(CHART_COLOR, gradientEndColor)
        )
        sets.add(ds1)

        if (values2.isNotEmpty()) {
            // SET 2
            val ds2 = LineDataSet(values2, "")
            /*ds1.mode = LineDataSet.Mode.CUBIC_BEZIER
            ds1.cubicIntensity = 0.15f*/
            ds2.setDrawHighlightIndicators(false)
            ds2.color = CHART_COLOR_2
            ds2.lineWidth = 2f
            ds2.circleRadius = 4f
            ds2.circleHoleRadius = 2f
            ds2.setCircleColor(Color.WHITE)
            ds2.setDrawCircleHole(true)
            ds2.circleHoleColor = CHART_COLOR_2
            ds2.setDrawValues(false)
            ds2.valueTextColor = CHART_COLOR_2
            val gradientEndColor2 = ColorUtils.setAlphaComponent(Color.WHITE, 0)
            ds2.setDrawFilled(true)
            ds2.fillDrawable = GradientDrawable(
                GradientDrawable.Orientation.TOP_BOTTOM,
                intArrayOf(CHART_COLOR_2, gradientEndColor2)
            )

            sets.add(ds2)
        }

        val d = LineData(sets)
        /*d.setValueTypeface(tf)*/
        return d
    }
    //=========

    private fun updateDurationLabel() {
        binding.textViewChartDuration.text = chartDuration.durationTitle
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun vitalsTrendAnalysis() {
        updateDurationLabel()
        val apiRequest = ApiRequest().apply {
            reading_id = goalReadingData?.readings_master_id
            reading_time = chartDuration.durationKey
        }
        showLoader()
        goalReadingViewModel.vitalsTrendAnalysis(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //vitalsTrendAnalysisLiveData
        goalReadingViewModel.vitalsTrendAnalysisLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                setData(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }

    private fun setData(bcaReadingsTrendsData: BcaReadingsTrendsData?) {
        this.bcaReadingsTrendsData = bcaReadingsTrendsData
        this.chartRecordData = bcaReadingsTrendsData?.trend_graph

        // common chart color
        try {
            if (chartRecordData?.color_code_1.isNullOrBlank().not())
                CHART_COLOR = chartRecordData?.color_code_1.parseAsColor()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        // for dual line chart
        try {
            if (chartRecordData?.color_code_2.isNullOrBlank().not())
                CHART_COLOR_2 = chartRecordData?.color_code_2.parseAsColor()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        with(binding) {
            if (chartRecordData?.readings_data.isNullOrEmpty()){
                textViewNoData.visibility = View.VISIBLE
                lineChart.visibility = View.INVISIBLE
            } else {
                textViewNoData.visibility = View.GONE
                setUpLineChart()
            }

            textViewLabelAnalysis.text = "${goalReadingData?.reading_name} Analysis"
            textViewWhatIs.text = "What is ${goalReadingData?.reading_name}?"
            textViewMuscleAnalysisDefinition.text = bcaReadingsTrendsData?.information
            textViewLastReadingValue.text = goalReadingData?.getFormattedReadingValue
            textViewAverageTrendValue.text = avgReadingValue

            // comparison label
            val sb = StringBuilder()
            if ((bcaReadingsTrendsData?.increasedBy ?: 0.0) > 0.0) {
                sb.append("↑ by ${bcaReadingsTrendsData?.increasedBy.formatToDecimalPoint(2)}")
                textViewReadingComparisionValue.setTextColor(
                    resources.getColor(
                        R.color.range_normal,
                        null
                    )
                )
            } else if ((bcaReadingsTrendsData?.increasedBy ?: 0.0) < 0.0) {
                sb.append(
                    "↓ by ${
                        bcaReadingsTrendsData?.increasedBy.formatToDecimalPoint(2).replace("-", "")
                    }"
                )
                textViewReadingComparisionValue.setTextColor(
                    resources.getColor(
                        R.color.range_toohigh,
                        null
                    )
                )
            }
            textViewReadingComparisionValue.text = sb.toString()

            // set normal range
            val normalRange = bcaReadingsTrendsData?.bca_standard_values
                ?.firstOrNull { it.label == BcaReadingRange.Normal.title }
            if (normalRange?.from != null && normalRange.to != null) {
                normalRange.let {
                    val sbNormalRange = StringBuilder()
                    sbNormalRange.append("Normal : ")
                    sbNormalRange.append(it.fromValue.formatToDecimalPoint(1))
                    sbNormalRange.append(" - ")
                    sbNormalRange.append(it.toValue.formatToDecimalPoint(1))
                    sbNormalRange.append(" ")
                    sbNormalRange.append(goalReadingData?.measurements)
                    textViewNormalRange.text = sbNormalRange.toString()
                }
            }

            //setupSegmentedBarUI
            if (goalReadingData?.keys != Readings.BasalMetabolicRate.readingKey) {
                setupSegmentedBarUI()
            }
        }
    }
}