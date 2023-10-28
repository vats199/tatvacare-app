package com.mytatva.patient.data.model

import androidx.annotation.StringRes
import com.mytatva.patient.R

enum class SettingsItem constructor(@StringRes val settingItem: Int, val icon: Int) {
    //Profile(R.string.account_setting_item_profile, R.drawable.ic_setting_profile),
    //Goals(R.string.account_setting_item_goals_vitals, R.drawable.ic_setting_goals),
    //Plans("Plans", R.drawable.ic_setting_plans),
    //CareTeam("Care team", R.drawable.ic_setting_care_team),
    ConnectedDevices(R.string.account_setting_item_connected_devices, R.drawable.ic_setting_connected_devices),
    NotificationSettings(R.string.account_setting_item_notification_settings, R.drawable.ic_setting_notification),
    //UpdateLocation(R.string.account_setting_item_update_location, R.drawable.ic_setting_location_gray),
    //UpdateHeightWeight(R.string.account_setting_item_update_height_weight, R.drawable.ic_setting_height_weight),
    DeleteMyAccount(R.string.account_setting_item_delete_my_account, R.drawable.ic_delete_account),
    LogOut(R.string.account_setting_item_logout, R.drawable.ic_setting_logout_grey)
}