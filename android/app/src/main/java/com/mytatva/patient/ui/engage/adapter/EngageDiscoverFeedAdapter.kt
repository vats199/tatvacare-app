package com.mytatva.patient.ui.engage.adapter

import android.os.Build
import android.os.Handler
import android.os.Looper
import android.text.Html
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.core.widget.addTextChangedListener
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.ContentTypes
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.databinding.EngageRowDiscoverFeedBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.FirebaseConfigUtil
import com.mytatva.patient.utils.SafeClickListener
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.imagepicker.loadArticleImage
import com.mytatva.patient.utils.kFormat

class EngageDiscoverFeedAdapter(
    val activity: BaseActivity,
    val navigator: Navigator,
    val userId: String,
    var list: ArrayList<ContentData>,
    val firebaseConfigUtil: FirebaseConfigUtil,
    val adapterListener: AdapterListener,
    val commentsAdapterListener: EngageDiscoverFeedCommentsAdapter.AdapterListener,
) : RecyclerView.Adapter<EngageDiscoverFeedAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = EngageRowDiscoverFeedBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context

        holder.binding.apply {

            layoutOptions.visibility = View.VISIBLE

            when (item.content_type) {
                ContentTypes.PHOTO_GALLERY.contentKey -> {
                    layoutImage.visibility = View.GONE
                    layoutDateTime.visibility = View.GONE
                    layoutImageGallery.visibility = View.VISIBLE

                    viewPagerGallery.adapter =
                        EngageGalleryPagerAdapter(navigator, item.media ?: arrayListOf(),
                            object : EngageGalleryPagerAdapter.AdapterListener {
                                override fun onClick(imagePosition: Int) {
                                    adapterListener.onClick(position)
                                }
                            })

                    dotsIndicator.setViewPager2(viewPagerGallery)
                }
                ContentTypes.ARTICLE_BLOG.contentKey,
                ContentTypes.KOL_VIDEOS.contentKey,
                ContentTypes.NORMAL_VIDEOS.contentKey,
                ContentTypes.WEBINAR.contentKey,
                -> {
                    layoutImage.visibility = View.VISIBLE
                    layoutImageGallery.visibility = View.GONE
                    layoutDateTime.visibility =
                        if (item.content_type == ContentTypes.WEBINAR.contentKey) View.VISIBLE else View.GONE
                    textViewDate.text = item.formattedScheduleDate

                    imageViewFeed.loadArticleImage(item.media?.firstOrNull()?.image_url ?: "")

                    /*textViewTime.text = "10:00 AM"*/

                }
            }

            textViewTime.visibility = View.GONE
            viewLine2.visibility = View.GONE

            textViewDuration.text = "${item.xmin_read_time} min read"
            textViewDuration.visibility =
                if (item.content_type == ContentTypes.ARTICLE_BLOG.contentKey) View.VISIBLE else View.GONE

            imageViewPlay.visibility = if (item.content_type == ContentTypes.KOL_VIDEOS.contentKey
                || item.content_type == ContentTypes.NORMAL_VIDEOS.contentKey
            ) View.VISIBLE
            else View.GONE

            buttonBookSeat.visibility =
                if (item.content_type == ContentTypes.WEBINAR.contentKey) View.VISIBLE
                else View.GONE

            /*val topic =
                if (item.topic_name?.isNotBlank() == true && item.topic_name.contains(",")) {
                    item.topic_name.split(",")[0]
                } else item.topic_name*/
            textViewTopic.text = item.topic_name?.replace(",", ", ")


            val recommendedLabel =
                if (item.recommended_by_doctor == "Yes" && item.recommended_by_healthcoach == "Yes")
                    "Recommended by Doctor & Health coach"
                else if (item.recommended_by_doctor == "Yes")
                    "Recommended by Doctor"
                else if (item.recommended_by_healthcoach == "Yes")
                    "Recommended by Health coach"
                else
                    ""

            if (recommendedLabel.isNotBlank()) {
                textViewRecommendedByDr.visibility = View.VISIBLE
                textViewRecommendedByDr.text = recommendedLabel
            } else {
                textViewRecommendedByDr.visibility = View.GONE
            }

            /*if (item.recommended_by_healthcoach == "Yes") {
                textViewRecommendedByHC.visibility = View.VISIBLE
                textViewRecommendedByHC.text = "Recommended by Health coach"
            } else {
                textViewRecommendedByHC.visibility = View.GONE
            }*/

            if (item.title.isNullOrBlank()) {
                textViewTitle.visibility = View.GONE
            } else {
                textViewTitle.visibility = View.VISIBLE
                textViewTitle.text = item.title
            }

            if (item.description.isNullOrBlank()) {
                textViewDescription.visibility = View.GONE
            } else {
                textViewDescription.visibility = View.VISIBLE
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    textViewDescription.text =
                        Html.fromHtml(item.description, Html.FROM_HTML_MODE_COMPACT)
                } else {
                    textViewDescription.text = Html.fromHtml(item.description)
                }
            }

            imageViewLike.isSelected = item.liked == "Y"
            imageViewBookmark.isSelected = item.bookmarked == "Y"

            textViewLikeCount.text = item.likeCount.kFormat()
            textViewCommentCount.text = item.getTotalComment.kFormat()

            layoutLike.isVisible = item.like_capability != Common.CapabilityYesNo.NO
            imageViewBookmark.isVisible = item.bookmark_capability != Common.CapabilityYesNo.NO

            imageViewComment.isVisible =
                AppFlagHandler.isToHideEngageDiscoverComments(firebaseConfigUtil).not()
            textViewCommentCount.isVisible =
                AppFlagHandler.isToHideEngageDiscoverComments(firebaseConfigUtil).not()

            //handle comments
            if (item.isSelected) {
                imageViewComment.isSelected = item.isSelected
                layoutComments.visibility = View.VISIBLE

                if (item.getTotalComment > 2) {
                    textViewViewAllComment.visibility = View.VISIBLE
                    textViewViewAllComment.text = "View all ${item.getTotalComment} comments"
                } else {
                    textViewViewAllComment.visibility = View.GONE
                }

                recyclerViewComments.apply {
                    layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                    adapter = EngageDiscoverFeedCommentsAdapter(userId, item.comment?.comment_data
                        ?: arrayListOf(), position, commentsAdapterListener)
                }
            } else {
                imageViewComment.isSelected = item.isSelected
                layoutComments.visibility = View.GONE
            }
        }
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int, payloads: MutableList<Any>) {
        super.onBindViewHolder(holder, position, payloads)
        val item = list[position]
        holder.binding.apply {

            if (payloads.isNotEmpty() && payloads.firstOrNull()?.toString() == "updateComment") {
                if (item.isSelected) {
                    imageViewComment.isSelected = item.isSelected
                    layoutComments.visibility = View.VISIBLE

                    if (item.getTotalComment > 2) {
                        textViewViewAllComment.visibility = View.VISIBLE
                        textViewViewAllComment.text = "View all ${item.getTotalComment} comments"
                    } else {
                        textViewViewAllComment.visibility = View.GONE
                    }

                    recyclerViewComments.apply {
                        layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
                        adapter =
                            EngageDiscoverFeedCommentsAdapter(userId, item.comment?.comment_data
                                ?: arrayListOf(), position, commentsAdapterListener)
                    }
                } else {
                    imageViewComment.isSelected = item.isSelected
                    layoutComments.visibility = View.GONE
                }
            } else if (payloads.isNotEmpty() && payloads.firstOrNull()
                    ?.toString() == "updateLike"
            ) {
                imageViewLike.isSelected = item.liked == "Y"
                textViewLikeCount.text = item.likeCount.kFormat()
            }

        }
    }

    override fun getItemCount(): Int = list.size

    var recyclerView: RecyclerView? = null
    override fun onAttachedToRecyclerView(recyclerView: RecyclerView) {
        super.onAttachedToRecyclerView(recyclerView)
        this.recyclerView = recyclerView
    }

    inner class ViewHolder(val binding: EngageRowDiscoverFeedBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                editTextAddAComment.setOnTouchListener { v, event ->
                    if (event.action == MotionEvent.ACTION_UP) {
                        Handler(Looper.getMainLooper()).postDelayed({
                            if (editTextAddAComment.hasFocus()) {
                                recyclerView?.smoothScrollBy(0, 40)
                            }
                        }, 300)
                    }
                    false
                }
                /*editTextAddAComment.setOnFocusChangeListener { v, hasFocus ->
                    if (hasFocus) {
                        Handler(Looper.getMainLooper()).postDelayed({
                            //recyclerView?.scrollBy(0, 20)
                            recyclerView?.smoothScrollBy(0,40)
                        }, 300)
                    }
                }*/

                editTextAddAComment.addTextChangedListener {
                    list[bindingAdapterPosition].strComment = it.toString()
                }

                imageViewPostComment.setOnClickListener {
                    if (activity.isFeatureAllowedAsPerPlan(PlanFeatures.commenting_on_articles)) {
                        if (editTextAddAComment.text.toString().trim().isNotBlank()) {

                            adapterListener.onPostCommentClick(bindingAdapterPosition,
                                editTextAddAComment.text.toString().trim())
                            { isSuccess ->
                                if (isSuccess) {
                                    editTextAddAComment.setText("")
                                    editTextAddAComment.clearFocus()
                                }
                            }

                        }
                    }

                    /*editTextAddAComment.setText("")
                    editTextAddAComment.clearFocus()*/
                }

                root.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                }
                imageViewComment.setOnClickListener {
                    list[bindingAdapterPosition].isSelected =
                        list[bindingAdapterPosition].isSelected.not()
                    notifyItemChanged(bindingAdapterPosition)
                }
                imageViewLike.setOnClickListener(SafeClickListener {
                    //imageViewLike.isSelected = imageViewLike.isSelected.not()
                    if (list[bindingAdapterPosition].liked == "Y") {
                        list[bindingAdapterPosition].liked = "N"
                        list[bindingAdapterPosition].likeCount =
                            (list[bindingAdapterPosition].likeCount ?: 0) - 1
                    } else {
                        list[bindingAdapterPosition].liked = "Y"
                        list[bindingAdapterPosition].likeCount =
                            (list[bindingAdapterPosition].likeCount ?: 0) + 1
                    }
                    notifyItemChanged(bindingAdapterPosition, "updateLike")

                    adapterListener.onLikeClick(bindingAdapterPosition)
                })
                /*imageViewLike.setOnClickListener {
                    //imageViewLike.isSelected = imageViewLike.isSelected.not()
                    if (list[bindingAdapterPosition].liked == "Y") {
                        list[bindingAdapterPosition].liked = "N"
                        list[bindingAdapterPosition].likeCount =
                            (list[bindingAdapterPosition].likeCount ?: 0) - 1
                    } else {
                        list[bindingAdapterPosition].liked = "Y"
                        list[bindingAdapterPosition].likeCount =
                            (list[bindingAdapterPosition].likeCount ?: 0) + 1
                    }
                    notifyItemChanged(bindingAdapterPosition, "updateLike")

                    adapterListener.onLikeClick(bindingAdapterPosition)
                }*/
                imageViewBookmark.setOnClickListener(SafeClickListener {
                    if (activity.isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                        imageViewBookmark.isSelected = imageViewBookmark.isSelected.not()
                        adapterListener.onBookmarkClick(bindingAdapterPosition)
                    }
                })
                imageViewShare.setOnClickListener {
                    adapterListener.onShareClick(bindingAdapterPosition)
                }
                buttonBookSeat.setOnClickListener {
                    adapterListener.onBookSeatClick(bindingAdapterPosition)
                }
                textViewViewAllComment.setOnClickListener {
                    adapterListener.onViewAllCommentsClick(bindingAdapterPosition)
                }
                layoutAddComment.setOnClickListener {
                    adapterListener.onViewAllCommentsClick(bindingAdapterPosition)
                }

                imageViewFeed.setOnClickListener {
                    /*if (list[bindingAdapterPosition].content_type != ContentTypes.KOL_VIDEOS.contentKey
                        && list[bindingAdapterPosition].content_type != ContentTypes.NORMAL_VIDEOS.contentKey
                    ) {
                        navigator.showImageViewerDialog(arrayListOf(list[bindingAdapterPosition].media?.firstOrNull()?.image_url
                            ?: ""))
                    }*/
                    adapterListener.onClick(bindingAdapterPosition)
                }
                /*layoutImageGallery.setOnClickListener {
                    adapterListener.onClick(bindingAdapterPosition)
                }*/
            }
        }
    }

    interface AdapterListener {
        fun onClick(position: Int)
        fun onViewAllCommentsClick(position: Int)
        fun onLikeClick(position: Int)
        fun onBookmarkClick(position: Int)
        fun onShareClick(position: Int)
        fun onPostCommentClick(
            position: Int,
            comment: String,
            postCommentStatusCallback: (isSuccess: Boolean) -> Unit,
        )

        fun onBookSeatClick(position: Int)
    }
}