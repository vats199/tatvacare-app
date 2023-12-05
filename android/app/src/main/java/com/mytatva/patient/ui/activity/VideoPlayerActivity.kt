package com.mytatva.patient.ui.activity

import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.view.WindowManager
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.source.ProgressiveMediaSource
import com.google.android.exoplayer2.upstream.DefaultDataSourceFactory
import com.google.android.exoplayer2.util.Util
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.VideoPlayerActivityBinding
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.net.CookieManager
import java.util.*
import java.util.concurrent.TimeUnit


class VideoPlayerActivity : BaseActivity() {

    // used only when open from exercise explore more videos main and all list screen
    // to update goal logs for breathing/exercise
    private val goalMasterId by lazy {
        intent?.getStringExtra(Common.BundleKey.GOAL_MASTER_ID)
    }

    private val isExerciseVideo by lazy {
        intent?.getBooleanExtra(Common.BundleKey.IS_EXERCISE_VIDEO, false) ?: false
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }


    private val playerPosition by lazy {
        intent?.getLongExtra(Common.BundleKey.POSITION, 0L) ?: 0L
    }

    var downY: Float = 0.0f
    var upY: Float = 0.0f

    lateinit var newConfig: Configuration

    private val mediaUrl by lazy {
        intent?.getStringExtra(Common.BundleKey.MEDIA_URL) ?: ""
    }

    private val contentMasterId by lazy {
        intent?.getStringExtra(Common.BundleKey.CONTENT_ID) ?: ""
    }

    private val contentType by lazy {
        intent?.getStringExtra(Common.BundleKey.CONTENT_TYPE) ?: ""
    }

    companion object {
        var player: SimpleExoPlayer? = null
        val DEFAULT_COOKIE_MANAGER: CookieManager? = CookieManager()

        val TAG = VideoPlayerActivity::class.java.simpleName
    }

    override fun findFragmentPlaceHolder(): Int = 0

    lateinit var binding: VideoPlayerActivityBinding

    override fun createViewBinding(): View {
        binding = VideoPlayerActivityBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun inject(activityComponent: ActivityComponent) = activityComponent.inject(this)


    override fun onCreate(savedInstanceState: Bundle?) {
        this.window.setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        )
        super.onCreate(savedInstanceState)

        analytics.setScreenName(AnalyticsScreenNames.VideoPlayer)

        resumedTime = Calendar.getInstance().timeInMillis

        // setup cookie manager
        /*DEFAULT_COOKIE_MANAGER?.setCookiePolicy(CookiePolicy.ACCEPT_ORIGINAL_SERVER)
        if (CookieHandler.getDefault() != DEFAULT_COOKIE_MANAGER) {
            CookieHandler.setDefault(DEFAULT_COOKIE_MANAGER);
        }*/

        newConfig = resources.configuration
        setUpClickListeners()
        getArgumentsData()
        if (mediaUrl.isNotBlank()) {
            analytics.logEvent(
                if (isExerciseVideo)
                    analytics.USER_PLAY_VIDEO_EXERCISE
                else
                    analytics.USER_PLAY_VIDEO,
                Bundle().apply {
                    contentMasterId.let {
                        putString(analytics.PARAM_CONTENT_MASTER_ID, it)
                        putString(analytics.PARAM_CONTENT_TYPE, contentType)
                    }
                }, screenName = AnalyticsScreenNames.VideoPlayer
            )
            initializePlayer()
        }

        binding.playerView.setControllerVisibilityListener { visibility ->
            //binding.layoutTopControls.visibility = visibility
        }
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun getArgumentsData() {

    }

    private fun setUpClickListeners() {
        binding.imageViewToggle.setOnClickListener {
            toggleFullScreen()
        }
        binding.imageViewBack.setOnClickListener {
            goBack()
        }

        /*binding.imageViewPiP.isVisible =
            packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)

        binding.imageViewPiP.setOnClickListener {
            if (isInPictureInPictureMode) {

            } else {
                val ratio = Rational(2, 1)
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(ratio)
                    //.setSourceRectHint(sourceRectHint)
                    //.setAutoEnterEnabled(true)
                    .build()
                enterPictureInPictureMode(params)
            }
        }*/

    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration,
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        Log.d(TAG, "onPictureInPictureModeChanged $isInPictureInPictureMode")
        binding.imageViewPiP.isVisible = isInPictureInPictureMode.not()
    }

    lateinit var handler: Handler
    lateinit var runnable: Runnable
    private val MAX_PREVIEW_DURATION = 120000L

    private fun setPreviewHandler() {
        val totalDuration = player?.duration ?: 0
        handler = Handler(Looper.getMainLooper())
        runnable = Runnable {
            if (player != null && player!!.currentPosition >= MAX_PREVIEW_DURATION) {
                player?.stop()
                goBack()
            } else {
                handler.postDelayed(runnable, 1000)
            }
        }
        handler.postDelayed(runnable, 1000)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        this.newConfig = newConfig
        /*toggleFullScreen()*/
    }

    private fun toggleFullScreen() {
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
        }
    }

