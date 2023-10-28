package com.mytatva.patient.data.model

enum class ContentTypes constructor(val contentKey: String) {
    ARTICLE_BLOG("BlogArticle"),
    PHOTO_GALLERY("Photo"),
    KOL_VIDEOS("KOLVideo"),
    NORMAL_VIDEOS("Video"),
    WEBINAR("Webinar"),

    //others
    EXERCISE_VIDEO("ExerciseVideo"),
    EXERCISE_PLAN("ExercisePlan"),
}