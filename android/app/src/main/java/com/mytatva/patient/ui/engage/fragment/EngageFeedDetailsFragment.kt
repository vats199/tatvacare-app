package com.mytatva.patient.ui.engage.fragment

import android.annotation.SuppressLint
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.source.ProgressiveMediaSource
import com.google.android.exoplayer2.upstream.DefaultDataSourceFactory
import com.google.android.exoplayer2.util.Log
import com.google.android.exoplayer2.util.Util
import com.google.android.flexbox.FlexDirection
import com.google.android.flexbox.FlexboxLayoutManager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.model.ContentTypes
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CommentsData
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.databinding.EngageFragmentFeedDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.VideoPlayerActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.adapter.EngageDiscoverFeedCommentsAdapter
import com.mytatva.patient.ui.engage.adapter.EngageGalleryPagerAdapter
import com.mytatva.patient.ui.engage.adapter.FeedTopicsAdapter
import com.mytatva.patient.ui.engage.bottomsheet.ReportCommentBottomSheetDialog
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.loadArticleImage
import com.mytatva.patient.utils.kFormat
import com.mytatva.patient.utils.openBrowser
import com.mytatva.patient.utils.rnbridge.ContextHolder
import com.mytatva.patient.utils.shareText
import kotlinx.coroutines.*
import java.util.*

class EngageFeedDetailsFragment : BaseFragment<EngageFragmentFeedDetailsBinding>() {

    val htmlData =
        "<table align=\"center\" border=\"1\" cellpadding=\"1\" cellspacing=\"1\" style=\"height:230px; width:500px\">\n" +
                "\t<thead>\n" +
                "\t\t<tr>\n" +
                "\t\t\t<th scope=\"col\">hii</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t\t<th scope=\"col\">&nbsp;</th>\n" +
                "\t\t</tr>\n" +
                "\t</thead>\n" +
                "\t<tbody>\n" +
                "\t\t<tr>\n" +
                "\t\t\t<td>hii</td>\n" +
                "\t\t\t<td>hii</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t</tr>\n" +
                "\t\t<tr>\n" +
                "\t\t\t<td>hii</td>\n" +
                "\t\t\t<td>hii</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t</tr>\n" +
                "\t\t<tr>\n" +
                "\t\t\t<td>hii</td>\n" +
                "\t\t\t<td>hii</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t</tr>\n" +
                "\t\t<tr>\n" +
                "\t\t\t<td>hii</td>\n" +
                "\t\t\t<td>hii</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t\t<td>&nbsp;</td>\n" +
                "\t\t</tr>\n" +
                "\t</tbody>\n" +
                "</table>\n" +
                "\n" +
                "<h1>Hello world!</h1>\n" +
                "\n" +
                "<p>I&#39;m an instance of <a href=\"https://ckeditor.com\">CKEditor</a>.</p>\n" +
                "\n" +
                "<div>\n" +
                "<h2>What is Lorem Ipsum?</h2>\n" +
                "\n" +
                "<p><span style=\"font-family:Comic Sans MS,cursive\"><strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</span></p>\n" +
                "</div>\n" +
                "\n" +
                "<div>\n" +
                "<h2><span style=\"font-family:Comic Sans MS,cursive\">Why do we use it?</span></h2>\n" +
                "\n" +
                "<p><span style=\"font-family:Comic Sans MS,cursive\"><img alt=\"\" src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMtAgslBqFAhrydwVznYgiMUNxbnAKcCuiLW1TMil-&amp;s\" /></span></p>\n" +
                "\n" +
                "<p><span style=\"font-family:Georgia,serif\">It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using &#39;Content here, content here&#39;, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for &#39;lorem ipsum&#39; will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).<a href=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMtAgslBqFAhrydwVznYgiMUNxbnAKcCuiLW1TMil-&amp;s\">THis is image link</a></span></p>\n" +
                "</div>\n" +
                "\n" +
                "<p>&nbsp;</p>\n" +
                "\n" +
                "<div>\n" +
                "<h2><span style=\"font-family:Comic Sans MS,cursive\"><strong>Where does it come from?</strong></span></h2>\n" +
                "\n" +
                "<p>Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of &quot;de Finibus Bonorum et Malorum&quot; (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, &quot;Lorem ipsum dolor sit amet..&quot;, comes from a line in section 1.10.32.</p>\n" +
                "\n" +
                "<p>The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from &quot;de Finibus Bonorum et Malorum&quot; by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.</p>\n" +
                "</div>\n" +
                "\n" +
                "<div>\n" +
                "<h2><u><em><span style=\"font-family:Trebuchet MS,Helvetica,sans-serif\">Where can I get some?</span></em></u></h2>\n" +
                "\n" +
                "<p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don&#39;t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn&#39;t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.</p>\n" +
                "</div>\n"

