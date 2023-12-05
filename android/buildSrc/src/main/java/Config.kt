object Config {
    val applicationId = "com.mytatva.patient"

    /**
     * This block used for dependency, classpath and kapt version etc
     */
    object Versions {
        val kotlinVersion = "1.7.22"
        val gradleVersion = "4.1.3"
        val lifecycleVersion = "2.5.0"
        val lifecycleExtVersion = "2.2.0"
        val appcompatVersion = "1.3.1"
        val materialVersion = "1.4.0"
        val constrentLayoutVersion = "2.1.0"
        val coroutinesVersion = "1.4.3"
        val daggerVersion = "2.43.2"
        val retrofitVersion = "2.9.0"
        val okHttpLogerVersion = "4.9.1"
        val androidxCoreVersion = "1.6.0"
        val firebaseBomVersion = "28.4.0"
        val googleServiceVersion = "4.3.14"
        val gradleFirebaseCrashlyticsVersion = "2.7.1"
        val androidxSwipeRefreshLayoutVersion = "1.1.0"
    }

    /**
     * This block used for sdk version control
     */
    object SdkVersions {
        val compile = 34
        val target = 34
        val min = 24
    }

    /**
     * This block used for apk version control
     */
    object ApkVersion {
        val versionCode = 97
        val versionName = "2.0.8"
    }

}