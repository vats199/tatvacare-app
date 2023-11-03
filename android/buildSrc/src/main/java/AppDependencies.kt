import org.gradle.api.artifacts.dsl.DependencyHandler
import org.gradle.kotlin.dsl.apply

/**
 * This block used for lifecycle dependencies
 */
fun DependencyHandler.lifeCycle() {
    add("implementation",
        "androidx.lifecycle:lifecycle-runtime-ktx:${Config.Versions.lifecycleVersion}")
    add("implementation",
        "androidx.lifecycle:lifecycle-extensions:${Config.Versions.lifecycleExtVersion}")
    add("implementation",
        "androidx.lifecycle:lifecycle-reactivestreams-ktx:${Config.Versions.lifecycleVersion}")
    add("implementation",
        "androidx.lifecycle:lifecycle-viewmodel-ktx:${Config.Versions.lifecycleVersion}")
    add("implementation",
        "androidx.lifecycle:lifecycle-common-java8:${Config.Versions.lifecycleVersion}")

}

/**
 * This block used for coreLib dependencies
 */
fun DependencyHandler.coreLib() {
    add("implementation", "androidx.appcompat:appcompat:${Config.Versions.appcompatVersion}")
    // For loading and tinting drawables on older versions of the platform
    add("implementation",
        "androidx.appcompat:appcompat-resources:${Config.Versions.appcompatVersion}")
    add("implementation", "com.google.android.material:material:${Config.Versions.materialVersion}")
    add("implementation",
        "androidx.constraintlayout:constraintlayout:${Config.Versions.constrentLayoutVersion}")
    add("implementation", "androidx.core:core-ktx:${Config.Versions.androidxCoreVersion}")
    add("implementation",
        "androidx.swiperefreshlayout:swiperefreshlayout:${Config.Versions.androidxSwipeRefreshLayoutVersion}")
}

/**
 * This block used for coroutines dependencies
 */
fun DependencyHandler.coroutines() {
    add("implementation",
        "org.jetbrains.kotlinx:kotlinx-coroutines-core:${Config.Versions.coroutinesVersion}")
    add("implementation",
        "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Config.Versions.coroutinesVersion}")
}

/**
 * This block used for dagger dependencies
 */
fun DependencyHandler.dagger() {
    add("implementation",
        "com.google.dagger:dagger-android-support:${Config.Versions.daggerVersion}")
    add("kapt", "com.google.dagger:dagger-android-processor:${Config.Versions.daggerVersion}")
    add("kapt", "com.google.dagger:dagger-compiler:${Config.Versions.daggerVersion}")
    add("annotationProcessor", "com.google.dagger:dagger-android-processor:${Config.Versions.daggerVersion}")
    add("annotationProcessor", "com.google.dagger:dagger-compiler:${Config.Versions.daggerVersion}")
    add("kapt", "org.jetbrains.kotlinx:kotlinx-metadata-jvm:0.5.0")

}

/**
 * This block used for retrofit dependencies
 */
fun DependencyHandler.retrofit() {
    add("implementation", "com.squareup.retrofit2:retrofit:${Config.Versions.retrofitVersion}")
    add("implementation",
        "com.squareup.retrofit2:converter-gson:${Config.Versions.retrofitVersion}")
    add("implementation",
        "com.squareup.okhttp3:logging-interceptor:${Config.Versions.okHttpLogerVersion}")
}

/**
 * This block used for firebase dependencies
 */
fun DependencyHandler.firebase() {
    add("implementation",
        platform("com.google.firebase:firebase-bom:${Config.Versions.firebaseBomVersion}"))
    add("implementation", "com.google.firebase:firebase-crashlytics-ktx")
    add("implementation", "com.google.firebase:firebase-analytics-ktx")
    add("implementation", "com.google.firebase:firebase-messaging-ktx")
    add("implementation", "com.google.firebase:firebase-dynamic-links-ktx")
    add("implementation", "com.google.firebase:firebase-perf-ktx")
    add("implementation", "com.google.firebase:firebase-config-ktx")
    //add("implementation", "com.google.firebase:firebase-auth")
}

/**
 * This block used for google location
 */
fun DependencyHandler.googlePlaces() {
    add("implementation", "com.google.android.gms:play-services-base:17.6.0")
    add("implementation", "com.google.android.gms:play-services-location:18.0.0")
    add("implementation", "com.google.android.gms:play-services-maps:17.0.1")
    add("implementation", "com.google.android.gms:play-services-fitness:20.0.0")
    add("implementation", "com.google.android.gms:play-services-auth:19.2.0")
    add("implementation", "com.google.android.gms:play-services-auth-api-phone:17.4.0")

    //add("implementation", "com.google.android.libraries.places:places:2.4.0")
//
//    add("implementation", "com.google.maps:google-maps-services:0.2.7")
//    add("implementation", "com.google.maps.android:android-maps-utils:0.5")

//    Easy Permission
//    implementation("com.vmadalin:easypermissions-ktx:1.0.0")
//    add("implementation","com.github.mukeshsolanki:Google-Places-AutoComplete-EditText:0.0.8")
    add("implementation", "com.google.android.libraries.places:places:2.4.0")
//    implementation("com.github.mukeshsolanki:Google-Places-AutoComplete-EditText:0.0.8")
//    implementation("com.google.android.libraries.places:places:2.7.0")
}

/**
 * This block used for azure storage
 */
fun DependencyHandler.azureStorage() {
    add("implementation", "com.microsoft.azure.android:azure-storage-android:2.0.0@aar")
}


fun DependencyHandler.apXorAndroidx() {
    //If you are using firebase-messaging version >= 22.0.0, follow below steps
    // Add this to track uninstalls and send push notifications from Apxor dashboard
    add("implementation","com.apxor.androidx:apxor-android-sdk-push-v2:1.2.9@aar")

    add("implementation", "com.apxor.androidx:apxor-android-sdk-core:2.9.3@aar")
    add("implementation", "com.apxor.androidx:apxor-android-sdk-qe:1.5.8@aar")
    add("implementation", "com.apxor.androidx:apxor-android-sdk-rtm:2.1.8@aar")
    add("implementation", "com.apxor.androidx:surveys:1.3.9@aar")
    add("implementation", "com.apxor.androidx:apxor-android-crash-reporter:1.0.5@aar")
    add("implementation", "com.apxor.androidx:wysiwyg:1.3.8@aar")
    add("implementation", "com.apxor.androidx:jit-log:1.0.0@aar")
}

fun DependencyHandler.apXorAndroidStaging() {

    add("implementation", "com.apxor.androidx:staging-core:2.7.7@aar")

    // Add these for Realtime Actions and Surveys
    add("implementation", "com.apxor.androidx:staging-qe:1.4.3@aar")
    add("implementation", "com.apxor.androidx:staging-rtm:1.7.0@aar")
    add("implementation", "com.apxor.androidx:staging-surveys:1.3.1@aar")

    // Add this to track application crashes
    add("implementation", "com.apxor.androidx:staging-crash-reporter:1.0.5@aar")

    // Helper plugin to create walkthroughs
    add("implementation", "com.apxor.androidx:staging-wysiwyg:1.1.9@aar")

    // Add this to log events without attributes at runtime
    add("implementation", "com.apxor.androidx:staging-jit-log:1.0.0@aar")
}