    var contentType: String = ""

    val contentMasterId by lazy {
        arguments?.getString(Common.BundleKey.CONTENT_ID)
    }

    val itemPosition by lazy {
        arguments?.getInt(Common.BundleKey.POSITION)
    }

    var currentClickCommentPosition = -1

    private val commentList = arrayListOf<CommentsData>()

    private val engageDiscoverFeedCommentsAdapter by lazy {
        EngageDiscoverFeedCommentsAdapter(session.userId, commentList, 0,
            object : EngageDiscoverFeedCommentsAdapter.AdapterListener {
                override fun onReportClick(mainItemPosition: Int, position: Int) {
                    currentClickCommentPosition = position

                    if (commentList[position].reported == "Y") {
                        reportComment(
                            commentId = commentList[position].content_comments_id ?: "",
                            reported = "N"
                        )
                    } else {
                        showReportCommentDialog(position)
                    }
                }

                override fun onDeleteClick(mainItemPosition: Int, position: Int) {
                    commentList[position].content_comments_id?.let { removeComment(it) }
                }
            })
    }

    private fun showReportCommentDialog(position: Int) {
        activity?.supportFragmentManager?.let {
            ReportCommentBottomSheetDialog { reportType, reportDesc ->
                if (commentList.size > position) {
                    reportComment(
                        commentId = commentList[position].content_comments_id ?: "",
                        reported = "Y",
                        reportType,
                        reportDesc
                    )
                }
            }.show(it, ReportCommentBottomSheetDialog::class.java.simpleName)
        }
    }

    var player: SimpleExoPlayer? = null
    private var mediaUrl = ""

    var contentData: ContentData? = null

