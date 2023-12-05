// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    extra.apply {
        set("buildToolsVersion", "33.0.0")
        set("minSdkVersion", 24)
        set("compileSdkVersion", 34)
        set("targetSdkVersion", 34)
    }

    repositories {
        google()
        mavenCentral()
        // added for horizontal calendar view module
        maven {
            url = uri("https://plugins.gradle.org/m2/")
        }
        maven {
            url = uri("$rootDir/../node_modules/jsc-android/dist")
        }
    }
    dependencies {
        classpath("com.android.tools.build:gradle:${Config.Versions.gradleVersion}")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:${Config.Versions.kotlinVersion}")
        classpath("com.google.gms:google-services:${Config.Versions.googleServiceVersion}")
        classpath("com.google.firebase:firebase-crashlytics-gradle:${Config.Versions.gradleFirebaseCrashlyticsVersion}")
        classpath("com.google.firebase:perf-plugin:1.4.1")
        classpath("com.github.dcendents:android-maven-gradle-plugin:2.0")
        classpath("com.jfrog.bintray.gradle:gradle-bintray-plugin:1.8.4")
        //classpath("org.sonarsource.scanner.gradle:sonarqube-gradle-plugin:3.3")
        classpath("com.facebook.react:react-native-gradle-plugin")
    }


}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            setUrl("https://jitpack.io")
        }
        maven {
            setUrl("https://repo.apxor.com/artifactory/list/libs-release-android/")
        }
        jcenter()
    }

}

tasks.register(name = "type", type = Delete::class) {
    delete(rootProject.buildDir)
}


