import {string} from 'yup';

//bmr_details
interface BMRDetails {
  activity_level: string;
  bmr: string;
  created_at: string;
  current_weight: string;
  goal_weight: string;
  height: string;
  is_active: string;
  is_deleted: string;
  months: string;
  patient_goal_weight_rel_id: string;
  patient_id: string;
  rate: string;
  target_calories: string;
  type: string;
  updated_at: string;
  updated_by: string;
}

interface DeviceInfo {
  api_version: null | string;
  app_version: string;
  build_version_number: string;
  created_at: string;
  device_name: string;
  device_token: null | string;
  device_type: string;
  ip: string;
  last_active: string;
  lat: null | number;
  long: null | number;
  model_name: string;
  os_version: string;
  patient_id: string;
  skip_optional: string;
  update_device_info_id: string;
  updated_at: string;
  uuid: string;
  version_number: null | string;
}

interface Devices {
  key: string;
  last_sync_date: string;
  title: string;
}

interface DoctorSays {
  created_at: string;
  deep_link: string;
  description: string;
  doctor_says_master_id: string;
  is_active: string;
  is_deleted: string;
  title: string;
  updated_at: string;
  updated_by: string;
}

interface HcServiceLongestPlan {
  admin_users_id: null | string;
  android_package_id: string;
  app_features_session_count: number;
  card_image: string;
  card_image_detail: string;
  colour_scheme: string;
  created_at: string;
  description: string;
  device_names: string;
  device_type: string;
  diagnostic_test_session_count: number;
  diagnostic_test_used_count: number;
  diagnostic_tests: string;
  discount_amount: null | string;
  discount_percentage: string;
  discount_type: null | string;
  discounts_master_id: null | string;
  duration_name: string;
  duration_title: string;
  enable_rent_buy: string;
  expiry_date: string;
  gst_percentage: string;
  invoice_no: null | string;
  ios_package_id: string;
  is_active: string;
  is_deleted: string;
  nutritionist_session_count: number;
  offer_price: number;
  offer_tag: string;
  order_id: null | string;
  order_no: number;
  original_transaction_id: null | string;
  patient_address_rel_id: string;
  patient_data: null | string;
  patient_id: string;
  patient_plan_rel_id: string;
  physiotherapist_session_count: number;
  plan_cancel_datetime: null | string;
  plan_master_id: string;
  plan_name: string;
  plan_package_duration_rel_id: string;
  plan_purchase_datetime: string;
  plan_type: string;
  purchase_amount: string;
  purchased_at: string;
  receipt_data: null | string;
  remaining_days: number;
  renewal_reminder_days: number;
  rent_buy_type: null | string;
  sub_title: string;
  subscription_id: null | string;
  total_days: number;
  transaction_id: string;
  transaction_type: string;
  updated_at: string;
  updated_by: string;
  what_to_expect: string;
}

interface MedicialConditionName {
  medical_condition_name: string;
}

interface PatientLinkDoctorDetails {
  about: string;
  access_code: string;
  added_by: string | null;
  business_id: string;
  city: string | null;
  clinic_address: string;
  clinic_id: string;
  clinic_name: string;
  contact_no: string;
  country: string;
  country_code: string;
  created_at: string;
  deep_link: string;
  division: string | null;
  dob: string | null;
  doctor_id: string;
  doctor_uniq_id: string;
  email: string;
  experience: string | null;
  gender: string | null;
  is_active: string;
  is_deleted: string;
  language_spoken: string | null;
  languages_id: string | null;
  medical_id_proof: string | null;
  name: string;
  patient_doctor_rel_id: string;
  patient_id: string;
  plan: string | null;
  profile_image: string;
  qualification: string;
  region: string;
  source: string | null;
  specialization: string;
  state: string | null;
  updated_at: string;
  updated_by: string;
}

interface FeaturesRes {
  feature: string;
  feature_keys: string;
  patient_plan_rel_id: string;
  plan_features_id: string;
  plan_features_rel_id: string;
  plan_master_id: string;
  sub_features_ids: string;
  sub_features_keys: string;
  sub_features_names: string;
}

