package com.mytatva.patient.ui.activity

import android.Manifest
import android.app.AppOpsManager
import android.app.PictureInPictureParams
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.graphics.Point
import android.media.AudioManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.preference.PreferenceManager
import android.util.Log
import android.util.Rational
import android.view.Display
import android.view.MenuItem
import android.view.View
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import androidx.lifecycle.Lifecycle
import com.google.android.material.snackbar.Snackbar
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.databinding.VideoActivityBinding
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.DragViewHelper.cornerAnimationFromCenter
import com.mytatva.patient.utils.twilio.CameraCapturerCompat
import com.twilio.audioswitch.AudioDevice
import com.twilio.audioswitch.AudioDevice.*
import com.twilio.audioswitch.AudioSwitch
import com.twilio.video.*
import com.twilio.video.ktx.Video.connect
import com.twilio.video.ktx.createLocalAudioTrack
import com.twilio.video.ktx.createLocalVideoTrack
import tvi.webrtc.VideoSink
import kotlin.properties.Delegates

class VideoActivity : BaseActivity() {

    companion object {
        const val PREF_AUDIO_CODEC = "audio_codec"
        const val PREF_AUDIO_CODEC_DEFAULT = OpusCodec.NAME
        const val PREF_VIDEO_CODEC = "video_codec"
        const val PREF_VIDEO_CODEC_DEFAULT = Vp8Codec.NAME
        const val PREF_SENDER_MAX_AUDIO_BITRATE = "sender_max_audio_bitrate"
        const val PREF_SENDER_MAX_AUDIO_BITRATE_DEFAULT = "0"
        const val PREF_SENDER_MAX_VIDEO_BITRATE = "sender_max_video_bitrate"
        const val PREF_SENDER_MAX_VIDEO_BITRATE_DEFAULT = "0"
        const val PREF_VP8_SIMULCAST = "vp8_simulcast"
        const val PREF_VP8_SIMULCAST_DEFAULT = false
        const val PREF_ENABLE_AUTOMATIC_SUBSCRIPTION = "enable_automatic_subscription"
        const val PREF_ENABLE_AUTOMATIC_SUBCRIPTION_DEFAULT = true

        val VIDEO_CODEC_NAMES = arrayOf(Vp8Codec.NAME, H264Codec.NAME, Vp9Codec.NAME)

        val AUDIO_CODEC_NAMES =
            arrayOf(IsacCodec.NAME, OpusCodec.NAME, PcmaCodec.NAME, PcmuCodec.NAME, G722Codec.NAME)

        var isPictureInPictureModeActive = false

        const val ACTION_FINISH_ACTIVITY = "finish_activity"
    }

    private val broadCastReceiver: BroadcastReceiver by lazy {
        object : BroadcastReceiver() {
            override fun onReceive(p0: Context?, intent: Intent?) {
                Log.d(TAG, "onReceive")
                intent?.let {
                    Log.d(TAG, "action :: ${it.action}")
                    if (it.action.equals(ACTION_FINISH_ACTIVITY)) {
                        runOnUiThread {
                            this@VideoActivity.finishAndRemoveTask()
                        }
                    }
                }
            }
        }
    }

    private val CAMERA_MIC_PERMISSION_REQUEST_CODE = 1
    private val TAG = "VideoActivity"
    private val CAMERA_PERMISSION_INDEX = 0
    private val MIC_PERMISSION_INDEX = 1


    /** The arguments to be used for Picture-in-Picture mode.  */
    @RequiresApi(Build.VERSION_CODES.O)
    private val mPictureInPictureParamsBuilder = PictureInPictureParams.Builder()

    /*
     * You must provide a Twilio Access Token to connect to the Video service
     */
    /*private val TWILIO_ACCESS_TOKEN = com.mytatva.patient.BuildConfig.TWILIO_ACCESS_TOKEN
    private val ACCESS_TOKEN_SERVER = com.mytatva.patient.BuildConfig.TWILIO_ACCESS_TOKEN_SERVER*/

    /*
     * Access token used to connect. This field will be set either from the console generated token
     * or the request to the token server.
     */
    //private lateinit var accessToken: String
    private val accessToken: String by lazy {
        intent?.getStringExtra(Common.BundleKey.ACCESS_TOKEN) ?: ""
    }

    private val twilioRoomName: String by lazy {
        intent?.getStringExtra(Common.BundleKey.ROOM_NAME) ?: ""
    }

    private val twilioRoomId: String by lazy {
        intent?.getStringExtra(Common.BundleKey.ROOM_ID) ?: ""
    }

    private val twilioRoomSid: String by lazy {
        intent?.getStringExtra(Common.BundleKey.ROOM_SID) ?: ""
    }

    private val doctorHcName: String by lazy {
        intent?.getStringExtra(Common.BundleKey.DOCTOR_HC_NAME) ?: ""
    }


    /*
     * A Room represents communication between a local participant and one or more participants.
     */
    private var room: Room? = null
    private var localParticipant: LocalParticipant? = null

    /*
     * AudioCodec and VideoCodec represent the preferred codec for encoding and decoding audio and
     * video.
     */
    private val audioCodec: AudioCodec
        get() {
            val audioCodecName = sharedPreferences.getString(
                /*SettingsActivity.*/PREF_AUDIO_CODEC,
                /*SettingsActivity.*/PREF_AUDIO_CODEC_DEFAULT
            )

            return when (audioCodecName) {
                IsacCodec.NAME -> IsacCodec()
                OpusCodec.NAME -> OpusCodec()
                PcmaCodec.NAME -> PcmaCodec()
                PcmuCodec.NAME -> PcmuCodec()
                G722Codec.NAME -> G722Codec()
                else -> OpusCodec()
            }
        }
    private val videoCodec: VideoCodec
        get() {
            val videoCodecName = sharedPreferences.getString(
                /*SettingsActivity.*/PREF_VIDEO_CODEC,
                /*SettingsActivity.*/PREF_VIDEO_CODEC_DEFAULT
            )

            return when (videoCodecName) {
                Vp8Codec.NAME -> {
                    val simulcast = sharedPreferences.getBoolean(
                        /*SettingsActivity.*/PREF_VP8_SIMULCAST,
                        /*SettingsActivity.*/PREF_VP8_SIMULCAST_DEFAULT
                    )
                    Vp8Codec(simulcast)
                }

                H264Codec.NAME -> H264Codec()
                Vp9Codec.NAME -> Vp9Codec()
                else -> Vp8Codec()
            }
        }

