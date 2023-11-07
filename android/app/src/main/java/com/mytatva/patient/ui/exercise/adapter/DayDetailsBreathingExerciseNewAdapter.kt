package com.mytatva.patient.ui.exercise.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.response.ExerciseBreathingDayData
import com.mytatva.patient.databinding.ExerciseRowDayDetailsBreathingExerciseContentBinding
import com.mytatva.patient.databinding.ExerciseRowDayDetailsBreathingExerciseVideoNewBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.imagepicker.loadArticleImage
import com.mytatva.patient.utils.kFormat

class DayDetailsBreathingExerciseNewAdapter(
    val activity: BaseActivity,
    var list: ArrayList<ExerciseBreathingDayData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    var planType: String = ""

    companion object {
        const val TYPE_VIDEO = 1
        const val TYPE_CONTENT = 2
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return if (viewType == TYPE_VIDEO) {
            val binding = ExerciseRowDayDetailsBreathingExerciseVideoNewBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )
            ViewHolderVideo(binding)
        } else {//TYPE_CONTENT
            val binding = ExerciseRowDayDetailsBreathingExerciseContentBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )
            ViewHolderContent(binding)
        }
    }

    override fun getItemViewType(position: Int): Int {
        return if (list[position].isDescriptionType) TYPE_CONTENT
        else TYPE_VIDEO
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val item = list[position]

        if (holder is ViewHolderVideo) {
            val context = holder.binding.root.context

            holder.binding.apply {
                imageViewFeed.loadArticleImage(item.content_data?.media?.firstOrNull()?.image_url
                    ?: "")
                textViewTitle.text = item.content_data?.title
                textViewDuration.text = "Duration : ${item.content_data?.time_duration} ${item.content_data?.duration_unit}"
                textViewDescription.text = item.content_data?.getHtmlFormattedDescription

                textViewReps.visibility = if (planType == Common.ExercisePlanType.CUSTOM)
                    View.VISIBLE
                else
                    View.INVISIBLE

                textViewReps.text = item.unit_no.plus(" ").plus(item.unit)

                layoutLike.isVisible =
                    item.content_data?.like_capability != Common.CapabilityYesNo.NO
                imageViewBookmark.isVisible =
                    item.content_data?.bookmark_capability != Common.CapabilityYesNo.NO


                textViewLikeCount.text = item.content_data?.likeCount?.kFormat()

                imageViewLike.isSelected = item.content_data?.liked == "Y"
                imageViewBookmark.isSelected = item.content_data?.bookmarked == "Y"

                textViewFitnessLevel.text = "Fitness level: " + item.content_data?.fitness_level
                textViewExerciseTool.text = "Exercise tool: " + item.content_data?.exercise_tools
            }

        } else if (holder is ViewHolderContent) {
            val context = holder.binding.root.context

            holder.binding.apply {
                textViewDescription.text = item.getHtmlFormattedDescription
            }
        }

    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolderVideo(val binding: ExerciseRowDayDetailsBreathingExerciseVideoNewBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewFeed.setOnClickListener {
                    adapterListener.onVideoItemClick(bindingAdapterPosition)
                }
                imageViewLike.setOnClickListener {
                    //imageViewLike.isSelected = imageViewLike.isSelected.not()

                    if (list[bindingAdapterPosition].content_data?.liked == "Y") {
                        list[bindingAdapterPosition].content_data?.liked = "N"
                        list[bindingAdapterPosition].content_data?.likeCount =
                            (list[bindingAdapterPosition].content_data?.likeCount ?: 0) - 1
                    } else {
                        list[bindingAdapterPosition].content_data?.liked = "Y"
                        list[bindingAdapterPosition].content_data?.likeCount =
                            (list[bindingAdapterPosition].content_data?.likeCount ?: 0) + 1
                    }
                    notifyItemChanged(bindingAdapterPosition)


                    adapterListener.onLikeClick(bindingAdapterPosition)
                }
                imageViewBookmark.setOnClickListener {
                    if (activity.isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                        imageViewBookmark.isSelected = imageViewBookmark.isSelected.not()
                        adapterListener.onBookmarkClick(bindingAdapterPosition)
                    }
                }
                imageViewInfo.setOnClickListener {
                    adapterListener.onInfoClick(bindingAdapterPosition)
                }
            }
        }
    }

    inner class ViewHolderContent(val binding: ExerciseRowDayDetailsBreathingExerciseContentBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {

            }
        }
    }

    interface AdapterListener {
        fun onVideoItemClick(position: Int)
        fun onLikeClick(position: Int)
        fun onBookmarkClick(position: Int)
        fun onInfoClick(position: Int)
    }
}