interface PlanInfo {
  admin_users_id: null | string;
  android_per_month_price: number;
  android_price: number;
  card_image: string;
  card_image_detail: string;
  colour_scheme: string;
  created_at: string;
  description: string;
  device_type: string;
  discount_amount: null | string;
  discount_type: null | string;
  discounts_master_id: null | string;
  enable_rent_buy: string;
  expiry_date: string;
  features_res: FeaturesRes[];
  gst_percentage: string;
  image_url: string;
  invoice_no: null | string;
  ios_per_month_price: number;
  ios_price: number;
  ios_product_id: string;
  is_active: string;
  is_deleted: string;
  offer_per_month_price: number;
  offer_price: number;
  order_id: null | string;
  original_transaction_id: null | string;
  patient_id: string;
  patient_plan_rel_id: string;
  plan_cancel_datetime: null | string;
  plan_end_date: string;
  plan_master_id: string;
  plan_name: string;
  plan_purchase_datetime: string;
  plan_start_date: string;
  plan_type: string;
  purchased_at: string;
  razorpay_plan_id: null | string;
  receipt_data: null | string;
  renewal_reminder_days: number;
  sub_title: string;
  subscription_id: null | string;
  transaction_id: string;
  transaction_type: string;
  updated_at: string;
  updated_by: string;
  what_to_expect: string;
}

interface Setting {
  attribute_name: string;
  attribute_value: 'Y' | 'N';
  created_at: string;
  settings_master_id: string;
}

// Define the user type
export type UserType = {
  account_role: string;
  active_deactive_id: string;
  address: string;
  admin_users_id: string | null;
  bca_sync: {
    biometric_setting?: any;
  };
  biometric_setting: null;
  bmr_details?: BMRDetails;
  city: string;
  contact_no: string;
  country: string;
  country_code: string;
  created_at: string;
  current_status: string;
  device_info: DeviceInfo[];
  devices: Devices[];
  dob: string;
  doctor_says: DoctorSays;
  email: string;
  email_verified: string;
  ethnicity: null;
  gender: string;
  greeting_text: string;
  hc_list: any[];
  hc_service_longest_plan: HcServiceLongestPlan;
  height: string;
  height_unit: string;
  is_accept_terms_accept: string;
  is_active: string;
  is_deleted: string;
  language_name: string;
  language_version: null;
  languages_id: string;
  last_active_date: null;
  last_login_date: string;
  lock_till: null;
  login_user: string;
  medical_condition_name: MedicialConditionName[];
  name: string;
  non_relevant: null;
  password: string;
  patient_address_rel_id: string;
  patient_age: number;
  patient_guid: null;
  patient_id: string;
  patient_link_doctor_details: PatientLinkDoctorDetails[];
  patient_plans: PlanInfo[];
  pincode: null;
  profile_completion: string;
  profile_completion_status: {
    drug_prescription: 'Y' | 'N';
    goal_reading: 'Y' | 'N';
    location: 'Y' | 'N';
  };
  profile_pic: string;
  relation: null;
  relevance_admin_users_id: null;
  relevant: null;
  restore_id: null;
  settings: Setting[];
  severity_id: null;
  severity_name: null;
  spirometer_sync: object;
  spirometer_target_vol: number;
  state: string;
  sub_relation: null;
  sync_at: string;
  token: string;
  unit_data: any[];
  unread_notifications: number;
  updated_at: string;
  updated_by: string;
  user_from: string;
  weight: string;
  weight_unit: string;
  whatsapp_optin: string;
};

// This type will represent the sub-state for getting a single user by ID
export type IUserState = {
  data: UserType | null;
  isLoading: boolean;
  errors: string;
};

// The users global state
export type UsersStateType = {
  user: IUserState;
  // Later, we can add other sub-states like:
  // list,
  // create,
  // update,
  // remove
};

// (1)
// export const Auth = 'auth'; // slice name here
// export type USERS = typeof USERS; // Typescript line
