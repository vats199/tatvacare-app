package com.mytatva.patient.ui.careplan.fragment

import android.content.Intent
import android.graphics.Color
import android.graphics.Paint
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.ColorUtils
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.github.mikephil.charting.charts.ScatterChart
import com.github.mikephil.charting.components.Legend
import com.github.mikephil.charting.components.LimitLine
import com.github.mikephil.charting.components.XAxis
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.data.*
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet
import com.github.mikephil.charting.utils.MPPointF
import com.google.gson.Gson
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.*
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.CatSurveyData
import com.mytatva.patient.data.pojo.response.ChartRecordData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.CarePlanFragmentReadingSummaryCommonBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingsMainFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.chart.CandleValueFormatter
import com.mytatva.patient.utils.chart.MyXAxisValueFormatter
import com.mytatva.patient.utils.chart.MyYAxisValueFormatter
import com.mytatva.patient.utils.chart.markerview.CandleStickMarkerView
import com.mytatva.patient.utils.chart.markerview.MyMarkerView
import com.mytatva.patient.utils.chart.markerview.ScatterMarkerView
import com.mytatva.patient.utils.chart.renderer.BarChartRender
import com.mytatva.patient.utils.chart.renderer.MyCandleStickChartRender
import com.mytatva.patient.utils.chart.renderer.MyScatterChartRenderer
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.formatToDecimalPoint
import com.mytatva.patient.utils.listOfField
import com.mytatva.patient.utils.parcelableArrayList
import com.mytatva.patient.utils.parseAsColor
import com.surveysparrow.ss_android_sdk.SurveySparrow
import org.json.JSONArray
import java.util.*


class ReadingSummaryCommonFragment : BaseFragment<CarePlanFragmentReadingSummaryCommonBinding>() {

    //chart params
    private val AXIS_LINE_GRID_COLOR by lazy {
        requireContext().getColor(R.color.textBlack1Transparent20)
    }
    private val AXIS_TEXT_COLOR by lazy {
        requireContext().getColor(R.color.textBlack1)
    }

    private var CHART_COLOR = Color.parseColor("#760FB2")
    private var CHART_COLOR_2 = Color.parseColor("#760FB2")

    /*private val CANDLE_STICK_CHART_COLOR by lazy {
        requireContext().getColor(R.color.chartPink)
    }*/

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

    var chartDuration = ChartDurations.SEVEN_DAYS
    var fibroScanType = FibroScanType.LSM

    var goalReadingData: GoalReadingData? = null

    var currentPosition = 0
    private val readingsList = arrayListOf<GoalReadingData>()

    var chartRecordData: ChartRecordData? = null
    private val readingsChartData = arrayListOf<GoalReadingData>()

    // readding value params
    val avgDiastolic
        get() = chartRecordData?.average?.diastolic?.toDoubleOrNull()?.formatToDecimalPoint(2)
            ?: "0"
    val avgSystolic
        get() = chartRecordData?.average?.systolic?.toDoubleOrNull()?.formatToDecimalPoint(2) ?: "0"

    val avgFast
        get() = chartRecordData?.average?.fast?.toDoubleOrNull()?.formatToDecimalPoint(2) ?: "0"
    val avgPP
        get() = chartRecordData?.average?.pp?.toDoubleOrNull()?.formatToDecimalPoint(2) ?: "0"

    val avgLsm
        get() = chartRecordData?.average?.lsm?.toDoubleOrNull()?.formatToDecimalPoint(2) ?: "0"
    val avgCap
        get() = chartRecordData?.average?.cap?.toDoubleOrNull()?.formatToDecimalPoint(2) ?: "0"

    val avgReadingValue
        get() = chartRecordData?.average?.reading_value?.toDoubleOrNull()?.formatToDecimalPoint(2)
            ?: "0"