    private val enableAutomaticSubscription: Boolean
        get() {
            return sharedPreferences.getBoolean(
                /*SettingsActivity.*/PREF_ENABLE_AUTOMATIC_SUBSCRIPTION,
                /*SettingsActivity.*/PREF_ENABLE_AUTOMATIC_SUBCRIPTION_DEFAULT
            )
        }

    /*
     * Encoding parameters represent the sender side bandwidth constraints.
     */
    private val encodingParameters: EncodingParameters
        get() {
            val defaultMaxAudioBitrate = /*SettingsActivity.*/PREF_SENDER_MAX_AUDIO_BITRATE_DEFAULT
            val defaultMaxVideoBitrate = /*SettingsActivity.*/PREF_SENDER_MAX_VIDEO_BITRATE_DEFAULT
            val maxAudioBitrate = Integer.parseInt(
                sharedPreferences.getString(
                    /*SettingsActivity.*/PREF_SENDER_MAX_AUDIO_BITRATE, defaultMaxAudioBitrate
                )
                    ?: defaultMaxAudioBitrate
            )
            val maxVideoBitrate = Integer.parseInt(
                sharedPreferences.getString(
                    /*SettingsActivity.*/PREF_SENDER_MAX_VIDEO_BITRATE, defaultMaxVideoBitrate
                )
                    ?: defaultMaxVideoBitrate
            )

            return EncodingParameters(maxAudioBitrate, maxVideoBitrate)
        }

    /*
     * Room events listener
     */
    private val roomListener = object : Room.Listener {
        override fun onConnected(room: Room) {
            Log.d(TAG, "onConnected: ")
            localParticipant = room.localParticipant
            //publishTrackForLocalParticipant()
            binding.contentVideoView.videoStatusTextView.text = "Connected to ${room.name}"
            //showErrorMessage("Connected to ${room.name}")
            title = room.name

            // Only one participant is supported
            room.remoteParticipants.firstOrNull()?.let { addRemoteParticipant(it) }
        }

        override fun onReconnected(room: Room) {
            Log.d(TAG, "onReconnected: ")
            binding.contentVideoView.videoStatusTextView.text = "Connected to ${room.name}"
            //showErrorMessage("Connected to ${room.name}")
            binding.contentVideoView.reconnectingProgressBar.visibility = View.GONE
        }

        override fun onReconnecting(room: Room, twilioException: TwilioException) {
            Log.d(TAG, "onReconnecting: ")
            binding.contentVideoView.videoStatusTextView.text = "Reconnecting to ${room.name}"
            //showErrorMessage("Reconnecting to ${room.name}")
            binding.contentVideoView.reconnectingProgressBar.visibility = View.VISIBLE
        }

        override fun onConnectFailure(room: Room, e: TwilioException) {
            Log.d(TAG, "onConnectFailure: ")
            binding.contentVideoView.videoStatusTextView.text = "Failed to connect ${e.message}"
            //showErrorMessage("Failed to connect")
            audioSwitch.deactivate()
            initializeUI()
        }

        override fun onDisconnected(room: Room, e: TwilioException?) {
            Log.d(TAG, "onDisconnected: ")
            localParticipant = null
            binding.contentVideoView.videoStatusTextView.text = "Disconnected from ${room.name}"
            //showErrorMessage("Disconnected from ${room.name}")
            binding.contentVideoView.reconnectingProgressBar.visibility = View.GONE
            this@VideoActivity.room = null
            // Only reinitialize the UI if disconnect was not called from onDestroy()
            if (!disconnectedFromOnDestroy) {
                audioSwitch.deactivate()
                initializeUI()
                moveLocalVideoToPrimaryView()
            }
        }

        override fun onParticipantConnected(room: Room, participant: RemoteParticipant) {
            Log.d(TAG, "onParticipantConnected: ")
            addRemoteParticipant(participant)
        }

        override fun onParticipantDisconnected(room: Room, participant: RemoteParticipant) {
            Log.d(TAG, "onParticipantDisconnected: ")
            finish()
            //removeRemoteParticipant(participant)
        }

        override fun onRecordingStarted(room: Room) {
            /*
             * Indicates when media shared to a Room is being recorded. Note that
             * recording is only available in our Group Rooms developer preview.
             */
            Log.d(TAG, "onRecordingStarted")
        }

        override fun onRecordingStopped(room: Room) {
            /*
             * Indicates when media shared to a Room is no longer being recorded. Note that
             * recording is only available in our Group Rooms developer preview.
             */
            Log.d(TAG, "onRecordingStopped")
        }
    }

