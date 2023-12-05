apply("../node_modules/@react-native-community/cli-platform-android/native_modules.gradle")

val applyNativeModules: groovy.lang.Closure<Any> =
    extra.get("applyNativeModulesSettingsGradle") as groovy.lang.Closure<Any>
applyNativeModules(settings)

include(":app", ":library", ":barcode-reader", ":showcaseviewlib", ":horizontalcalendar")
includeBuild("../node_modules/@react-native/gradle-plugin")