    private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageFragmentFeedDetailsBinding {
        return EngageFragmentFeedDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onStart() {
        super.onStart()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onPause() {
        super.onPause()
        pausePlayer()
        //updateScreenTimeDurationInAnalytics()
    }

    override fun onResume() {
        super.onResume()
        startPlayer()
        resumedTime = Calendar.getInstance().timeInMillis
        contentById()
    }

    /*private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.USER_TIME_SPENT_CONTENT, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
            putString(analytics.PARAM_CONTENT_MASTER_ID, contentMasterId)
            putString(analytics.PARAM_CONTENT_TYPE, contentType)
        }, screenName = getFeedDetailScreenName())
    }*/

    private fun pausePlayer() {
        player?.playWhenReady = false
        player?.playbackState
    }

    private fun startPlayer() {
        player?.playWhenReady = true
        player?.playbackState
    }

    override fun bindData() {
        contentType = arguments?.getString(Common.BundleKey.CONTENT_TYPE) ?: ""

        setUpToolbar()
        setViewListeners()
        //setDetails()
        setUpRecyclerView()

        //contentById()

        setupUI()
    }

    private fun setupUI() {
        with(binding) {
            layoutComments.isVisible =
                AppFlagHandler.isToHideEngageDiscoverComments(firebaseConfigUtil).not()
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setDetails() {
        with(binding) {
            when (contentType) {
                ContentTypes.ARTICLE_BLOG.contentKey -> {
                    cardImage.visibility = View.VISIBLE
                    cardGalleryPager.visibility = View.GONE
                    textViewPeopleAttending.visibility = View.GONE
                    buttonBookYourSeat.visibility = View.GONE
                    layoutName.visibility = View.VISIBLE
                    layoutDateTime.visibility = View.GONE
                    imageViewPlay.visibility = View.GONE
                    setUpImage()
                }
                ContentTypes.WEBINAR.contentKey -> {
                    cardImage.visibility = View.VISIBLE
                    cardGalleryPager.visibility = View.GONE
                    textViewPeopleAttending.visibility = View.VISIBLE
                    buttonBookYourSeat.visibility = View.VISIBLE
                    layoutName.visibility = View.VISIBLE
                    layoutDateTime.visibility = View.VISIBLE
                    imageViewPlay.visibility = View.GONE
                    setUpImage()
                }
                ContentTypes.KOL_VIDEOS.contentKey,
                ContentTypes.NORMAL_VIDEOS.contentKey,
                -> {
                    cardImage.visibility = View.VISIBLE
                    cardGalleryPager.visibility = View.GONE
                    textViewPeopleAttending.visibility = View.GONE
                    buttonBookYourSeat.visibility = View.GONE
                    layoutName.visibility = View.VISIBLE
                    layoutDateTime.visibility = View.GONE
                    imageViewPlay.visibility = View.VISIBLE
                    setUpVideoUI()
                }
                ContentTypes.PHOTO_GALLERY.contentKey -> {
                    cardImage.visibility = View.GONE
                    cardGalleryPager.visibility = View.VISIBLE
                    textViewPeopleAttending.visibility = View.GONE
                    buttonBookYourSeat.visibility = View.GONE
                    layoutName.visibility = View.GONE
                    layoutDateTime.visibility = View.GONE
                    imageViewPlay.visibility = View.GONE
                    setUpGalleryPager()
                }
            }

            setUpWebView()

            contentData?.let {

                //set topics
                val topicList = arrayListOf<String>()
                if (it.topic_name?.contains(",") == true) {
                    topicList.addAll(it.topic_name.split(","))
                } else if (it.topic_name?.isNotBlank() == true) {
                    topicList.add(it.topic_name)
                }
                if (topicList.isNotEmpty()) {
                    val flexboxLayoutManager = FlexboxLayoutManager(requireContext())
                    flexboxLayoutManager.flexDirection = FlexDirection.ROW
                    recyclerViewTopics.apply {
                        layoutManager = flexboxLayoutManager
                        adapter = FeedTopicsAdapter(topicList)
                    }
                }

                // recommended tag
                if (it.recommended_by_doctor == "Yes") {
                    textViewRecommendedByDr.visibility = View.VISIBLE
                    textViewRecommendedByDr.text =
                        getString(R.string.engage_feed_details_label_recommended_by_doctor)
                } else {
                    textViewRecommendedByDr.visibility = View.GONE
                }

                if (it.recommended_by_healthcoach == "Yes") {
                    textViewRecommendedByHC.visibility = View.VISIBLE
                    textViewRecommendedByHC.text =
                        getString(R.string.engage_feed_details_label_recommended_by_health_coach)
                } else {
                    textViewRecommendedByHC.visibility = View.GONE
                }

                imageViewLike.isSelected = contentData?.liked == "Y"
                imageViewBookmark.isSelected = contentData?.bookmarked == "Y"

                textViewLikeCount.text = contentData?.likeCount?.kFormat()

                layoutLike.isVisible = contentData?.like_capability != Common.CapabilityYesNo.NO
                imageViewBookmark.isVisible =
                    contentData?.bookmark_capability != Common.CapabilityYesNo.NO

                textViewTitle.text = it.title

                if (it.author.isNullOrBlank()) {
                    textViewName.visibility = View.GONE
                    viewLine3.visibility = View.GONE
                } else {
                    textViewName.visibility = View.VISIBLE
                    viewLine3.visibility = View.VISIBLE
                    textViewName.text = it.author
                }

                textViewReadTime.text = it.xmin_read_time.plus(" min read")
                /*textViewReadTime.visibility =
                    if (it.content_type == ContentTypes.ARTICLE_BLOG.contentKey) View.VISIBLE else View.GONE*/

                textViewDate.text = it.formattedScheduleDate

                viewLine2.visibility = View.GONE
                textViewTime.visibility = View.GONE
                //textViewTime.text = "10:00 AM"

                //textViewPeopleAttending.text = ""

                //comments
                setCommentsUI()
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setCommentsUI() {
        with(binding) {
            contentData?.let {

                commentList.clear()
                it.comment?.comment_data?.let { it1 -> commentList.addAll(it1) }
                engageDiscoverFeedCommentsAdapter.notifyDataSetChanged()

                if (it.getTotalComment > 2) {
                    textViewViewAllComment.visibility = View.VISIBLE
                    textViewViewAllComment.text = "View all ${it.getTotalComment} comments"
                } else {
                    textViewViewAllComment.visibility = View.GONE
                }
            }
        }
    }

    private fun setUpImage() {
        with(binding) {
            layoutVideo.visibility = View.GONE
            imageViewContent.visibility = View.VISIBLE
            imageViewContent.loadArticleImage(contentData?.media?.firstOrNull()?.image_url ?: "")
        }
    }

    private fun setUpVideoUI() {
        with(binding) {
            imageViewContent.visibility = View.GONE
            layoutVideo.visibility = View.VISIBLE

            playerView.setControllerVisibilityListener { visibility ->
                imageViewFullScreen.visibility = visibility
            }
            if (contentData?.media.isNullOrEmpty().not()) {
                imageViewVideoThumb.loadArticleImage(contentData?.media?.firstOrNull()?.image_url
                    ?: "")
            }
        }
    }

    private fun initializePlayer() {
        binding.playerView.visibility = View.VISIBLE
        if (player == null) {
            player = SimpleExoPlayer.Builder(requireContext()).build()
            player?.addListener(object : Player.Listener {
                override fun onPlaybackStateChanged(playbackState: Int) {
                    if (playbackState == Player.STATE_ENDED) {

                    } else if (playbackState == Player.STATE_READY) {

                    }
                }
            })
        }

        binding.playerView.player = player

        val dataSourceFactory = DefaultDataSourceFactory(requireContext(),
            Util.getUserAgent(requireActivity().applicationContext, getString(R.string.app_name)))

        val videoSource =
            ProgressiveMediaSource.Factory(dataSourceFactory)
                .createMediaSource(MediaItem.fromUri(Uri.parse(mediaUrl)))

        // Prepare the player with the source.
        player!!.playWhenReady = true
        player!!.setMediaSource(videoSource, false)
        player!!.prepare()
    }

    private fun setUpGalleryPager() {
        with(binding) {
            if (contentData?.media.isNullOrEmpty().not()) {
                viewPagerGallery.adapter =
                    EngageGalleryPagerAdapter(navigator, contentData?.media ?: arrayListOf())
                dotsIndicator.setViewPager2(viewPagerGallery)
            } else {
                binding.cardGalleryPager.visibility = View.GONE
            }
        }
    }

    private fun setUpWebView() {
        with(binding) {
            if (contentData?.description.isNullOrBlank().not()) {
                webView.visibility = View.VISIBLE

                //webView.setLayerType(View.LAYER_TYPE_SOFTWARE, null)
                /*webView.settings.builtInZoomControls = true
                webView.settings.displayZoomControls = false
                webView.settings.useWideViewPort = true
                webView.settings.loadWithOverviewMode = true*/

                contentData?.description?.let {
                    /*it*/
                    /*webView.loadData(dummyWebData, "text/html; charset=utf-8", "UTF-8")*/

                    val cleanHtml = it.replace("\\\"", "\"")

                    //val cleanHtml = htmlData
                    Log.d("HTML", ":: $cleanHtml")

                    webView.loadDataWithBaseURL(null,
                        cleanHtml
                        /*dummyWebData*/,
                        "text/html", //; charset=utf-8
                        "UTF-8",
                        null)

                    /*webView.loadDataWithBaseURL(null,
                        cleanHtml,
                        "text/html",
                        "UTF-8",
                        null)*/

                }

                /*webView.postDelayed({
                    webView.layoutParams =
                        LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                            ViewGroup.LayoutParams.WRAP_CONTENT)
                }, 500)*/
            } else {
                webView.visibility = View.GONE
            }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            imageViewNotification.visibility = View.GONE
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewLanguage.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewComments.apply {
                layoutManager = LinearLayoutManager(activity, RecyclerView.VERTICAL, false)
                adapter = engageDiscoverFeedCommentsAdapter
            }
        }
    }

    private fun setViewListeners() {
        with(binding) {
            imageViewPlay.setOnClickListener { onViewClick(it) }
            imageViewFullScreen.setOnClickListener { onViewClick(it) }
            textViewViewAllComment.setOnClickListener { onViewClick(it) }
            /*layoutAddComment.setOnClickListener { onViewClick(it) }*/
            imageViewLike.setOnClickListener { onViewClick(it) }
            imageViewBookmark.setOnClickListener { onViewClick(it) }
            imageViewPostComment.setOnClickListener { onViewClick(it) }
            imageViewShare.setOnClickListener { onViewClick(it) }
            buttonBookYourSeat.setOnClickListener { onViewClick(it) }
            imageViewContent.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewContent -> {
                navigator.showImageViewerDialog(arrayListOf(contentData?.media?.firstOrNull()?.image_url
                    ?: ""))
            }
            R.id.buttonBookYourSeat -> {
                requireActivity().openBrowser(URLFactory.AppUrls.WEBINAR_BOOK_SEAT)
            }
            R.id.imageViewShare -> {
                contentData?.getShareText?.let {
                    analytics.logEvent(analytics.USER_SHARED_CONTENT,
                        Bundle().apply {
                            putString(analytics.PARAM_CONTENT_MASTER_ID,
                                contentData?.content_master_id)
                            putString(analytics.PARAM_CONTENT_TYPE,
                                contentData?.content_type)
                        })
                    requireActivity().shareText(it)
                }
            }
            R.id.imageViewPostComment -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.commenting_on_articles)) {
                    if (binding.editTextAddAComment.text.toString().trim().isNotBlank()) {
                        hideKeyBoard()
                        updateComment(binding.editTextAddAComment.text.toString().trim())
                        binding.editTextAddAComment.setText("")
                    }
                } else {
                    binding.editTextAddAComment.setText("")
                }
            }
            R.id.imageViewLike -> {
                with(binding) {
                    imageViewLike.isSelected = imageViewLike.isSelected.not()
                    if (imageViewLike.isSelected) {//
                        contentData?.likeCount = (contentData?.likeCount ?: 0) + 1
                        contentData?.liked = "Y"
                    } else {
                        contentData?.likeCount = (contentData?.likeCount ?: 0) - 1
                        contentData?.liked = "N"
                    }
                    textViewLikeCount.text = contentData?.likeCount?.kFormat()
                }

                /*if (contentData?.liked == "Y")
                    contentData?.liked = "N"
                else
                    contentData?.liked = "Y"*/

                updateLikes()
            }
            R.id.imageViewBookmark -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                    with(binding) {
                        imageViewBookmark.isSelected = imageViewBookmark.isSelected.not()
                    }
                    updateBookmarks()
                }
            }
            R.id.textViewViewAllComment,
            R.id.layoutAddComment,
            -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    CommentsFragment::class.java).addBundle(bundleOf(
                    Pair(Common.BundleKey.CONTENT_ID, contentMasterId),
                    Pair(Common.BundleKey.CONTENT_TYPE, contentType)
                )).start()
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.imageViewFullScreen -> {
                navigator.loadActivity(VideoPlayerActivity::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.CONTENT_ID, contentMasterId),
                        Pair(Common.BundleKey.CONTENT_TYPE, contentType),
                        Pair(Common.BundleKey.MEDIA_URL, mediaUrl),
                        Pair(Common.BundleKey.POSITION, player?.currentPosition)
                    ))
                    /*.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)*/
                    .start()
            }
            R.id.imageViewPlay -> {
                binding.imageViewVideoThumb.visibility = View.GONE
                binding.imageViewPlay.visibility = View.GONE
                mediaUrl = contentData?.media?.firstOrNull()?.media_url ?: ""
                if (mediaUrl.isNotBlank()) {
                    initializePlayer()
                }

                analytics.logEvent(analytics.USER_PLAY_MEDIA_CONTENT, Bundle().apply {
                    putString(analytics.PARAM_CONTENT_MASTER_ID, contentData?.content_master_id)
                    putString(analytics.PARAM_CONTENT_TYPE, contentData?.content_type)
                }, screenName = getFeedDetailScreenName())
                /*navigator.loadActivity(VideoPlayerActivity::class.java).start()*/
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun contentById() {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
        }
        showLoader()
        engageContentViewModel.contentById(apiRequest)
    }

    var callApiJob: Job? = null
    private fun updateLikes() {
        callApiJob?.cancel()
        callApiJob = GlobalScope.launch(Dispatchers.Main) {
            delay(500)

            val apiRequest = ApiRequest().apply {
                content_master_id = contentMasterId
                is_active = contentData?.liked //if (contentData?.liked == "Y") "N" else "Y"
            }
            //showLoader()
            engageContentViewModel.updateLikes(apiRequest,
                analytics,
                contentType,
                screenName = getFeedDetailScreenName())

        }
    }

    private fun updateBookmarks() {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            is_active = if (contentData?.bookmarked == "Y") "N" else "Y"
        }
        engageContentViewModel.updateBookmarks(apiRequest,
            analytics,
            contentType,
            screenName = getFeedDetailScreenName())
    }

