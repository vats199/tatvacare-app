package com.mytatva.patient.ui.exercise.adapter

import android.text.Html
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.DifficultyLevel
import com.mytatva.patient.data.pojo.response.RoutineExerciseData
import com.mytatva.patient.databinding.ExerciseRowMyRoutineListBinding
import com.mytatva.patient.ui.exercise.ExerciseMyRoutineFragment
import com.mytatva.patient.utils.imagepicker.loadArticleImage

class ExerciseMyRoutineListAdapter(
    private val arrayList: ArrayList<RoutineExerciseData>,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<ExerciseMyRoutineListAdapter.ViewHolder>() {

    inner class ViewHolder(val binding: ExerciseRowMyRoutineListBinding) :
        RecyclerView.ViewHolder(binding.root) {

        init {
            with(binding) {
                textViewReadMore.setOnClickListener {
                    adapterListener.onReadMoreClick(bindingAdapterPosition)
                }
                layoutDone.setOnClickListener {
                    adapterListener.onDoneClick(bindingAdapterPosition)
                }
                layoutDifficulty.setOnClickListener {
                    adapterListener.onDifficultyClick(bindingAdapterPosition)
                }
                imageViewFeed.setOnClickListener {
                    adapterListener.onPlayClick(bindingAdapterPosition)
                }
            }

        }

        fun bind(item: RoutineExerciseData) = with(binding) {
            imageViewFeed.loadArticleImage(item.media?.image_url ?: "")
            textViewTaskName.text = item.title
            textViewExerciseType.text = item.breathing_exercise
            textViewReps.text = item.reps
            textViewSets.text = item.sets
            textViewRestPostSet.text = item.rest_post_sets.plus(" ").plus(item.rest_post_sets_unit)
            textViewRestPostExercise.text =
                item.rest_post_exercise.plus(" ").plus(item.rest_post_exercise_unit)
            textViewDescription.text =
                Html.fromHtml(item.description, Html.FROM_HTML_MODE_COMPACT).toString()


            if (ExerciseMyRoutineFragment.isFutureDateSelected) {
                layoutDone.isVisible = false
                layoutDifficulty.isVisible = false
            } else {
                layoutDone.isVisible = true

                imageViewStatus.isSelected = item.done == "Y"
                imageViewDifficulty.isSelected = item.difficulty_level.isNullOrBlank().not()
                if (item.done == "Y") {
                    layoutDifficulty.isVisible = true

                    val difficultyLabel = StringBuilder()
                    difficultyLabel.append("Difficulty")
                    when (item.difficulty_level) {
                        DifficultyLevel.Difficult.title -> {
                            difficultyLabel.append(": ${DifficultyLevel.Difficult.title}")
                        }
                        DifficultyLevel.Easy.title -> {
                            difficultyLabel.append(": ${DifficultyLevel.Easy.title}")
                        }
                    }
                    textViewDifficulty.text = difficultyLabel.toString()

                } else {
                    layoutDifficulty.isVisible = false
                }
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        return ViewHolder(ExerciseRowMyRoutineListBinding.inflate(LayoutInflater.from(parent.context),
            parent,
            false))
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(arrayList[position])
    }

    override fun getItemCount(): Int = arrayList.size

    interface AdapterListener {
        fun onDoneClick(position: Int)
        fun onDifficultyClick(position: Int)
        fun onPlayClick(position: Int)
        fun onReadMoreClick(position: Int)
    }
}