    /*
     * RemoteParticipant events listener
     */
    private val participantListener = object : RemoteParticipant.Listener {
        override fun onAudioTrackPublished(
            remoteParticipant: RemoteParticipant,
            remoteAudioTrackPublication: RemoteAudioTrackPublication,
        ) {
            Log.i(
                TAG,
                "onAudioTrackPublished: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteAudioTrackPublication: sid=${remoteAudioTrackPublication.trackSid}, " + "enabled=${remoteAudioTrackPublication.isTrackEnabled}, " + "subscribed=${remoteAudioTrackPublication.isTrackSubscribed}, " + "name=${remoteAudioTrackPublication.trackName}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onAudioTrackAdded"
        }

        override fun onAudioTrackUnpublished(
            remoteParticipant: RemoteParticipant,
            remoteAudioTrackPublication: RemoteAudioTrackPublication,
        ) {
            Log.i(
                TAG,
                "onAudioTrackUnpublished: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteAudioTrackPublication: sid=${remoteAudioTrackPublication.trackSid}, " + "enabled=${remoteAudioTrackPublication.isTrackEnabled}, " + "subscribed=${remoteAudioTrackPublication.isTrackSubscribed}, " + "name=${remoteAudioTrackPublication.trackName}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onAudioTrackRemoved"
        }

        override fun onDataTrackPublished(
            remoteParticipant: RemoteParticipant,
            remoteDataTrackPublication: RemoteDataTrackPublication,
        ) {
            Log.i(
                TAG,
                "onDataTrackPublished: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteDataTrackPublication: sid=${remoteDataTrackPublication.trackSid}, " + "enabled=${remoteDataTrackPublication.isTrackEnabled}, " + "subscribed=${remoteDataTrackPublication.isTrackSubscribed}, " + "name=${remoteDataTrackPublication.trackName}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onDataTrackPublished"
        }

        override fun onDataTrackUnpublished(
            remoteParticipant: RemoteParticipant,
            remoteDataTrackPublication: RemoteDataTrackPublication,
        ) {
            Log.i(
                TAG,
                "onDataTrackUnpublished: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteDataTrackPublication: sid=${remoteDataTrackPublication.trackSid}, " + "enabled=${remoteDataTrackPublication.isTrackEnabled}, " + "subscribed=${remoteDataTrackPublication.isTrackSubscribed}, " + "name=${remoteDataTrackPublication.trackName}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onDataTrackUnpublished"
        }

        override fun onVideoTrackPublished(
            remoteParticipant: RemoteParticipant,
            remoteVideoTrackPublication: RemoteVideoTrackPublication,
        ) {
            Log.i(
                TAG,
                "onVideoTrackPublished: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteVideoTrackPublication: sid=${remoteVideoTrackPublication.trackSid}, " + "enabled=${remoteVideoTrackPublication.isTrackEnabled}, " + "subscribed=${remoteVideoTrackPublication.isTrackSubscribed}, " + "name=${remoteVideoTrackPublication.trackName}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onVideoTrackPublished"
        }

        override fun onVideoTrackUnpublished(
            remoteParticipant: RemoteParticipant,
            remoteVideoTrackPublication: RemoteVideoTrackPublication,
        ) {
            Log.i(
                TAG,
                "onVideoTrackUnpublished: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteVideoTrackPublication: sid=${remoteVideoTrackPublication.trackSid}, " + "enabled=${remoteVideoTrackPublication.isTrackEnabled}, " + "subscribed=${remoteVideoTrackPublication.isTrackSubscribed}, " + "name=${remoteVideoTrackPublication.trackName}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onVideoTrackUnpublished"
        }

        override fun onAudioTrackSubscribed(
            remoteParticipant: RemoteParticipant,
            remoteAudioTrackPublication: RemoteAudioTrackPublication,
            remoteAudioTrack: RemoteAudioTrack,
        ) {
            Log.i(
                TAG,
                "onAudioTrackSubscribed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteAudioTrack: enabled=${remoteAudioTrack.isEnabled}, " + "playbackEnabled=${remoteAudioTrack.isPlaybackEnabled}, " + "name=${remoteAudioTrack.name}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onAudioTrackSubscribed"
        }

        override fun onAudioTrackUnsubscribed(
            remoteParticipant: RemoteParticipant,
            remoteAudioTrackPublication: RemoteAudioTrackPublication,
            remoteAudioTrack: RemoteAudioTrack,
        ) {
            Log.i(
                TAG,
                "onAudioTrackUnsubscribed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteAudioTrack: enabled=${remoteAudioTrack.isEnabled}, " + "playbackEnabled=${remoteAudioTrack.isPlaybackEnabled}, " + "name=${remoteAudioTrack.name}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onAudioTrackUnsubscribed"
        }

        override fun onAudioTrackSubscriptionFailed(
            remoteParticipant: RemoteParticipant,
            remoteAudioTrackPublication: RemoteAudioTrackPublication,
            twilioException: TwilioException,
        ) {
            Log.i(
                TAG,
                "onAudioTrackSubscriptionFailed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteAudioTrackPublication: sid=${remoteAudioTrackPublication.trackSid}, " + "name=${remoteAudioTrackPublication.trackName}]" + "[TwilioException: code=${twilioException.code}, " + "message=${twilioException.message}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onAudioTrackSubscriptionFailed"
        }

        override fun onDataTrackSubscribed(
            remoteParticipant: RemoteParticipant,
            remoteDataTrackPublication: RemoteDataTrackPublication,
            remoteDataTrack: RemoteDataTrack,
        ) {
            Log.i(
                TAG,
                "onDataTrackSubscribed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteDataTrack: enabled=${remoteDataTrack.isEnabled}, " + "name=${remoteDataTrack.name}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onDataTrackSubscribed"
        }

        override fun onDataTrackUnsubscribed(
            remoteParticipant: RemoteParticipant,
            remoteDataTrackPublication: RemoteDataTrackPublication,
            remoteDataTrack: RemoteDataTrack,
        ) {
            Log.i(
                TAG,
                "onDataTrackUnsubscribed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteDataTrack: enabled=${remoteDataTrack.isEnabled}, " + "name=${remoteDataTrack.name}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onDataTrackUnsubscribed"
        }

        override fun onDataTrackSubscriptionFailed(
            remoteParticipant: RemoteParticipant,
            remoteDataTrackPublication: RemoteDataTrackPublication,
            twilioException: TwilioException,
        ) {
            Log.i(
                TAG,
                "onDataTrackSubscriptionFailed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteDataTrackPublication: sid=${remoteDataTrackPublication.trackSid}, " + "name=${remoteDataTrackPublication.trackName}]" + "[TwilioException: code=${twilioException.code}, " + "message=${twilioException.message}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onDataTrackSubscriptionFailed"
        }

        override fun onVideoTrackSubscribed(
            remoteParticipant: RemoteParticipant,
            remoteVideoTrackPublication: RemoteVideoTrackPublication,
            remoteVideoTrack: RemoteVideoTrack,
        ) {
            Log.i(
                TAG,
                "onVideoTrackSubscribed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteVideoTrack: enabled=${remoteVideoTrack.isEnabled}, " + "name=${remoteVideoTrack.name}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onVideoTrackSubscribed"
            addRemoteParticipantVideo(remoteVideoTrack)
        }

        override fun onVideoTrackUnsubscribed(
            remoteParticipant: RemoteParticipant,
            remoteVideoTrackPublication: RemoteVideoTrackPublication,
            remoteVideoTrack: RemoteVideoTrack,
        ) {
            Log.i(
                TAG,
                "onVideoTrackUnsubscribed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteVideoTrack: enabled=${remoteVideoTrack.isEnabled}, " + "name=${remoteVideoTrack.name}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onVideoTrackUnsubscribed"
            removeParticipantVideo(remoteVideoTrack)
        }

        override fun onVideoTrackSubscriptionFailed(
            remoteParticipant: RemoteParticipant,
            remoteVideoTrackPublication: RemoteVideoTrackPublication,
            twilioException: TwilioException,
        ) {
            Log.i(
                TAG,
                "onVideoTrackSubscriptionFailed: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteVideoTrackPublication: sid=${remoteVideoTrackPublication.trackSid}, " + "name=${remoteVideoTrackPublication.trackName}]" + "[TwilioException: code=${twilioException.code}, " + "message=${twilioException.message}]"
            )
            binding.contentVideoView.videoStatusTextView.text = "onVideoTrackSubscriptionFailed"
            Snackbar.make(
                binding.connectActionFab,
                "Failed to subscribe to ${remoteParticipant.identity}",
                Snackbar.LENGTH_LONG
            ).show()
        }

        override fun onAudioTrackEnabled(
            remoteParticipant: RemoteParticipant,
            remoteAudioTrackPublication: RemoteAudioTrackPublication,
        ) {
            binding.textViewLabelMuteStatus.isVisible = false
            Log.i(
                TAG,
                "onAudioTrackEnabled: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteAudioTrackPublication: sid=${remoteAudioTrackPublication.trackSid}, " + "enabled=${remoteAudioTrackPublication.isTrackEnabled}, " + "subscribed=${remoteAudioTrackPublication.isTrackSubscribed}, " + "name=${remoteAudioTrackPublication.trackName}]"
            )
        }

        override fun onAudioTrackDisabled(
            remoteParticipant: RemoteParticipant,
            remoteAudioTrackPublication: RemoteAudioTrackPublication,
        ) {
            binding.textViewLabelMuteStatus.isVisible = true
            binding.textViewLabelMuteStatus.text = "$doctorHcName muted the call"
            Log.i(
                TAG,
                "onAudioTrackDisabled: " + "[RemoteParticipant: identity=${remoteParticipant.identity}], " + "[RemoteAudioTrackPublication: sid=${remoteAudioTrackPublication.trackSid}, " + "enabled=${remoteAudioTrackPublication.isTrackEnabled}, " + "subscribed=${remoteAudioTrackPublication.isTrackSubscribed}, " + "name=${remoteAudioTrackPublication.trackName}]"
            )
        }

        override fun onVideoTrackEnabled(
            remoteParticipant: RemoteParticipant,
            remoteVideoTrackPublication: RemoteVideoTrackPublication,
        ) {
        }

        override fun onVideoTrackDisabled(
            remoteParticipant: RemoteParticipant,
            remoteVideoTrackPublication: RemoteVideoTrackPublication,
        ) {
        }

    }

    private var localAudioTrack: LocalAudioTrack? = null
    private var localVideoTrack: LocalVideoTrack? = null
    private var videoAlertDialog: AlertDialog? = null
    private val cameraCapturerCompat by lazy {
        CameraCapturerCompat(this, CameraCapturerCompat.Source.FRONT_CAMERA)
    }
    private val sharedPreferences by lazy {
        PreferenceManager.getDefaultSharedPreferences(this@VideoActivity)
    }

    /*
     * Audio management
     */
    private val audioSwitch by lazy {
        AudioSwitch(
            applicationContext,
            preferredDeviceList = listOf(
                BluetoothHeadset::class.java,
                WiredHeadset::class.java,
                Speakerphone::class.java,
                Earpiece::class.java
            )
        )
    }
    private var savedVolumeControlStream by Delegates.notNull<Int>()
    private var audioDeviceMenuItem: MenuItem? = null

    private var participantIdentity: String? = null
    private lateinit var localVideoView: VideoSink
    private var disconnectedFromOnDestroy = false
    private var isSpeakerPhoneEnabled = true

    lateinit var binding: VideoActivityBinding

    override fun findFragmentPlaceHolder(): Int {
        return 0
    }

    override fun createViewBinding(): View {
        binding = VideoActivityBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun inject(activityComponent: ActivityComponent) {
        activityComponent.inject(this)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        Log.d(TAG, "onConfigurationChanged: ")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate: ")
        //setContentView(R.layout.activity_video)

        /*
         * Set local video view to primary view
         */
        localVideoView = binding.contentVideoView.thumbnailVideoView//primaryVideoView


        /*
         * Enable changing the volume using the up/down keys during a conversation
         */
        savedVolumeControlStream = volumeControlStream
        volumeControlStream = AudioManager.STREAM_VOICE_CALL

        /*
         * Set access token
         */
//        setAccessToken()

        /*
         * Check camera and microphone permissions. Also, request for bluetooth
         * permissions for enablement of bluetooth audio routing.
         */
        if (!checkPermissionForCameraAndMicrophone()) {
            requestPermissionForCameraMicrophoneAndBluetooth()
        } else {
            audioSwitch.start { audioDevices, audioDevice ->
                updateAudioDeviceIcon(audioDevice)
            }
            createAudioAndVideoTracks()
        }
        /*
         * Set the initial state of the UI
         */
        initializeUI()

        binding.layoutHeader.imageViewToolbarBack.setOnClickListener {
            goBack()
        }

        binding.contentVideoView.localVideoContainer.cornerAnimationFromCenter(
            this,
            binding.contentVideoView.container, true
        )
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume: ")
    }

    private fun setUpLocalVideoTrack() {
        /*
         * If the local video track was released when the app was put in the background, recreate.
         */
        localVideoTrack = if (localVideoTrack == null && checkPermissionForCameraAndMicrophone()) {
            createLocalVideoTrack(this, true, cameraCapturerCompat)
        } else {
            localVideoTrack
        }
        localVideoTrack?.addSink(localVideoView)

        publishTrackForLocalParticipant()

        //set disable default as per button state
        if (!binding.localVideoActionFab.isSelected) {
            disableVideo()
        }

        with(binding.contentVideoView) {
            thumbnailVideoView.videoScaleType = VideoScaleType.ASPECT_FIT

            thumbnailVideoView.mirror =
                cameraCapturerCompat.cameraSource == CameraCapturerCompat.Source.FRONT_CAMERA
            localVideoContainer.clipToOutline = true
        }
    }

    private fun publishTrackForLocalParticipant() {
        /*
         * If connected to a Room then share the local video track.
         */
        localVideoTrack?.let { localParticipant?.publishTrack(it) }

        /*
         * Update encoding parameters if they have changed.
         */
        localParticipant?.setEncodingParameters(encodingParameters)
    }

    override fun onPause() {
        Log.d(TAG, "onPause: ")

        super.onPause()
    }

    override fun onStart() {
        super.onStart()
        Log.d(TAG, "onStart: ")

        //binding.localVideoActionFab.isSelected = true
        if (checkPermissionForCameraAndMicrophone()) setUpLocalVideoTrack()

        /*
         * Update reconnecting UI
         */
        room?.let {
            binding.contentVideoView.reconnectingProgressBar.visibility =
                if (it.state != Room.State.RECONNECTING) View.GONE else View.VISIBLE
            binding.contentVideoView.videoStatusTextView.text = "Connected to ${it.name}"
        }

        /*
         * registerReceiver to finish activity from outside
         */
        registerReceiver(broadCastReceiver, IntentFilter(ACTION_FINISH_ACTIVITY))
    }

    override fun onStop() {
        /*
        * If this local video track is being shared in a Room, remove from local
        * participant before releasing the video track. Participants will be notified that
        * the track has been removed.
        */
        localVideoTrack?.let { localParticipant?.unpublishTrack(it) }

        /*
         * Release the local video track before going in the background. This ensures that the
         * camera can be used by other applications while this app is in the background.
         */
        localVideoTrack?.release()
        localVideoTrack = null

        /*
         * unregisterReceiver
         */
        unregisterReceiver(broadCastReceiver)

        super.onStop()
        Log.d(TAG, "onStop: ")
    }

    override fun onDestroy() {
        isPictureInPictureModeActive = false
        Log.d(TAG, "onDestroy: ")
        /*
         * Tear down audio management and restore previous volume stream
         */
        audioSwitch.stop()
        volumeControlStream = savedVolumeControlStream

        /*
         * Always disconnect from the room before leaving the Activity to
         * ensure any memory allocated to the Room resource is freed.
         */
        room?.disconnect()
        disconnectedFromOnDestroy = true

        /*
         * Release the local audio and video tracks ensuring any memory allocated to audio
         * or video is freed.
         */
        localAudioTrack?.release()
        localVideoTrack?.release()
        Log.e(VideoActivity::class.java.simpleName, "onDestroy -> Call")
        super.onDestroy()
    }

    //commented
    /*override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater = menuInflater
        inflater.inflate(R.menu.menu, menu)
        audioDeviceMenuItem = menu.findItem(R.id.menu_audio_device)
        // AudioSwitch has already started and thus notified of the initial selected device
        // so we need to updates the UI
        updateAudioDeviceIcon(audioSwitch.selectedAudioDevice)
        return true
    }*/

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == CAMERA_MIC_PERMISSION_REQUEST_CODE) {
            /*
             * The first two permissions are Camera & Microphone, bluetooth isn't required but
             * enabling it enables bluetooth audio routing functionality.
             */
            val cameraAndMicPermissionGranted =
                ((PackageManager.PERMISSION_GRANTED == grantResults[CAMERA_PERMISSION_INDEX]) and (PackageManager.PERMISSION_GRANTED == grantResults[MIC_PERMISSION_INDEX]))


            if (cameraAndMicPermissionGranted) {
                /*
                * Due to bluetooth permissions being requested at the same time as camera and mic
                * permissions, AudioSwitch should be started after providing the user the option
                * to grant the necessary permissions for bluetooth.
                */
                audioSwitch.start { audioDevices, audioDevice -> updateAudioDeviceIcon(audioDevice) }
                createAudioAndVideoTracks()
                Handler(Looper.getMainLooper()).postDelayed({ setUpLocalVideoTrack() }, 500)
                Log.d(TAG, "onRequestPermissionsResult: granted")
            } else {
                Toast.makeText(this, R.string.permissions_needed, Toast.LENGTH_LONG).show()
                Log.d(TAG, "onRequestPermissionsResult: denied")
            }
        }
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            //commented
            /*R.id.menu_settings -> startActivity(Intent(this, SettingsActivity::class.java))
            R.id.menu_audio_device -> showAudioDevices()*/
        }
        return true
    }

    private fun checkPermissions(permissions: Array<String>): Boolean {
        var shouldCheck = true
        for (permission in permissions) {
            shouldCheck =
                shouldCheck and (PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(
                    this,
                    permission
                ))
        }
        return shouldCheck
    }

    private fun requestPermissions(permissions: Array<String>) {
        var displayRational = false
        for (permission in permissions) {
            displayRational =
                displayRational or ActivityCompat.shouldShowRequestPermissionRationale(
                    this,
                    permission
                )
        }
        if (displayRational) {
            Toast.makeText(this, R.string.permissions_needed, Toast.LENGTH_LONG).show()
        } else {
            ActivityCompat.requestPermissions(this, permissions, CAMERA_MIC_PERMISSION_REQUEST_CODE)
        }
    }

    private fun checkPermissionForCameraAndMicrophone(): Boolean {
        return checkPermissions(
            arrayOf(
                Manifest.permission.CAMERA,
                Manifest.permission.RECORD_AUDIO
            )
        )
    }

    private fun requestPermissionForCameraMicrophoneAndBluetooth() {
        // open below comment while target to VersionCode S
        val permissionsList: Array<String> = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(
                Manifest.permission.CAMERA,
                Manifest.permission.RECORD_AUDIO,
                Manifest.permission.BLUETOOTH_CONNECT
            )
        } else {
            arrayOf(Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)
        }
        requestPermissions(permissionsList)
    }

    private fun createAudioAndVideoTracks() {
        // Share your microphone
        localAudioTrack = createLocalAudioTrack(this, true)

        // Share your camera
        localVideoTrack = createLocalVideoTrack(this, true, cameraCapturerCompat)

        Handler(Looper.getMainLooper()).postDelayed({
            //showErrorMessage("$twilioRoomName")
            connectToRoom(/*"MyTatvaTestRoom"*/twilioRoomName)
        }, 200)

        // disable video by default
        disableVideo()
    }

    /*private fun setAccessToken() {
        if (!BuildConfig.USE_TOKEN_SERVER) {

            *//* OPTION 1 - Generate an access token from the getting started portal
            * https://www.twilio.com/console/video/dev-tools/testing-tools and add
            * the variable TWILIO_ACCESS_TOKEN setting it equal to the access token
            * string in your local.properties file.*//*

            //this.accessToken = TWILIO_ACCESS_TOKEN
        } else {

            *//* OPTION 2 - Retrieve an access token from your own web app.
            * Add the variable ACCESS_TOKEN_SERVER assigning it to the url of your
            * token server and the variable USE_TOKEN_SERVER=true to your
            * local.properties file.*//*

            retrieveAccessTokenfromServer()
        }
    }*/

    private fun connectToRoom(roomName: String) {
        audioSwitch.activate()

        /*val accessTokenTemp="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2E3ODA4YjkzYTBjMDBkOWQ0NTE4ZDNkM2M4ZTI2ZTc5LTE2NTA4ODU3NzEiLCJncmFudHMiOnsiaWRlbnRpdHkiOiI5NzM4M2E3Ny01N2MwLTExZWMtYjMwZC0yOGIyMDNmNmNhMTJfMC4zNjE2NDU3MjA4MDcwMjIwNl84MTE0Iiwidm9pY2UiOnsiaW5jb21pbmciOnsiYWxsb3ciOnRydWV9LCJvdXRnb2luZyI6eyJhcHBsaWNhdGlvbl9zaWQiOiJlZDExZTdiYmVjYTk0Y2UyN2YzNDdiYTA2ZjIzMzBiMyJ9LCJwdXNoX2NyZWRlbnRpYWxfc2lkIjoiQ1IzY2VkYjU2OGJhY2QwNjJiYmQzZDg3NmFjMDhiZTViNCJ9LCJ2aWRlbyI6eyJyb29tIjoiY2FiYWM4YjVjNDYzMTFlY2E1NjdmZTdlNzllNjE3YmMifX0sImlhdCI6MTY1MDg4NTc3MSwiZXhwIjoxNjUwODg5MzcxLCJpc3MiOiJTS2E3ODA4YjkzYTBjMDBkOWQ0NTE4ZDNkM2M4ZTI2ZTc5Iiwic3ViIjoiQUNiOWRmYWU4NjVkZjc5MTEyNWQ4NjNkMjY5OWI4MzY4ZiJ9.ACFOhBCHCVh5rOhboIJ5_ABlpK6NEi5dKWE2BWIT9v4"

        val rromNameTemp="cabac8b5c46311eca567fe7e79e617bc"*/

        room = connect(this, accessToken, roomListener) {
            roomName(/*rromNameTemp*/roomName)
            /*
             * Add local audio track to connect options to share with participants.
             */
            audioTracks(listOf(localAudioTrack))
            /*
             * Add local video track to connect options to share with participants.
             */
            videoTracks(listOf(localVideoTrack))

            /*
             * Set the preferred audio and video codec for media.
             */
            preferAudioCodecs(listOf(audioCodec))
            preferVideoCodecs(listOf(videoCodec))

            /*
             * Set the sender side encoding parameters.
             */
            encodingParameters(encodingParameters)

            /*
             * Toggles automatic track subscription. If set to false, the LocalParticipant will receive
             * notifications of track publish events, but will not automatically subscribe to them. If
             * set to true, the LocalParticipant will automatically subscribe to tracks as they are
             * published. If unset, the default is true. Note: This feature is only available for Group
             * Rooms. Toggling the flag in a P2P room does not modify subscription behavior.
             */
            enableAutomaticSubscription(enableAutomaticSubscription)
        }
        //setDisconnectAction()
    }

    /*
     * The initial state when there is no active room.
     */
    private fun initializeUI() {
        with(binding) {
            connectActionFab.setImageDrawable(
                ContextCompat.getDrawable(
                    this@VideoActivity,
                    R.drawable.ic_back
                )
            )
            //connectActionFab.show()
            //connectActionFab.setOnClickListener(connectActionClickListener())
            switchCameraActionFab.isVisible = true
            switchCameraActionFab.setOnClickListener(switchCameraClickListener())
            localVideoActionFab.isVisible = true
            localVideoActionFab.setOnClickListener(localVideoClickListener())
            muteActionFab.isVisible = true
            muteActionFab.setOnClickListener(muteClickListener())
            imageViewEnd.setOnClickListener { finish() }
        }
    }

    private fun disableVideo() {
        localVideoTrack?.let {
            with(binding) {
                val enable = false
                it.enable(enable)
                binding.localVideoActionFab.isSelected = !enable
            }
        }
    }

    /*
     * Show the current available audio devices.
     */
    private fun showAudioDevices() {
        val availableAudioDevices = audioSwitch.availableAudioDevices

        audioSwitch.selectedAudioDevice?.let { selectedDevice ->
            val selectedDeviceIndex = availableAudioDevices.indexOf(selectedDevice)
            val audioDeviceNames = ArrayList<String>()

            for (a in availableAudioDevices) {
                audioDeviceNames.add(a.name)
            }

            AlertDialog.Builder(this).setTitle(R.string.room_screen_select_device)
                .setSingleChoiceItems(
                    audioDeviceNames.toTypedArray<CharSequence>(),
                    selectedDeviceIndex
                ) { dialog, index ->
                    dialog.dismiss()
                    val selectedAudioDevice = availableAudioDevices[index]
                    updateAudioDeviceIcon(selectedAudioDevice)
                    audioSwitch.selectDevice(selectedAudioDevice)
                }.create().show()
        }
    }

    /*
     * Update the menu icon based on the currently selected audio device.
     */
    private fun updateAudioDeviceIcon(selectedAudioDevice: AudioDevice?) {
        val audioDeviceMenuIcon = when (selectedAudioDevice) {
            is BluetoothHeadset -> R.drawable.ic_back/*.ic_bluetooth_white_24dp*/
            is WiredHeadset -> R.drawable.ic_back/*.ic_headset_mic_white_24dp*/
            is Speakerphone -> R.drawable.ic_back/*.ic_volume_up_white_24dp*/
            else -> R.drawable.ic_back/*.ic_phonelink_ring_white_24dp*/
        }

        audioDeviceMenuItem?.setIcon(audioDeviceMenuIcon)
    }

    /*
     * The actions performed during disconnect.
     */
    /*private fun setDisconnectAction() {
        with(binding) {
            connectActionFab.setImageDrawable(
                ContextCompat.getDrawable(
                    this@VideoActivity,
                    R.drawable.ic_back*//*.ic_call_end_white_24px*//*
                )
            )
            //connectActionFab.show()
            connectActionFab.setOnClickListener(disconnectClickListener())
        }
    }*/

    /*
     * Creates an connect UI dialog
     */
    /*private fun showConnectDialog() {
        val roomEditText = EditText(this)
        videoAlertDialog = createConnectDialog(
            roomEditText,
            connectClickListener(roomEditText), cancelConnectDialogClickListener(), this
        )
        videoAlertDialog?.show()
    }*/

    /*
     * Called when participant joins the room
     */
    private fun addRemoteParticipant(remoteParticipant: RemoteParticipant) {
        with(binding.contentVideoView) {
            /*
             * This app only displays video for one additional participant per Room
             */
            /*if (thumbnailVideoView.visibility == View.VISIBLE) {
                Snackbar.make(
                    binding.connectActionFab,
                    "Multiple participants are not currently support in this UI",
                    Snackbar.LENGTH_LONG
                ).setAction("Action", null).show()
                return
            }*/
            participantIdentity = remoteParticipant.identity
            videoStatusTextView.text = "Participant $participantIdentity joined"

            /*
             * Add participant renderer
             */
            remoteParticipant.remoteVideoTracks.firstOrNull()?.let { remoteVideoTrackPublication ->
                if (remoteVideoTrackPublication.isTrackSubscribed) {
                    remoteVideoTrackPublication.remoteVideoTrack?.let { addRemoteParticipantVideo(it) }
                }
            }

            /*
             * Start listening for participant events
             */
            remoteParticipant.setListener(participantListener)
        }
    }

    /*
     * Set primary view as renderer for participant video track
     */
    private fun addRemoteParticipantVideo(videoTrack: VideoTrack) {
        with(binding.contentVideoView) {
            primaryVideoView.isVisible = true

            //moveLocalVideoToThumbnailView()
            primaryVideoView.mirror = false
            videoTrack.addSink(primaryVideoView)
        }
    }

    private fun moveLocalVideoToThumbnailView() {
        with(binding.contentVideoView) {
            if (thumbnailVideoView.visibility == View.GONE) {
                thumbnailVideoView.visibility = View.VISIBLE
                localVideoContainer.clipToOutline = true
                with(localVideoTrack) {
                    this?.removeSink(primaryVideoView)
                    this?.addSink(thumbnailVideoView)
                }
                localVideoView = thumbnailVideoView
                thumbnailVideoView.mirror =
                    cameraCapturerCompat.cameraSource == CameraCapturerCompat.Source.FRONT_CAMERA
            }
        }
    }

    /*
     * Called when participant leaves the room
     */
    private fun removeRemoteParticipant(remoteParticipant: RemoteParticipant) {
        binding.contentVideoView.videoStatusTextView.text =
            "Participant $remoteParticipant.identity left."
        if (remoteParticipant.identity != participantIdentity) {
            return
        }

        /*
         * Remove participant renderer
         */
        remoteParticipant.remoteVideoTracks.firstOrNull()?.let { remoteVideoTrackPublication ->
            if (remoteVideoTrackPublication.isTrackSubscribed) {
                remoteVideoTrackPublication.remoteVideoTrack?.let { removeParticipantVideo(it) }
            }
        }
        moveLocalVideoToPrimaryView()
    }

    private fun removeParticipantVideo(videoTrack: VideoTrack) {
        videoTrack.removeSink(binding.contentVideoView.primaryVideoView)
    }

    private fun moveLocalVideoToPrimaryView() {
        with(binding.contentVideoView) {
            if (thumbnailVideoView.visibility == View.VISIBLE) {
                thumbnailVideoView.visibility = View.GONE
                with(localVideoTrack) {
                    this?.removeSink(thumbnailVideoView)
                    this?.addSink(primaryVideoView)
                }
                localVideoView = primaryVideoView
                primaryVideoView.mirror =
                    cameraCapturerCompat.cameraSource == CameraCapturerCompat.Source.FRONT_CAMERA
            }
        }
    }

    /* private fun connectClickListener(roomEditText: EditText): DialogInterface.OnClickListener {
         return DialogInterface.OnClickListener { _, _ ->
             *//*
             * Connect to room
             *//*
            //connectToRoom(roomEditText.text.toString())
        }
    }*/

    /*private fun disconnectClickListener(): View.OnClickListener {
        return View.OnClickListener {
            *//*
             * Disconnect from room
             *//*
            room?.disconnect()
            initializeUI()
        }
    }*/

    /*private fun connectActionClickListener(): View.OnClickListener {
        return View.OnClickListener { showConnectDialog() }
    }

    private fun cancelConnectDialogClickListener(): DialogInterface.OnClickListener {
        return DialogInterface.OnClickListener { _, _ ->
            initializeUI()
            videoAlertDialog?.dismiss()
        }
    }*/

    private fun switchCameraClickListener(): View.OnClickListener {
        return View.OnClickListener {
            with(binding.contentVideoView) {
                val cameraSource = cameraCapturerCompat.cameraSource
                cameraCapturerCompat.switchCamera()
                if (thumbnailVideoView.visibility == View.VISIBLE) {
                    thumbnailVideoView.mirror =
                        cameraSource == CameraCapturerCompat.Source.BACK_CAMERA
                } else {
                    primaryVideoView.mirror =
                        cameraSource == CameraCapturerCompat.Source.BACK_CAMERA
                }
            }
        }
    }

    private fun localVideoClickListener(): View.OnClickListener {
        return View.OnClickListener {
            /*
             * Enable/disable the local video track
             */

            if (localVideoTrack == null) {
                setUpLocalVideoTrack()
            } else {
                localVideoTrack?.let {
                    with(binding) {
                        val enable = !it.isEnabled
                        it.enable(enable)
                        binding.localVideoActionFab.isSelected = !enable
                    }
                }
            }
        }
    }

    private fun muteClickListener(): View.OnClickListener {
        return View.OnClickListener {
            /*
             * Enable/disable the local audio track. The results of this operation are
             * signaled to other Participants in the same Room. When an audio track is
             * disabled, the audio is muted.
             */
            localAudioTrack?.let {
                val enable = !it.isEnabled
                it.enable(enable)
                binding.muteActionFab.isSelected = !enable
            }
        }
    }

    private fun retrieveAccessTokenfromServer() {
        // code to retrieve access token from server
        /*Ion.with(this)
            .load("$ACCESS_TOKEN_SERVER?identity=${UUID.randomUUID()}")
            .asString()
            .setCallback { e, token ->
                if (e == null) {
                    //this@VideoActivity.accessToken = token
                } else {
                    Toast.makeText(
                        this@VideoActivity,
                        R.string.error_retrieving_access_token, Toast.LENGTH_LONG
                    ).show()
                }
            }*/
    }

    /*private fun createConnectDialog(
        participantEditText: EditText,
        callParticipantsClickListener: DialogInterface.OnClickListener,
        cancelClickListener: DialogInterface.OnClickListener,
        context: Context,
    ): AlertDialog {
        val alertDialogBuilder = AlertDialog.Builder(context).apply {
            setIcon(R.drawable.ic_back*//*.ic_video_call_white_24dp*//*)
            setTitle("Connect to a room")
            setPositiveButton("Connect", callParticipantsClickListener)
            setNegativeButton("Cancel", cancelClickListener)
            setCancelable(false)
        }

        setRoomNameFieldInDialog(participantEditText, alertDialogBuilder, context)

        return alertDialogBuilder.create()
    }*/

    /* @SuppressLint("RestrictedApi")
     private fun setRoomNameFieldInDialog(
         roomNameEditText: EditText,
         alertDialogBuilder: AlertDialog.Builder,
         context: Context,
     ) {
         roomNameEditText.hint = "room name"
         val horizontalPadding =
             context.resources.getDimensionPixelOffset(R.dimen.dp_16)
         val verticalPadding =
             context.resources.getDimensionPixelOffset(R.dimen.dp_16)
         alertDialogBuilder.setView(
             roomNameEditText,
             horizontalPadding,
             verticalPadding,
             horizontalPadding,
             0
         )
     }*/

    override fun onBackPressed() {
        /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE))
                minimize()
            else
                super.onBackPressed()
        } else {
            super.onBackPressed()
        }*/

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)) {
                if (hasPiPPermission()) {
                    minimize()
                } else {
                    //super.onBackPressed()
                    showAlertDialogWithOptions("Call will be disconnected, do you want to enable PIP(Picture in picture) mode from settings to stay connected?",
                        dialogYesNoListener = object : DialogYesNoListener {
                            override fun onYesClick() {
                                startActivity(
                                    Intent(
                                        "android.settings.PICTURE_IN_PICTURE_SETTINGS",
                                        Uri.parse("package:${packageName}")
                                    )
                                )
                            }

                            override fun onNoClick() {
                                finish()
                            }
                        })
                }
            } else {
                super.onBackPressed()
            }
        } else {
            super.onBackPressed()
        }
    }

    private fun hasPiPPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager?
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps?.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_PICTURE_IN_PICTURE,
                    android.os.Process.myUid(),
                    packageName
                ) == AppOpsManager.MODE_ALLOWED
            } else {
                appOps?.checkOpNoThrow(
                    AppOpsManager.OPSTR_PICTURE_IN_PICTURE,
                    android.os.Process.myUid(),
                    packageName
                ) == AppOpsManager.MODE_ALLOWED
            }
        } else {
            false
        }
    }

    /**
     * Enters Picture-in-Picture mode.
     */
    @RequiresApi(Build.VERSION_CODES.O)
    fun minimize() {
        val d: Display = windowManager.defaultDisplay
        val p = Point()
        d.getSize(p)
        val width: Int = p.x
        val height: Int = p.y

        val ratio = Rational(width, (height * 0.8).toInt())//Rational(width, height)

        updateUIOnPiPModeChanged(isEnteredInPiP = true)

        // Calculate the aspect ratio of the PiP screen.
        mPictureInPictureParamsBuilder.setAspectRatio(ratio)
        val flag = enterPictureInPictureMode(mPictureInPictureParamsBuilder.build())


        Log.d(TAG, "minimize: $flag")
    }

    private fun updateUIOnPiPModeChanged(isEnteredInPiP: Boolean) {
        if (isEnteredInPiP) {
            // Hide the controls in picture-in-picture mode.
            binding.layoutAction.visibility = View.GONE
            binding.contentVideoView.localVideoContainer.visibility = View.GONE
            // uncomment below code to show local video in PiP mode
            /*binding.contentVideoView.localVideoContainerPiP.visibility = View.VISIBLE
            moveLocalVideoToPiPThumbnailView()*/
        } else {
            // Show the video controls if the video is not playing
            binding.layoutAction.visibility = View.VISIBLE
            binding.contentVideoView.localVideoContainer.visibility = View.VISIBLE
            // uncomment below code to show local video in PiP mode
            /*binding.contentVideoView.localVideoContainerPiP.visibility = View.GONE
            moveLocalVideoToNormalThumbnailView()*/
        }
    }

    /**
     * moveLocalVideoToPiPThumbnailView
     * moves the local video, to pip mode local video view
     * when user enters in PiP mode
     */
    private fun moveLocalVideoToPiPThumbnailView() {
        with(binding.contentVideoView) {
            with(localVideoTrack) {
                this?.removeSink(thumbnailVideoView)
                this?.addSink(thumbnailVideoViewPiP)
            }
            localVideoView = thumbnailVideoViewPiP

            thumbnailVideoViewPiP.mirror =
                cameraCapturerCompat.cameraSource == CameraCapturerCompat.Source.FRONT_CAMERA
        }
    }

    /**
     * moveLocalVideoToNormalThumbnailView
     * moves the pip local video, to normal mode local video view
     * when user exits from PiP mode
     */
    private fun moveLocalVideoToNormalThumbnailView() {
        with(binding.contentVideoView) {
            with(localVideoTrack) {
                this?.removeSink(thumbnailVideoViewPiP)
                this?.addSink(thumbnailVideoView)
            }
            localVideoView = thumbnailVideoView

            thumbnailVideoView.mirror =
                cameraCapturerCompat.cameraSource == CameraCapturerCompat.Source.FRONT_CAMERA
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration,
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        isPictureInPictureModeActive = isInPictureInPictureMode
        if (isInPictureInPictureMode) {
            // Starts receiving events from action items in PiP mode.
        } else {
            // We are out of PiP mode. We can stop receiving events from it.
            if (lifecycle.currentState == Lifecycle.State.CREATED) {
                //when user click on Close button of PIP this will trigger, do what you want here
                this.finishAndRemoveTask()
                Log.e(VideoActivity::class.java.simpleName, "Close button -> Click")
            } else {
                updateUIOnPiPModeChanged(isEnteredInPiP = false)
                //when user click on maximize button of PIP this will trigger, do what you want here
                Log.e(VideoActivity::class.java.simpleName, "Maximize button -> Click")
            }
        }
        Log.e(TAG, "onPictureInPictureModeChanged -> $isInPictureInPictureMode")
    }
}