    val formattedLastReadingTime: String
        get() {
            return if (chartRecordData != null) {
                chartRecordData!!.formattedLastReadingTime + " on " + chartRecordData!!.formattedLastReadingDate
            } else {
                ""
            }
        }
    //====================================

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanFragmentReadingSummaryCommonBinding {
        return CarePlanFragmentReadingSummaryCommonBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ReadingChart.plus(goalReadingData?.keys))
    }

    override fun bindData() {
        getArgumentsData()
        setData()
        //setUpChart()
        Handler(Looper.getMainLooper()).postDelayed({
            getReadingRecords()
        }, 0)

        /*setUpCandleStickChart()
        binding.candleStickChart.visibility = View.VISIBLE*/

        setViewListeners()
    }

    private fun getArgumentsData() {
        arguments?.let {
            currentPosition = it.getInt(Common.BundleKey.POSITION)
            readingsList.clear()

            /*it.getParcelableArrayList<GoalReadingData>(Common.BundleKey.READING_LIST)?.let { it1 ->
                readingsList.addAll(it1)
            }*/
            it.parcelableArrayList<GoalReadingData>(Common.BundleKey.READING_LIST)?.let { it1 ->
                readingsList.addAll(it1)
            }

            // as of now this is one object
            goalReadingData = readingsList[currentPosition]

            binding.rootChart.transitionName = goalReadingData?.keys
        }
    }

    private fun setData() {
        with(binding) {
            textViewTitle.text = goalReadingData?.reading_name
            buttonLog.text = "Log ${goalReadingData?.reading_name}"
            textViewFibroScanSelection.isVisible =
                goalReadingData?.keys == Readings.FibroScan.readingKey

            textViewChartDuration.text = chartDuration.durationTitle
            textViewFibroScanSelection.text = fibroScanType.title
        }
    }

    private fun setUpChart() {
        with(binding) {
            if (goalReadingData?.keys == Readings.HeartRate.readingKey) {
                //for heart rate chart
                //setUpCandleStickChart()
                setUpScatterChart()
            } else if (goalReadingData?.keys == Readings.BloodPressure.readingKey
                || goalReadingData?.keys == Readings.BloodGlucose.readingKey
            ) {
                //for BloodPressure & BloodGlucose chart
                setUpLineChart()
            } else {
                //for else common readings chart
                when (chartDuration) {
                    ChartDurations.SEVEN_DAYS -> {
                        lineChart.visibility = View.GONE
                        barChart.visibility = View.VISIBLE
                        //setUpBarChart()
                        setUpLineChart()
                    }
                    ChartDurations.FIFTEEN_DAYS -> {
                        lineChart.visibility = View.GONE
                        barChart.visibility = View.VISIBLE
                        //setUpBarChart()
                        setUpLineChart()
                    }
                    ChartDurations.THIRTY_DAYS -> {
                        lineChart.visibility = View.VISIBLE
                        barChart.visibility = View.GONE
                        //setUpBarChart()
                        setUpLineChart()
                    }
                    ChartDurations.NINETY_DAYS -> {
                        lineChart.visibility = View.VISIBLE
                        barChart.visibility = View.GONE
                        setUpLineChart()
                    }
                    ChartDurations.ONE_YEAR -> {
                        lineChart.visibility = View.VISIBLE
                        barChart.visibility = View.GONE
                        setUpLineChart()
                    }
                    /*ChartDurations.ALL -> {
                        lineChart.visibility = View.VISIBLE
                        barChart.visibility = View.GONE
                        setUpLineChart()
                    }*/
                }
            }
        }
    }

    //line chart methods
    private fun setUpLineChart() {
        with(binding) {
            lineChart.visibility = View.VISIBLE
            barChart.visibility = View.GONE
            candleStickChart.visibility = View.GONE

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
                        ArrayList(FattyLiverUSGGrades.values().toList())
                            .listOfField(FattyLiverUSGGrades::title))
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


            /*xAxis.labelCount = readingsChartData.size
            xAxis.isGranularityEnabled = true
            xAxis.granularity = 1f*/
            /*xAxis.spaceMin = 0f
            xAxis.spaceMax = 10f*/
            /*xAxis.mAxisMaximum = 10f
            xAxis.mAxisMinimum = 5f*/
            /*xAxis.mAxisRange = 20f*/

            //set data
            lineChart.data = getLineData()

            lineChart.setScaleEnabled(false)

            lineChart.legend.isEnabled = false

            lineChart.setDrawMarkers(true)
            val mv = MyMarkerView(requireContext(),
                R.layout.common_layout_chart_marker,
                CHART_COLOR,
                CHART_COLOR_2)

            mv.readingKey = goalReadingData?.keys ?: ""
            if (goalReadingData?.keys == Readings.FibroScan.readingKey) {
                // for FibroScan reading, set isLSM flag to handle value format
                mv.isLSM = fibroScanType == FibroScanType.LSM
            }

            mv.chartView = lineChart
            lineChart.marker = mv
            lineChart.invalidate()
        }
    }

    private fun handleLimitLines(leftAxis: YAxis) {
        leftAxis.removeAllLimitLines()
        when (goalReadingData?.keys) {
            Readings.BloodPressure.readingKey -> {
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
            }
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
        val sets = ArrayList<ILineDataSet>()

        val values1 = ArrayList<Entry>()
        val values2 = ArrayList<Entry>() // used for dual line chart values

        // set xAxis labels
        val xLabels = arrayListOf<String>()

        readingsChartData.forEachIndexed { index, goalReadingData ->

            xLabels.add(goalReadingData.x_value ?: index.toString())

            when (goalReadingData.keys) {
                Readings.BloodPressure.readingKey -> {
                    values1.add(Entry(index.toFloat(),
                        goalReadingData.systolic?.toFloatOrNull() ?: 0f))
                    values2.add(Entry(index.toFloat(),
                        goalReadingData.diastolic?.toFloatOrNull() ?: 0f))
                }
                Readings.BloodGlucose.readingKey -> {
                    values1.add(Entry(index.toFloat(),
                        goalReadingData.fast?.toFloatOrNull() ?: 0f))
                    values2.add(Entry(index.toFloat(),
                        goalReadingData.pp?.toFloatOrNull() ?: 0f))
                }
                Readings.FibroScan.readingKey -> {
                    if (fibroScanType == FibroScanType.CAP) {
                        values1.add(Entry(index.toFloat(),
                            goalReadingData.cap?.toFloatOrNull() ?: 0f))
                    } else {
                        values1.add(Entry(index.toFloat(),
                            goalReadingData.lsm?.toFloatOrNull() ?: 0f))
                    }
                }
                /*Readings.FattyLiverUSGGrade.readingKey -> {
                    if (goalReadingData.updated_at.isNullOrBlank()){
                        values1.add(Entry(index.toFloat(), -1f))
                    } else {
                        values1.add(Entry(index.toFloat(),
                            goalReadingData.reading_value?.toFloatOrNull() ?: 0f))
                    }
                }*/
                else -> {
                    values1.add(Entry(index.toFloat(),
                        goalReadingData.reading_value?.toFloatOrNull() ?: 0f))
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
        ds1.fillDrawable = GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM,
            intArrayOf(CHART_COLOR, gradientEndColor))
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
            ds2.fillDrawable = GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM,
                intArrayOf(CHART_COLOR_2, gradientEndColor2))

            sets.add(ds2)
        }

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
            candleStickChart.visibility = View.GONE

            barChart.clear()
            barChart.description.isEnabled = false
            barChart.isSelected = false
            //barChart.isHighlightPerTapEnabled = true
            barChart.isHighlightPerDragEnabled = true
            barChart.animateXY(CHART_ANIM_DURATION, CHART_ANIM_DURATION)
            barChart.setPinchZoom(false)
            barChart.setScaleEnabled(false)
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


            val leftAxis = barChart.axisLeft
            leftAxis.setDrawGridLines(false)
            leftAxis.mAxisRange = 1.5f
            /*leftAxis.axisMaximum = 10f
            leftAxis.axisMinimum = 0f*/
            //leftAxis.labelCount = 1
            leftAxis.typeface = ResourcesCompat.getFont(requireActivity(), R.font.sf_medium)
            leftAxis.textColor = AXIS_TEXT_COLOR
            leftAxis.axisLineColor = AXIS_TEXT_COLOR
            barChart.axisRight.isEnabled = false

            val l = barChart.legend
            l.isEnabled = false

            val xLabels = arrayListOf<String>()
            val values1 = ArrayList<BarEntry>()

            readingsChartData.forEachIndexed { index, goalReadingData ->
                xLabels.add(goalReadingData.x_value ?: index.toString())
                values1.add(BarEntry(index.toFloat(),
                    goalReadingData.reading_value?.toFloatOrNull() ?: 0f))
            }

            xAxis.valueFormatter = MyXAxisValueFormatter(xLabels)

            val set1 = BarDataSet(values1, "")
            //set1.highLightColor = CHART_COLOR
            set1.isHighlightEnabled = true
            set1.color = CHART_COLOR
            set1.valueTextColor = CHART_COLOR
            set1.setDrawValues(false)

            val data = BarData(set1)
            data.barWidth = 0.5f
            barChart.data = data
            barChart.xAxis.setDrawAxisLine(false)
            barChart.axisLeft.setDrawAxisLine(false)
            barChart.axisRight.setDrawAxisLine(false)

            barChart.setDrawMarkers(true)
            val mv = MyMarkerView(requireContext(),
                R.layout.common_layout_chart_marker, CHART_COLOR, CHART_COLOR_2)
            mv.chartView = barChart
            barChart.marker = mv


            barChart.description.isEnabled = false

            barChart.invalidate()
        }
    }
    //=========

    //CandleStickChart methods
    private fun setUpCandleStickChart() {
        with(binding) {
            lineChart.visibility = View.GONE
            barChart.visibility = View.GONE
            candleStickChart.visibility = View.VISIBLE

            candleStickChart.clear()
            candleStickChart.description.isEnabled = false
            candleStickChart.isSelected = false
            candleStickChart.isHighlightPerTapEnabled = true
            candleStickChart.isHighlightPerDragEnabled = true
            candleStickChart.animateXY(CHART_ANIM_DURATION, CHART_ANIM_DURATION)
            candleStickChart.setPinchZoom(false)
            candleStickChart.setScaleEnabled(false)
            candleStickChart.isDoubleTapToZoomEnabled = false
            candleStickChart.setDrawGridBackground(false)

            candleStickChart.renderer = MyCandleStickChartRender(candleStickChart,
                candleStickChart.animator,
                candleStickChart.viewPortHandler,
                CHART_COLOR)

            val xAxis = candleStickChart.xAxis
            xAxis.position = XAxis.XAxisPosition.BOTTOM
            //xAxis.granularity = 2f

            xAxis.setDrawGridLines(false)

            xAxis.typeface = ResourcesCompat.getFont(requireActivity(), R.font.sf_medium)
            xAxis.textColor = AXIS_TEXT_COLOR


            val leftAxis = candleStickChart.axisLeft

            leftAxis.setDrawGridLines(false)
            /*leftAxis.mAxisRange = 2.5f*/
            /*leftAxis.axisMaximum = 10f
            leftAxis.axisMinimum = 0f*/
            //leftAxis.labelCount = 1

            leftAxis.typeface = ResourcesCompat.getFont(requireActivity(), R.font.sf_medium)

            leftAxis.textColor = AXIS_TEXT_COLOR
            leftAxis.axisLineColor = AXIS_TEXT_COLOR

            candleStickChart.axisRight.isEnabled = false

            val l = candleStickChart.legend
            l.isEnabled = false

            val cds: CandleDataSet
            val values1 = ArrayList<CandleEntry>()
            val xLabels = arrayListOf<String>()

            readingsChartData.forEachIndexed { index, goalReadingData ->
                xLabels.add(goalReadingData.x_value ?: index.toString())
                values1.add(CandleEntry(
                    index.toFloat(),
                    goalReadingData.reading_value_max?.toFloatOrNull() ?: 0f,
                    goalReadingData.reading_value_min?.toFloatOrNull() ?: 0f,
                    goalReadingData.reading_value_min?.toFloatOrNull() ?: 0f,
                    goalReadingData.reading_value_max?.toFloatOrNull() ?: 0f,
                    /*ResourcesCompat.getDrawable(requireContext().resources,
                        R.drawable.ic_badges,
                        null)*/
                ))
            }

            /* values1.add(CandleEntry(0f, 4.62f, 2.02f, 2.02f, 4.62f))
             values1.add(CandleEntry(1f, 5.50f, 2.70f, 2.70f, 5.50f))
             values1.add(CandleEntry(2f, 5.25f, 3.02f, 3.02f, 5.25f))
             values1.add(CandleEntry(3f, 6.0f, 3.25f, 3.25f, 6.0f))
             values1.add(CandleEntry(9f, 5.57f, 2.0f, 2.0f, 5.57f))*/

            //x labels
            xAxis.valueFormatter = MyXAxisValueFormatter(xLabels)

            cds = CandleDataSet(values1, "")
            cds.highLightColor = CHART_COLOR
            cds.color = CHART_COLOR
            cds.setDrawValues(false)
            cds.valueTextColor = CHART_COLOR
            cds.setDrawIcons(true)
            cds.iconsOffset = MPPointF.getInstance(0f, 15f)

            cds.barSpace = 0.3f
            cds.showCandleBar = true

            cds.shadowColor = CHART_COLOR
            cds.shadowWidth = 1f
            cds.decreasingColor = CHART_COLOR
            cds.decreasingPaintStyle = Paint.Style.FILL
            cds.increasingColor = CHART_COLOR
            cds.increasingPaintStyle = Paint.Style.FILL
            cds.neutralColor = CHART_COLOR
            cds.valueTextColor = CHART_COLOR

            cds.valueFormatter = CandleValueFormatter()

            val cd = CandleData(cds)
            candleStickChart.data = cd

            candleStickChart.xAxis.setDrawAxisLine(false)
            candleStickChart.axisLeft.setDrawAxisLine(false)
            candleStickChart.axisRight.setDrawAxisLine(false)

            //candleStickChart.minOffset

            candleStickChart.setDrawMarkers(true)
            val mv = CandleStickMarkerView(requireContext(),
                R.layout.common_layout_chart_marker,
                CHART_COLOR)
            mv.chartView = candleStickChart
            candleStickChart.marker = mv

            candleStickChart.description.isEnabled = false

            candleStickChart.invalidate()
        }
    }
    //=========

    //CandleStickChart methods
    private fun setUpScatterChart() {
        with(binding) {
            lineChart.visibility = View.GONE
            barChart.visibility = View.GONE
            candleStickChart.visibility = View.GONE
            scatterChart.visibility = View.VISIBLE

            scatterChart.clear()
            scatterChart.description.isEnabled = false
            scatterChart.isSelected = false
            scatterChart.isHighlightPerTapEnabled = true
            scatterChart.isHighlightPerDragEnabled = true
            scatterChart.animateXY(CHART_ANIM_DURATION, CHART_ANIM_DURATION)
            scatterChart.setPinchZoom(false)
            scatterChart.setScaleEnabled(false)
            scatterChart.isDoubleTapToZoomEnabled = false
            scatterChart.setDrawGridBackground(false)

            scatterChart.renderer = MyScatterChartRenderer(scatterChart,
                scatterChart.animator,
                scatterChart.viewPortHandler)

            val xAxis = scatterChart.xAxis
            xAxis.position = XAxis.XAxisPosition.BOTTOM
            //xAxis.granularity = 2f

            xAxis.setDrawGridLines(false)

            xAxis.axisLineColor = AXIS_LINE_GRID_COLOR
            xAxis.gridColor = AXIS_LINE_GRID_COLOR
            xAxis.textSize = AXIS_TEXT_SIZE.toFloat()
            xAxis.typeface = ResourcesCompat.getFont(requireActivity(), R.font.sf_medium)
            xAxis.textColor = AXIS_TEXT_COLOR

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

            val leftAxis = scatterChart.axisLeft


            /*leftAxis.mAxisRange = 2.5f*/
            /*leftAxis.axisMaximum = 10f
            leftAxis.axisMinimum = 0f*/
            //leftAxis.labelCount = 1
            leftAxis.setDrawGridLines(true)
            leftAxis.typeface = ResourcesCompat.getFont(requireActivity(), R.font.sf_medium)
            leftAxis.textColor = AXIS_TEXT_COLOR
            leftAxis.axisLineColor = AXIS_LINE_GRID_COLOR
            leftAxis.gridColor = AXIS_LINE_GRID_COLOR
            leftAxis.textSize = AXIS_TEXT_SIZE.toFloat()
            leftAxis.spaceTop = 2f
            leftAxis.spaceBottom = 2f

            if (chartRecordData?.threshold_show == "Y") {
                handleLimitLines(leftAxis)
            }

            scatterChart.axisRight.isEnabled = false

            val l = scatterChart.legend
            l.isEnabled = false

            val scatterDataSet: ScatterDataSet
            val values1 = ArrayList<Entry>()
            val xLabels = arrayListOf<String>()

            readingsChartData.forEachIndexed { index, goalReadingData ->
                xLabels.add(goalReadingData.x_value ?: index.toString())

                if (goalReadingData.reading_values.isNullOrEmpty().not()) {
                    goalReadingData.reading_values?.forEachIndexed { indexSub, value ->
                        try {
                            values1.add(Entry(index.toFloat(), value.toFloatOrNull() ?: 0f))
                        } catch (e: Exception) {
                            values1.add(Entry(index.toFloat(), 0f))
                        }
                    }
                } else {
                    values1.add(Entry(index.toFloat(), 0f))
                }
            }

            /*for (i in 0..2) {
                   if (index % 2 == 0) {

                       values1.add(Entry(index.toFloat(), 25f))
                       values1.add(Entry(index.toFloat(), 45f))

                       for (j in 50..60) {
                           values1.add(Entry(index.toFloat(), j.toFloat()))
                       }

                       values1.add(Entry(index.toFloat(), 75f))

                       *//*values1.add(Entry(index.toFloat(), 10f))
                        values1.add(Entry(index.toFloat(), 14f))
                        values1.add(Entry(index.toFloat(), 18f))*//*
                    } else {
                        values1.add(Entry(index.toFloat(), 40f))
                        values1.add(Entry(index.toFloat(), 50f))
                        values1.add(Entry(index.toFloat(), 90f))
                    }
                }*/

            //x labels
            xAxis.valueFormatter = MyXAxisValueFormatter(xLabels)

            scatterDataSet = ScatterDataSet(values1, "DS 1")
            scatterDataSet.highLightColor = CHART_COLOR
            scatterDataSet.color = CHART_COLOR
            scatterDataSet.setDrawValues(false)
            scatterDataSet.valueTextColor = CHART_COLOR
            scatterDataSet.setDrawIcons(true)
            scatterDataSet.iconsOffset = MPPointF.getInstance(0f, 15f)

            scatterDataSet.setScatterShape(ScatterChart.ScatterShape.CIRCLE)
            scatterDataSet.scatterShapeHoleColor = CHART_COLOR
            scatterDataSet.scatterShapeSize = 7f
            scatterDataSet.scatterShapeHoleRadius = 3f

            /*scatterDataSet.barSpace = 0.3f
            scatterDataSet.showCandleBar = true
            scatterDataSet.shadowColor = CHART_COLOR
            scatterDataSet.shadowWidth = 1f
            scatterDataSet.decreasingColor = CHART_COLOR
            scatterDataSet.decreasingPaintStyle = Paint.Style.FILL
            scatterDataSet.increasingColor = CHART_COLOR
            scatterDataSet.increasingPaintStyle = Paint.Style.FILL
            scatterDataSet.neutralColor = CHART_COLOR*/


            scatterDataSet.valueTextColor = CHART_COLOR

            //scatterDataSet.valueFormatter = CandleValueFormatter()

            val cd = ScatterData(scatterDataSet)
            scatterChart.data = cd

            scatterChart.xAxis.setDrawAxisLine(false)
            scatterChart.axisLeft.setDrawAxisLine(false)
            scatterChart.axisRight.setDrawAxisLine(false)

            //candleStickChart.minOffset

            scatterChart.setDrawMarkers(true)
            val mv = ScatterMarkerView(requireContext(),
                R.layout.common_layout_chart_marker,
                CHART_COLOR)
            mv.chartView = scatterChart
            scatterChart.marker = mv

            //scatterChart.maxHighlightDistance = 0f
            //scatterChart.maxHighlightDistance = 100f
            //scatterChart.setHighlighter()

            scatterChart.description.isEnabled = false

            scatterChart.invalidate()
        }
    }
    //=========

    private fun setViewListeners() {
        binding.apply {
            buttonLog.setOnClickListener { onViewClick(it) }
            textViewChartDuration.setOnClickListener { onViewClick(it) }
            textViewFibroScanSelection.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonLog -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.reading_logs,
                        readingsList[currentPosition].keys ?: "")
                ) {
                    if (readingsList[currentPosition].keys == Readings.CAT.readingKey) {
                        getCatSurvey()
                    } else {
                        navigator.loadActivity(TransparentActivity::class.java,
                            UpdateReadingsMainFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.POSITION, currentPosition),
                                Pair(Common.BundleKey.READING_LIST, readingsList)
                            )).shouldAnimate(false).byFinishingCurrent().start()
                    }
                }
            }
            R.id.textViewChartDuration -> {
                BottomSheet<ChartDurations>().showBottomSheetDialog(requireActivity(),
                    ChartDurations.values().toList() as ArrayList<ChartDurations>,
                    "",
                    object : BottomSheetAdapter.ItemListener<ChartDurations> {
                        override fun onItemClick(item: ChartDurations, position: Int) {
                            chartDuration = item
                            binding.textViewChartDuration.text = item.durationTitle

                            analytics.logEvent(
                                analytics.USER_CHANGES_DATE_RANGE, Bundle().apply {
                                    putString(
                                        analytics.PARAM_DATE_RANGE_VALUE, chartDuration.durationTitle
                                    )
                                    putString(
                                        analytics.PARAM_MODULE, "careplan"
                                    )
                                }, screenName = AnalyticsScreenNames.ReadingChart.plus(goalReadingData?.keys)
                            )

                            //setUpChart()
                            getReadingRecords()
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
            R.id.textViewFibroScanSelection -> {
                BottomSheet<FibroScanType>().showBottomSheetDialog(requireActivity(),
                    FibroScanType.values().toList() as ArrayList<FibroScanType>,
                    "",
                    object : BottomSheetAdapter.ItemListener<FibroScanType> {
                        override fun onItemClick(item: FibroScanType, position: Int) {
                            fibroScanType = item
                            binding.textViewFibroScanSelection.text = item.title
                            if (chartRecordData != null) {
                                updateFibroScanValueUnitData()
                                setUpChart()
                            }
                        }

                        override fun onBindViewHolder(
                            holder: BottomSheetAdapter<FibroScanType>.MyViewHolder,
                            position: Int,
                            item: FibroScanType,
                        ) {
                            holder.textView.text = item.title
                        }
                    })
            }
            R.id.imageViewClose -> {
                navigator.goBack()
            }
        }
    }


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getReadingRecords() {
        val apiRequest = ApiRequest().apply {
            reading_id = goalReadingData?.readings_master_id
            reading_time = chartDuration.durationKey
        }
        //showLoader()
        goalReadingViewModel.getReadingRecords(apiRequest)
    }

    private fun getCatSurvey() {
        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.getCatSurvey(apiRequest)
    }

    var catSurveyData: CatSurveyData? = null
    private fun addCatSurvey(surveyResponse: JSONArray, score: String) {
        val list = arrayListOf<ApiRequestSubData>()
        list.addAll(Gson().fromJson(surveyResponse.toString(), Array<ApiRequestSubData>::class.java)
            .toList())

        val apiRequest = ApiRequest().apply {
            survey_id = catSurveyData?.survey_id
            response = list
            this.score = score
            cat_survey_master_id = catSurveyData?.cat_survey_master_id
        }
        showLoader()
        goalReadingViewModel.addCatSurvey(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.getReadingRecordsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    binding.textViewNoData.visibility = View.GONE
                    setChartData(it)
                }
                //(requireActivity() as TransparentActivity).scheduleStartPostponedTransition(binding.rootChart)
            },
            onError = { throwable ->
                hideLoader()
                setNoData(throwable)
                //(requireActivity() as TransparentActivity).scheduleStartPostponedTransition(binding.rootChart)
                throwable !is ServerException
            })


        goalReadingViewModel.getCatSurveyLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    it.survey_id?.let { it1 ->
                        catSurveyData = it
                        initCatSurvey(it1)
                    }
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        goalReadingViewModel.addCatSurveyLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                goalReadingData?.let {
                    analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                        putString(analytics.PARAM_READING_NAME, it.reading_name)
                        putString(analytics.PARAM_READING_ID, it.readings_master_id)
                    }, screenName = AnalyticsScreenNames.LogReading)
                }
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun initCatSurvey(surveyToken: String) {

        surveyUtil.initSurvey(surveyToken) { isSuccess: Boolean, data: Intent?, message: String ->
            if (isSuccess && data != null) {

                val response = SurveySparrow.toJSON(data.data.toString())
                try {
                    val responseData: JSONArray? =
                        if (response.has("response"))
                            response.getJSONArray("response")
                        else
                            null

                    val type = if (response.has("type")) {
                        response.getString("type")
                    } else ""

                    val score = if (response.has("score")) {
                        response.getString("score")
                    } else "0"

                    if (catSurveyData != null) {
                        // add cat survey data
                        Log.e("catData", "::$response")
                        responseData?.let { addCatSurvey(it, score) }
                    }

                } catch (e: Exception) {

                }
            } else {
                Log.d("Response", "::$message")
            }
        }

        /* val survey = SsSurvey(ssDomain, *//*incidentToken*//* surveyToken)
            .addCustomParam("patient_id", session.userId)
        val surveySparrow = SurveySparrow(requireActivity(), survey)
            .setActivityTheme(R.style.AppTheme)
            .setAppBarTitle(R.string.app_name)
            .enableBackButton(true)
            .setWaitTime(2000)

        // Schedule specific config
//            .setStartAfter(TimeUnit.DAYS.toMillis(3L))
//            .setRepeatInterval(TimeUnit.DAYS.toMillis(5L))
//            .setRepeatType(SurveySparrow.REPEAT_TYPE_CONSTANT)
//            .setFeedbackType(SurveySparrow.SINGLE_FEEDBACK)

        surveySparrow.startSurveyForResult(100)*/
    }

    private fun setNoData(throwable: Throwable) {
        if (isAdded) {
            chartRecordData = null //clear chart record data
            with(binding) {
                lineChart.visibility = View.GONE
                barChart.visibility = View.GONE
                candleStickChart.visibility = View.GONE
                layoutReadingInfo.visibility = View.GONE
                layoutReadingInfo2.visibility = View.GONE
                textViewNoData.visibility = View.VISIBLE
                textViewNoData.text = throwable.message
            }//
        }
    }

    private fun setChartData(chartRecordData: ChartRecordData) {
        //TransitionManager.beginDelayedTransition(binding.rootChart)
        this.chartRecordData = chartRecordData
        readingsChartData.clear()
        chartRecordData.readings_data?.let { readingsChartData.addAll(it) }

        // common chart color
        try {
            if (chartRecordData.color_code_1.isNullOrBlank().not())
                CHART_COLOR = chartRecordData.color_code_1.parseAsColor()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        // for dual line chart
        try {
            if (chartRecordData.color_code_2.isNullOrBlank().not())
                CHART_COLOR_2 = chartRecordData.color_code_2.parseAsColor()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        setUpChart()
        setAvgReadingsData()
    }

    private fun setAvgReadingsData() {
        with(binding) {

            textViewValue.setTextColor(CHART_COLOR)
            textViewUnit.setTextColor(CHART_COLOR)
            textViewValue2.setTextColor(CHART_COLOR_2)
            textViewUnit2.setTextColor(CHART_COLOR_2)

            if (goalReadingData?.keys == Readings.BloodPressure.readingKey) {

                layoutReadingInfo.visibility = View.VISIBLE
                textViewLabelLastReading.text = "Last reading Systolic:"
                textViewValue.text =
                    goalReadingData?.getSystolicValue?.toString() ?: "0" //avgSystolic
                textViewUnit.text = goalReadingData?.measurements
                textViewLastReading.text = formattedLastReadingTime

                // 2nd value
                layoutReadingInfo2.visibility = View.VISIBLE
                textViewLabelLastReading2.text = "Last reading Diastolic:"
                textViewValue2.text =
                    goalReadingData?.getDiastolicValue?.toString() ?: "0" //avgDiastolic
                textViewUnit2.text = goalReadingData?.measurements
                textViewLastReading2.text = formattedLastReadingTime

            } else if (goalReadingData?.keys == Readings.BloodGlucose.readingKey) {

                layoutReadingInfo.visibility = View.VISIBLE
                textViewLabelLastReading.text = "Last reading Fast Blood Glucose:"
                textViewValue.text = goalReadingData?.getFastBgValue?.toString() ?: "0" //avgFast
                textViewUnit.text = goalReadingData?.measurements
                textViewLastReading.text = formattedLastReadingTime

                // 2nd value
                layoutReadingInfo2.visibility = View.VISIBLE
                textViewLabelLastReading2.text = "Last reading PP Blood Glucose:"
                textViewValue2.text = goalReadingData?.getPPBgValue?.toString() ?: "0" //avgPP
                textViewUnit2.text = goalReadingData?.measurements
                textViewLastReading2.text = formattedLastReadingTime

            } else if (goalReadingData?.keys == Readings.FibroScan.readingKey) {

                updateFibroScanValueUnitData()

            } else {
                layoutReadingInfo.visibility = View.VISIBLE
                textViewValue.text = goalReadingData?.getFormattedReadingValue //avgReadingValue
                textViewUnit.text = goalReadingData?.measurements
                textViewLastReading.text = formattedLastReadingTime

                layoutReadingInfo2.visibility = View.GONE
            }

            textViewAvgMessage.text = getAvgMessageForReading()
        }
    }

    private fun updateFibroScanValueUnitData() {
        with(binding) {
            layoutReadingInfo.visibility = View.VISIBLE
            textViewLastReading.text = formattedLastReadingTime

            goalReadingData?.apply {
                textViewValue.text = if (fibroScanType == FibroScanType.CAP) {
                    getCapValue?.toString() ?: "0"
                } else {
                    getLsmValue?.formatToDecimalPoint(1) ?: "0.0"
                }

                textViewUnit.text =
                    if (measurements != null && measurements.contains(",")) {
                        if (fibroScanType == FibroScanType.CAP) {
                            measurements.split(",")[1]
                        } else {
                            measurements.split(",")[0]
                        }
                    } else {
                        ""
                    }
            }

            textViewAvgMessage.text = getAvgMessageForReading()

            layoutReadingInfo2.visibility = View.GONE
        }
    }

    private fun getAvgMessageForReading(): String {
        val durationMsg =
            (/*if (chartDuration == ChartDurations.ALL) "for" else */"in the last")
                .plus(" ")
                .plus(chartDuration.durationTitle.lowercase(Locale.ENGLISH))

        return when (goalReadingData?.keys) {
            Readings.BloodPressure.readingKey -> {
                "Average Systolic is $avgSystolic and Diastolic is $avgDiastolic $durationMsg"
            }
            Readings.BloodGlucose.readingKey -> {
                "Average Fast Blood Glucose is $avgFast and PP Blood Glucose is $avgPP $durationMsg"
            }
            Readings.FibroScan.readingKey -> {
                if (fibroScanType == FibroScanType.CAP) {
                    "Average ${goalReadingData?.reading_name} reading $durationMsg is $avgCap"
                } else {
                    "Average ${goalReadingData?.reading_name} reading $durationMsg is $avgLsm"
                }
            }
            Readings.SPO2.readingKey,
            Readings.FEV1.readingKey,
            Readings.PEF.readingKey,
            Readings.HeartRate.readingKey,
            Readings.BodyWeight.readingKey,
            Readings.BMI.readingKey,
            Readings.HbA1c.readingKey,
            Readings.ACR.readingKey,
            Readings.eGFR.readingKey,
                // new added readings
            Readings.FIB4Score.readingKey,
            Readings.SGOT_AST.readingKey,
            Readings.SGPT_ALT.readingKey,
            Readings.Triglycerides.readingKey,
            Readings.TotalCholesterol.readingKey,
            Readings.LDL_CHOLESTEROL.readingKey,
            Readings.HDL_CHOLESTEROL.readingKey,
            Readings.WaistCircumference.readingKey,
            Readings.PlateletCount.readingKey,
            Readings.SerumCreatinine.readingKey,
            Readings.FattyLiverUSGGrade.readingKey,
            Readings.RandomBloodGlucose.readingKey,
                // new BCA device readings added
            Readings.BodyFat.readingKey,
            Readings.Hydration.readingKey,
            Readings.MuscleMass.readingKey,
            Readings.Protein.readingKey,
            Readings.BoneMass.readingKey,
            Readings.VisceralFat.readingKey,
            Readings.BasalMetabolicRate.readingKey,
            Readings.MetabolicAge.readingKey,
            Readings.SubcutaneousFat.readingKey,
            Readings.SkeletalMuscle.readingKey,
                // new Spirometer readings added
            Readings.FVC.readingKey,
            Readings.FEV1FVC_RATIO.readingKey,
            Readings.AQI.readingKey,
            Readings.HUMIDITY.readingKey,
            Readings.TEMPERATURE.readingKey,
            Readings.CaloriesBurned.readingKey,
            Readings.SedentaryTime.readingKey,
            -> {
                "Average ${goalReadingData?.reading_name} reading $durationMsg is $avgReadingValue"
            }
            else -> {
                ""
            }
        }
    }
}