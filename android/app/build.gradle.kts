import com.android.build.gradle.internal.cxx.configure.gradleLocalProperties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("kotlin-kapt")
    //id("kotlin-android-extensions")
    id("kotlin-parcelize")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.firebase-perf")
    id("com.facebook.react")
    id("org.sonarqube") version "3.3"
}

android {
    compileSdkVersion(Config.SdkVersions.compile)

    lintOptions {
        isAbortOnError = false
    }
    defaultConfig {
        configurations.all {
            resolutionStrategy {
                force("androidx.work:work-runtime:2.6.0")
            }
        }


        applicationId = Config.applicationId
        minSdkVersion(Config.SdkVersions.min)
        targetSdkVersion(Config.SdkVersions.target)
        versionCode = Config.ApkVersion.versionCode
        versionName = Config.ApkVersion.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        // Twilio details to test from local declared fields
        /*buildConfigField("String",
            "TWILIO_ACCESS_TOKEN",
            gradleLocalProperties(rootProject.rootDir).getProperty("TWILIO_ACCESS_TOKEN",
                "\"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzk5NmZmNGFhYzBlNDI2YWVhNDNkMTA0MmZjZjFlNzcyLTE2NDY2NTc0MjQiLCJpc3MiOiJTSzk5NmZmNGFhYzBlNDI2YWVhNDNkMTA0MmZjZjFlNzcyIiwic3ViIjoiQUNiOWRmYWU4NjVkZjc5MTEyNWQ4NjNkMjY5OWI4MzY4ZiIsImV4cCI6MTY0NjY2MTAyNCwiZ3JhbnRzIjp7ImlkZW50aXR5IjoiUGFydGhUZXN0T25lIiwidmlkZW8iOnsicm9vbSI6Ik15VGF0dmFUZXN0Um9vbSJ9fX0.slPS7aCYiL7GB76hF0Z7mn7ELOCakeolqDOJKUMe_os\""))
        buildConfigField("String",
            "TWILIO_ACCESS_TOKEN_SERVER",
            gradleLocalProperties(rootProject.rootDir).getProperty("TWILIO_ACCESS_TOKEN_SERVER",
                "\"http://localhost:3000\""))
        buildConfigField("boolean",
            "USE_TOKEN_SERVER",
            gradleLocalProperties(rootProject.rootDir).getProperty("USE_TOKEN_SERVER", "${false}"))*/

        //freshdesk
        buildConfigField(
            "String", "freshdesk_domain",
            gradleLocalProperties(rootProject.rootDir).getProperty(
                "freshdesk_domain",
                "\"msdk.in.freshchat.com\""
            )
        )
        buildConfigField(
            "String", "freshdesk_app_key",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty("freshdesk_app_key", "\"2406dd59-8906-4de6-974e-71339d54ae44\"")
        )
        buildConfigField(
            "String", "freshdesk_app_id",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty("freshdesk_app_id", "\"ba3cb466-dd9f-4c03-b9e9-2bd0646989dc\"")
        )

        //Lifetron SDK BCA
        buildConfigField(
            "String", "LIFETRON_APP_ID",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty("LIFETRON_APP_ID", "\"7519120009406205295\"")
        )
        buildConfigField(
            "String", "LIFETRON_SDK_CONFIG",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty(
                    "LIFETRON_SDK_CONFIG",
                    "\"aebeb6bce4dc7ecec7e3083f2a292e494ff8ec2f690c338b576a9827db8e0b0f7474324e1c90ea74b9d552395a14acdba1cad03035b0ae4f01850f60db962d37ebd29f4aa91242dc08febf7d0344077a8175fcaff43e7157f3c02be65df0da5b9497c669cc71d4cbbae9a2db7e701ba9a6e6584e1a8ab9d4372ac728a4bf701309a166ce46e231ddd0bd59c94ca84e4ba843dfccb41129b260f56b34f5a1a6db\""
                )
        )

        /* **** Production Lifetron SDK config(Expiry Date:18-Jul-2025) *********
         * aebeb6bce4dc7ecec7e3083f2a292e494ff8ec2f690c338b576a9827db8e0b0f7474324e1c90ea74b9d552395a14acdba1cad03035b0ae4f01850f60db962d37ebd29f4aa91242dc08febf7d0344077a8175fcaff43e7157f3c02be65df0da5b9497c669cc71d4cbbae9a2db7e701ba9a6e6584e1a8ab9d4372ac728a4bf701309a166ce46e231ddd0bd59c94ca84e4ba843dfccb41129b260f56b34f5a1a6db
         * *********************************************************************/

        /* **** Testing Lifetron SDK config old *********
         * aebeb6bce4dc7ecec7e3083f2a292e494ff8ec2f690c338b576a9827db8e0b0f7474324e1c90ea74b9d552395a14acdba1cad03035b0ae4f01850f60db962d37ebd29f4aa91242dc08febf7d0344077a8175fcaff43e7157f3c02be65df0da5b9497c669cc71d4cbbae9a2db7e701ba9373ea9ff5d10d82c64510189a7cb4247affac5e78d59a21bab0d8e770b23e01f5bf8b971a007c551a56e4bf7992667e3af13a251931375f67a080d52cf10ac58
         * *********************************************************************/

        //Spirometer SDK development
        buildConfigField(
            "String", "SPIROMETER_CLIENT_ID",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty("SPIROMETER_CLIENT_ID", "\"791k0ri37hb9vkf3cl1upkq3v\"")
        )
        buildConfigField(
            "String", "SPIROMETER_SERVER_KEY",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty(
                    "SPIROMETER_SERVER_KEY",
                    "\"10n7j0lngtjab2vua1a2b1o0bhub689u0cq5jg1rprjgb8l3amvi\""
                )
        )
        buildConfigField(
            "int", "SPIROMETER_ACCOUNT_ID",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty("SPIROMETER_ACCOUNT_ID", "19")
        )

        //Spirometer SDK production
        buildConfigField(
            "String", "SPIROMETER_CLIENT_ID_PROD",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty("SPIROMETER_CLIENT_ID_PROD", "\"60jevt604heidhv8d41tc11l84\"")
        )
        buildConfigField(
            "String", "SPIROMETER_SERVER_KEY_PROD",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty(
                    "SPIROMETER_SERVER_KEY_PROD",
                    "\"tbluth3rm550alckrol7bhcv2d8ue9sq2i6d53e0nguifgakfie\""
                )
        )
        buildConfigField(
            "int", "SPIROMETER_ACCOUNT_ID_PROD",
            gradleLocalProperties(rootProject.rootDir)
                .getProperty("SPIROMETER_ACCOUNT_ID_PROD", "16")
        )

        resValue("string", "google_api_id", "AIzaSyDY5VJ4HSQugDGvirtP75Uv-Wx1Z15J6Wc")
    }

    signingConfigs {
        getByName("debug") {
            storeFile = file("debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }

        create("release") {
            storeFile = file("com.mytatva.patient.jks")
            storePassword = "com.mytatva.patient"
            keyAlias = "com.mytatva.patient"
            keyPassword = "com.mytatva.patient"
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
            isDebuggable = true
        }
        getByName("release") {
            isMinifyEnabled = true
            isDebuggable = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
        }
    }
    viewBinding {
        android.buildFeatures.viewBinding = true
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    splits {
        // Specify that we want to split up the APK based on ABI
        abi {
            // Enable ABI split
            isEnable = true

            // Clear list of ABIs
            reset()

            // Specify each architecture currently supported by the Video SDK
            include("armeabi-v7a", "arm64-v8a", "x86", "x86_64")

            // Specify that we do not want an additional universal SDK
            isUniversalApk = true
        }

    }
}

/**
 * This block used for build Src to dependencies
 */
dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))
    implementation(files("libs/libLifetronsSdk-v2.2.aar"))
    //implementation(files("libs/alveoairV24.aar"))
    implementation(files("libs/alveoairProdV4.aar"))
    implementation(project(mapOf("path" to ":library")))
    implementation(project(mapOf("path" to ":barcode-reader")))
    implementation(project(mapOf("path" to ":showcaseviewlib")))
    implementation(project(mapOf("path" to ":horizontalcalendar")))

    //androidTestImplementation("android.arch.core:core-testing:1.1.1")

    // This part for appcompat and constraint layout
    coreLib()

    // This part for coroutines
    coroutines()

    // This part for dagger
    dagger()

    // Lifecycle components
    lifeCycle()

    // This part for retrofit
    retrofit()

    // Azure storage SDK
    azureStorage()

    // Firebase SDK
    firebase()

    // Google places and gms services
    googlePlaces()

    //ApXor SDK
    //If you are using firebase-messaging version >= 22.0.0, follow below steps
    // Add this to track uninstalls and send push notifications from Apxor dashboard
    implementation("com.apxor.androidx:apxor-android-sdk-push-v2:1.2.9@aar") {
        exclude(group = "com.google.firebase")
    }
//    apXorAndroidStaging()
    apXorAndroidx()

    // Glide
    implementation("com.github.bumptech.glide:glide:4.12.0") {
        exclude(group = "com.android.support")
    }
    implementation("com.github.bumptech.glide:okhttp3-integration:4.12.0")
    kapt("com.github.bumptech.glide:compiler:4.12.0")

    // biometric
    implementation("androidx.biometric:biometric:1.1.0")

    // alerter
    implementation("com.github.tapadoo:alerter:7.1.0")

    // ucrop
    implementation("com.github.yalantis:ucrop:2.2.6")

    // pager dots indicator
    implementation("com.tbuonomo:dotsindicator:4.2")

    // mpchart
    implementation("com.github.PhilJay:MPAndroidChart:3.1.0")

    // lottie animation
    implementation("com.airbnb.android:lottie:4.2.0")

    //exoplayer
    implementation("com.google.android.exoplayer:exoplayer:2.15.1")
    implementation("com.google.android.exoplayer:extension-mediasession:2.15.1")

    //google flexbox layout
    implementation("com.google.android.flexbox:flexbox:3.0.0")

    //survey sparrow
    implementation("com.github.surveysparrow:surveysparrow-android-sdk:0.4.3")

    //webengage
    implementation("com.webengage:android-sdk:4.3.0")//3.18.7,3.20.4,3.21.0,4.0.1
    implementation("com.android.installreferrer:installreferrer:2.2")
    /*implementation("androidx.work:work-runtime-ktx:2.6.0"){
        version {
            strictly("2.6.0")
        }
        //isForce = true
    }*/

    //circular progress indicator
    implementation("com.github.antonKozyriatskyi:CircularProgressIndicator:1.3.0")

    //for material calendar & localdate
    implementation("com.jakewharton.threetenabp:threetenabp:1.1.1")

    //progress view
    implementation("com.github.guilhe:circular-progress-view:2.0.0")

    //freshdesk-freshchat
    implementation("com.github.freshdesk:freshchat-android:5.3.0")
    implementation("androidx.localbroadcastmanager:localbroadcastmanager:1.0.0")

    //razorpay
    implementation("com.razorpay:checkout:1.6.15")

    //range time picker
    implementation("com.wdullaer:materialdatetimepicker:4.1.2")

    //twilio
    implementation("com.twilio:audioswitch:1.1.5")
    implementation("com.twilio:video-android-ktx:7.5.1")//6.4.1
    implementation("com.koushikdutta.ion:ion:2.1.8")

    //android palette
    implementation("androidx.palette:palette-ktx:1.0.0")

    //PDF Viewer
    //implementation ("com.github.barteksc:android-pdf-viewer:2.8.0")

    //conscrypt
    //implementation("org.conscrypt:conscrypt-android:2.5.0")

    //spirometer required dependencies
    implementation("androidx.security:security-crypto:1.0.0")
    implementation("android.arch.persistence.room:runtime:1.1.1")
    annotationProcessor("android.arch.persistence.room:compiler:1.1.1")
    implementation("com.amplitude:android-sdk:2.34.0")
    implementation("no.nordicsemi.android:dfu:2.0.2")
    implementation("no.nordicsemi.android:log:2.2.0")
    implementation("no.nordicsemi.android.support.v18:scanner:1.6.0")
    implementation("no.nordicsemi.android:ble-common:2.5.1")

    //WheelPicker
    implementation("cn.aigestudio.wheelpicker:WheelPicker:1.1.3")

    implementation("com.facebook.react:react-android")
    implementation("com.facebook.react:hermes-android")
    implementation("org.webkit:android-jsc:+")
}

apply("../../node_modules/@react-native-community/cli-platform-android/native_modules.gradle");
val applyNativeModules: groovy.lang.Closure<Any> =
    extra.get("applyNativeModulesAppBuildGradle") as groovy.lang.Closure<Any>
applyNativeModules(project)

/*apply(from = "/Users/thecodingstudio/Documents/MyTatva_Android_RN/node_modules/@react-native-community/cli-platform-android/native_modules.gradle")
val applyNativeModules: groovy.lang.Closure<Any> = extra.get("applyNativeModulesSettingsGradle") as groovy.lang.Closure<Any>
applyNativeModules(project)*/


/*
apply("../../node_modules/@react-native-community/cli-platform-android/native_modules.gradle")
applyNativeModulesAppBuildGradle(project)*/