    var currentSeekPosition: Long = 0L

    private fun initializePlayer() {

        if (player == null) {
            player = SimpleExoPlayer.Builder(this).build()
            player?.addListener(object : Player.Listener {
                override fun onPlaybackStateChanged(playbackState: Int) {
                    if (playbackState == Player.STATE_ENDED) {

                    } else if (playbackState == Player.STATE_READY) {

                    }
                }
            })
        }

        binding.playerView.player = player

        val dataSourceFactory = DefaultDataSourceFactory(
            this,
            Util.getUserAgent(applicationContext, getString(R.string.app_name))
        )

        val videoSource =
            /*if (mediaUrl.endsWith("m3u8")) {
                HlsMediaSource.Factory(dataSourceFactory)
                    .createMediaSource(MediaItem.fromUri(Uri.parse(mediaUrl)))
            } else {*/
            ProgressiveMediaSource.Factory(dataSourceFactory)
                .createMediaSource(MediaItem.fromUri(Uri.parse(mediaUrl)))
        /*}*/

        // Prepare the player with the source.
        player!!.playWhenReady = true
        player!!.setMediaSource(videoSource, false)
        player!!.prepare()
//        startServicePlayer(uriPath)

        player!!.seekTo(playerPosition)

    }

    var intents: Intent? = null
    /* private fun startServicePlayer(uriPath: String) {
         intents = Intent(this, AudioPlayerService::class.java)
         intents?.putExtra(Common.URL, uriPath)
         if (audioVideoContent != null) {
             audioVideoContent?.data?.title.let {
                 intents?.putExtra(Common.TITLE, it)
             }
         } else if (chapterDetails != null) {
             chapterDetails?.data?.track?.title?.let {
                 intents?.putExtra(Common.TITLE, it)
             }
         }
         Util.startForegroundService(this, intents)
     }*/

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onStart() {
        super.onStart()
        Log.d(TAG, "onStart")
    }

    override fun onStop() {
        super.onStop()
        Log.d(TAG, "onStop")
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume")
        //resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "onPause")
        //updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.USER_DURATION_OF_VIDEO, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
            putString(analytics.PARAM_CONTENT_MASTER_ID, contentMasterId)
            putString(analytics.PARAM_CONTENT_TYPE, contentType)
        }, screenName = AnalyticsScreenNames.VideoPlayer)

        // update goal log with API if video played from exercises main or all list tab
        if (goalMasterId.isNullOrBlank().not()) {
            val diffInMin = TimeUnit.MILLISECONDS.toMinutes(diffInMs).toInt()
            updateGoalLogs(diffInMin.toString())
        }
    }

    override fun onDestroy() {
        Log.d(TAG, "onDestroy")

        releasePlayer()
        updateScreenTimeDurationInAnalytics()

        intents?.let { stopService(intents) }

        if (::handler.isInitialized && handler.hasCallbacks(runnable))
            handler.removeCallbacks(runnable)

        super.onDestroy()

        //unregister download receiver
        /*unregisterReceiver(onComplete)*/
//        unregisterReceiver(onNotificationClick)

    }

    private fun releasePlayer() {
        if (player != null) {
            player?.stop()
            player!!.release()
            player = null
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateGoalLogs(durationInMinutes: String) {
        val apiRequest = ApiRequest().apply {
            goal_id = goalMasterId
            achieved_value = durationInMinutes
            //patient_sub_goal_id = selectedExerciseId
            achieved_datetime = DateTimeFormatter.date(Calendar.getInstance().time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
        }
        goalReadingViewModel.updateGoalLogs(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    /*private fun observeLiveData() {
        goalReadingViewModel.updateGoalLogsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }*/

}