package com.mytatva.patient.utils

import android.content.Context
import android.content.res.Configuration
import java.util.Locale

class LocaleHelper {
    companion object {

        /*        private const val PREF_LANGUAGE = "pref_language"

                fun getLanguage(context: Context?): Language {
                    val preferencesName = context?.getString(R.string.preferences_name)
                    val preferences = context?.getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
                    val languageString = preferences?.getString(PREF_LANGUAGE, null)
                    if (languageString != null) {
                        val language = Gson().fromJson(languageString, Language::class.java)
                        if (language != null) {
                            return language
                        }
                    }
                    return getDefaultLanguage()
                }

                @SuppressLint("ApplySharedPref")
                fun saveLanguage(context: Context, index: Int) {
                    val preferencesName = context.getString(R.string.preferences_name)
                    val preferences = context.getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
                    val language = getSupportedLanguages()[index]
                    val languageString = Gson().toJson(language, Language::class.java)
                    if (languageString != null) {
                        preferences.edit().putString(PREF_LANGUAGE, languageString).apply()
                    } else {
                        preferences.edit().putString(PREF_LANGUAGE, "").apply()
                    }
                }

                fun getDefaultLanguage(): Language {
                    return getSupportedLanguages()[0]
                }

                private fun getSupportedLanguages(): List<Language> {
                    val languages = ArrayList<Language>()
                    languages.add(Language(1, "english", "English", BuildConfig.en))
                    languages.add(Language(2, "arabic", "Arabic", BuildConfig.ar))
                    return languages
                }

                fun setLocale(context: Context?): Context? {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        return updateResources(context, getLanguage(context))
                    }
                    return updateResourcesLegacy(context, getLanguage(context))
                }

                fun setNewLocale(context: Context, index: Int): Context? {
                    saveLanguage(context, index)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        return updateResources(context, getLanguage(context))
                    }
                    return updateResourcesLegacy(context, getLanguage(context))
                }

                fun getLanguageFromCode(languageCode: String): Language {
                    var language1 = getDefaultLanguage()
                    for (language in getSupportedLanguages()) {
                        if (language.code == languageCode) {
                            language1 = language
                            break
                        }
                    }
                    return language1
                }

                @TargetApi(Build.VERSION_CODES.N)
                private fun updateResources(context: Context?, language: Language): Context? {
                    val locale = Locale(language.code)
                    Locale.setDefault(locale)

                    //val configuration = context.resources.configuration
                    val configuration = Configuration()
                    configuration.setLocale(locale)
                    configuration.fontScale = 1.0f

                    return context?.createConfigurationContext(configuration)
                }

                private fun updateResourcesLegacy(context: Context?, language: Language): Context? {
                    val locale = Locale(language.code)
                    Locale.setDefault(locale)

                    val resources = context?.resources

                    val configuration = Configuration()
                    //val configuration = resources.configuration
                    configuration.locale = locale
                    configuration.fontScale = 1.0f

                    resources?.updateConfiguration(configuration, resources.displayMetrics)

                    return context
                }

                fun isRTL(context: Context): Boolean {
                    return context.resources.configuration.layoutDirection == View.LAYOUT_DIRECTION_RTL
                }

                fun getDeviceCountryCode(): String {
                    return Locale.getDefault().country
                }*/


        fun updateConfig(context: Context?): Context? {
            val locale = Locale.getDefault()
            Locale.setDefault(locale)

            //val configuration = context.resources.configuration
            val configuration = Configuration()
            configuration.setLocale(locale)
            configuration.fontScale = 1.0f

            return context?.createConfigurationContext(configuration)
        }

    }
}
