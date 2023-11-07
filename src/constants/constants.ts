import {colors} from './colors';

// import DeviceInfo from 'react-native-device-info';
export default {
  BUTTON_TYPE: {
    PRIMARY: 'primary',
    SECONDARY: 'secondary',
    TERTIARY: 'tertiary',
  },
  RISK_TYPE: {
    HIGH: 'high',
    MEDIUM: 'medium',
    LOW: 'low',
  },
  DATE_FORMAT: 'YYYY-MM-DD',
  EVENT_NAME: {
    FOOD_DIARY: {
      CLICKED_HEALTH_DIARY: 'CLICKED_HEALTH_DIARY',
      USER_CLICKS_ON_INSIGHT: 'USER_CLICKS_ON_INSIGHT',
      USER_CLICKS_ON_OPTION: 'USER_CLICKS_ON_OPTION',
      USER_CLICKED_ON_EDIT_MEAL: 'USER_CLICKED_ON_EDIT_MEAL',
      USER_CLICKED_ON_DELETE_MEAL: 'USER_CLICKED_ON_DELETE_MEAL',
      USER_CLICKED_ADD_FOOD_DISH: 'USER_CLICKED_ADD_FOOD_DISH',
      USER_SEARCHED_FOOD_DISH: 'USER_SEARCHED_FOOD_DISH',
      USER_SELECTED_FOOD_DISH: 'USER_SELECTED_FOOD_DISH',
      USER_ADDED_QUANTITY: 'USER_ADDED_QUANTITY',
      USER_ADDED_MEASURE: 'USER_ADDED_MEASURE',
      USER_LOGGED_MEAL: 'USER_LOGGED_MEAL',
      USER_CHANGES_MONTH: 'USER_CHANGES_MONTH',
      USER_CHANGES_DATE: 'USER_CHANGES_DATE',
      EXPAND_CALENDAR: 'EXPAND_CALENDAR',
    },
  },
  EVENT_DEFAULT_PARAMS: {
    PARAM_DEVICE_TYPE: 'device_type',
    PARAM_PATIENT_ID: 'patient_id',
    PARAM_LOG_DATE: 'log_date',
    PARAM_PATIENT_GENDER: 'patientGender',
    PARAM_PATIENT_INDICATION: 'patientIndication',
    PARAM_CURRENT_APP_VERSION: 'currentAppVersion',
    PARAM_ANDROID_VERSION: 'OS_Version',
    PARAM_SCREEN_RESOLUTION: 'screenResolution',
    PARAM_DOCTOR_ID: 'doctorId',
    PARAM_DOCTOR_SPECIALIZATION: 'doctorSpecialization',
    PARAM_HEALTH_COACH_IDS: 'healthCoachId',
    PARAM_HEALTH_COACH_SPECIALIZATION: 'HealthCoachSpecialization',
    PARAM_CITY: 'city',
    PARAM_EMAIL_VERIFIED: 'emailVerified',
    PARAM_CURRENT_PLAN_NAME: 'current_plan_name',
    PARAM_CURRENT_PLAN_TYPE: 'current_plan_type',
    PARAM_CURRENT_PLAN_ID: 'current_plan_id',
    PARAM_SCREEN_NAME: 'ScreenName',
  },
};
