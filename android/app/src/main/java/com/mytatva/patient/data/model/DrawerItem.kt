package com.mytatva.patient.data.model

import com.mytatva.patient.R

enum class DrawerItem constructor(val drawerItem: String, val colorRes: Int, val icon: Int) {
    //FoodDiary("Food Diary", R.color.colorPrimary, R.drawable.ic_menu_food_diary),

    //OrderTests("Order Tests", R.color.colorPrimary, R.drawable.ic_order_tests),
    MyTatvaPlans("MyTatva Plans", R.color.colorPrimary, R.drawable.ic_menu_mytatva_plans),

    TransactionHistory("Transaction History", R.color.colorPrimary, R.drawable.ic_menu_payment_history),

    DefineYourGoals("Define Your Goals", R.color.colorPrimary, R.drawable.ic_menu_deine_goals),
    GoalsAndHealthTrends("Goals and Health Trends", R.color.colorPrimary, R.drawable.ic_menu_goals_health_trends),

    DiagnosticReports("Diagnostic Report(s)", R.color.colorPrimary, R.drawable.ic_menu_diagnostic_reports_new),

    //YourBadges("Your Badges", R.color.colorPrimary, R.drawable.ic_badges),
    Bookmarks("Bookmarks", R.color.colorPrimary, R.drawable.ic_bookmarks),
    History("History", R.color.colorPrimary, R.drawable.ic_menu_history),
    /*BookAppointment("Book Appointment", R.color.colorPrimary, R.drawable.ic_date_calendar),
    BookYourTest("Book Your Test", R.color.colorPrimary, R.drawable.ic_book_test),*/
    AppTour("App Tour", R.color.colorPrimary, R.drawable.ic_drawer_app_tour),
    ShareApp("Share App", R.color.colorPrimary, R.drawable.ic_share_app),
    RateApp("Rate App", R.color.colorPrimary, R.drawable.ic_rate_app),
    //ReportIncident("Report incident", R.color.pink1, R.drawable.ic_report),
    ContactUs("Contact Us", R.color.colorPrimary, R.drawable.ic_menu_contact_us),

    //FAQs("FAQs", R.color.textBlack1, R.drawable.ic_menu_faq),
    TermsConditions("Terms & Conditions", R.color.colorPrimary, R.drawable.ic_menu_tnc),
    PrivacyPolicy("Privacy Policy", R.color.colorPrimary, R.drawable.ic_menu_privacy_policy),
    /*LogOut("Log out", R.color.textBlack1, R.drawable.ic_logout_black)*/
}