    private fun reportComment(
        commentId: String,
        reported: String,
        reportType: String? = null,
        commentDesc: String? = null,
    ) {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            content_comments_id = commentId
            this.reported = reported
            if (commentDesc.isNullOrBlank().not()) {
                description = commentDesc
            }
            //S - Spam, I - Inappropriate, F - False information
            report_type = reportType
        }
        showLoader()
        engageContentViewModel.reportComment(apiRequest)
    }

    private fun updateComment(commentStr: String) {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            /*content_comments_id = ""*/
            comment = commentStr
        }
        engageContentViewModel.updateComment(apiRequest)
    }

    private fun removeComment(commentId: String) {
        val apiRequest = ApiRequest().apply {
            content_comments_id = commentId
        }
        showLoader()
        engageContentViewModel.removeComment(apiRequest, screenName = getFeedDetailScreenName())
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        engageContentViewModel.contentByIdLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                setData(responseBody.data!!)
                responseBody.data.let {
                   analytics.logEvent(
                        AnalyticsClient.USER_CLICKED_ON_CARD,
                        Bundle().apply {
                            putString(analytics.PARAM_CONTENT_MASTER_ID, it.content_master_id)
                            putString(analytics.PARAM_CONTENT_TYPE, it.content_type)
                            putString(analytics.PARAM_CONTENT_HEADING, it.title)
                            putInt(analytics.PARAM_CONTENT_CARD_NUMBER, itemPosition!!)
                        }
                    )

                    analytics.logEvent(analytics.USER_VIEW_CONTENT, Bundle().apply {
                        putString(analytics.PARAM_CONTENT_MASTER_ID, it.content_master_id)
                        putString(analytics.PARAM_CONTENT_TYPE, it.content_type)
                    }, screenName = getFeedDetailScreenName())
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        engageContentViewModel.updateLikesLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()

                /*if (contentData?.liked == "Y")
                    contentData?.liked = "N"
                else
                    contentData?.liked = "Y"

                binding.imageViewLike.isSelected = contentData?.liked == "Y"*/
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        engageContentViewModel.updateBookmarksLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"bookmarkUpdated","") }

                if (contentData?.bookmarked == "Y")
                    contentData?.bookmarked = "N"
                else
                    contentData?.bookmarked = "Y"

                binding.imageViewBookmark.isSelected = contentData?.bookmarked == "Y"
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //reportCommentLiveData
        engageContentViewModel.reportCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                onReportCommentSuccess()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //updateCommentLiveData
        engageContentViewModel.updateCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { setCommentData(it) }

                analytics.logEvent(analytics.USER_COMMENTED, Bundle().apply {
                    putString(analytics.PARAM_CONTENT_MASTER_ID, contentMasterId)
                    putString(analytics.PARAM_CONTENT_TYPE, contentType)
                }, screenName = getFeedDetailScreenName())
            },
            onError = { throwable ->
                hideLoader()
                /*binding.editTextAddAComment.setText("")
                binding.editTextAddAComment.clearFocus()*/
                true
            })

        //removeCommentLiveData
        engageContentViewModel.removeCommentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { setCommentData(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    private fun setData(contentData: ContentData) {
        this.contentData = contentData
        if (contentData.content_type == ContentTypes.EXERCISE_VIDEO.contentKey) {
            // for exercise video deep link open player screen and close current
            navigator.loadActivity(VideoPlayerActivity::class.java)
                .addBundle(bundleOf(
                    Pair(Common.BundleKey.CONTENT_ID,
                        contentData.content_master_id),
                    Pair(Common.BundleKey.CONTENT_TYPE,
                        contentData.content_type),
                    Pair(Common.BundleKey.MEDIA_URL,
                        contentData.media?.first()?.media_url),
                    Pair(Common.BundleKey.POSITION, 0),
                    Pair(Common.BundleKey.GOAL_MASTER_ID,
                        contentData.goal_master_id),
                    Pair(Common.BundleKey.IS_EXERCISE_VIDEO, true)
                )).byFinishingCurrent().start()
        } else {
            contentData.let {
                binding.layoutContent.visibility = View.VISIBLE
                contentType = it.content_type ?: ""
                binding.layoutHeader.textViewToolbarTitle.text = contentData.title
                setDetails()

                analytics.setScreenName(getFeedDetailScreenName())

            }
        }
    }

    fun getFeedDetailScreenName(): String {
        return when (contentType) {
            ContentTypes.ARTICLE_BLOG.contentKey -> {
                AnalyticsScreenNames.ContentDetailBlog
            }
            ContentTypes.PHOTO_GALLERY.contentKey -> {
                AnalyticsScreenNames.ContentDetailPhotoGallery
            }
            ContentTypes.KOL_VIDEOS.contentKey -> {
                AnalyticsScreenNames.ContentDetailKolVideo
            }
            ContentTypes.NORMAL_VIDEOS.contentKey -> {
                AnalyticsScreenNames.ContentDetailNormalVideo
            }
            ContentTypes.WEBINAR.contentKey -> {
                AnalyticsScreenNames.ContentDetailWebinar
            }
            else -> {
                ""
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setCommentData(contentData: ContentData) {
        binding.editTextAddAComment.setText("")
        binding.editTextAddAComment.clearFocus()
        this.contentData = contentData
        setCommentsUI()
    }

    private fun onReportCommentSuccess() {
        if (currentClickCommentPosition != -1 && commentList.size > currentClickCommentPosition) {
            val reportedStatus = if (commentList[currentClickCommentPosition].reported == "Y") "N"
            else "y"
            commentList[currentClickCommentPosition].reported = reportedStatus

            engageDiscoverFeedCommentsAdapter.notifyItemChanged(currentClickCommentPosition)

            analytics.logEvent(if (reportedStatus == "Y") analytics.USER_REPORTED_COMMENT
            else analytics.USER_UN_REPORTED_COMMENT, Bundle().apply {
                putString(analytics.PARAM_CONTENT_MASTER_ID, contentMasterId)
                putString(analytics.PARAM_CONTENT_TYPE, contentType)
            }, screenName = AnalyticsScreenNames.ReportComment)
        }
    }
}