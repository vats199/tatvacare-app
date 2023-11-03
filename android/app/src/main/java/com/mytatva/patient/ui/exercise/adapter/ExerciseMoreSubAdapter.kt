package com.mytatva.patient.ui.exercise.adapter

import android.os.Build
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.res.ResourcesCompat
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.response.ContentData
import com.mytatva.patient.databinding.ExerciseRowMoreSubBinding
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.imagepicker.loadArticleImage
import com.mytatva.patient.utils.kFormat

class ExerciseMoreSubAdapter(
    val activity: BaseActivity,
    val mainPosition: Int,
    val userId: String,
    var list: ArrayList<ContentData>,
    val adapterListener: AdapterListener,
    val isExerciseOfTheWeek: Boolean=false,
) : RecyclerView.Adapter<ExerciseMoreSubAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ExerciseRowMoreSubBinding.inflate(
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

            layoutSubRoot.foreground = if (isExerciseOfTheWeek)
                ResourcesCompat.getDrawable(context.resources, R.drawable.bg_rounded_rect_theme_stroke_10, null)
            else
                null

            imageViewFeed.loadArticleImage(item.media?.firstOrNull()?.image_url ?: "")
            textViewTitle.text = item.title
            if (item.description.isNullOrBlank()) {
                textViewDescription.visibility = View.INVISIBLE
            } else {
                textViewDescription.visibility = View.VISIBLE
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    textViewDescription.text =
                        Html.fromHtml(item.description, Html.FROM_HTML_MODE_COMPACT).toString()
                } else {
                    textViewDescription.text = Html.fromHtml(item.description).toString()
                }
            }
            //textViewDescription.setLineSpacing()
            textViewDuration.text = "Duration : ${item.time_duration} ${item.duration_unit}"

            layoutLike.isVisible = item.like_capability != Common.CapabilityYesNo.NO
            imageViewBookmark.isVisible = item.bookmark_capability != Common.CapabilityYesNo.NO

            textViewLikeCount.text = item.likeCount.kFormat()

            imageViewLike.isSelected = item.liked == "Y"
            imageViewBookmark.isSelected = item.bookmarked == "Y"

            textViewFitnessLevel.text = "Fitness level: " + item.fitness_level
            textViewExerciseTool.text = "Exercise tool: " + item.exercise_tools
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: ExerciseRowMoreSubBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                imageViewLike.setOnClickListener {
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
                    notifyItemChanged(bindingAdapterPosition)
                    adapterListener.onLikeClick(mainPosition, bindingAdapterPosition)
                }
                imageViewBookmark.setOnClickListener {
                    if (activity.isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                        imageViewBookmark.isSelected = imageViewBookmark.isSelected.not()
                        adapterListener.onBookmarkClick(mainPosition, bindingAdapterPosition)
                    }
                }
                imageViewFeed.setOnClickListener {
                    adapterListener.onPlayClick(mainPosition, bindingAdapterPosition)
                }
                imageViewInfo.setOnClickListener {
                    adapterListener.onInfoClick(mainPosition, bindingAdapterPosition)
                }
            }
        }
    }

    interface AdapterListener {
        fun onLikeClick(mainPosition: Int, position: Int)
        fun onBookmarkClick(mainPosition: Int, position: Int)
        fun onPlayClick(mainPosition: Int, position: Int)
        fun onInfoClick(mainPosition: Int, position: Int)
    }
}