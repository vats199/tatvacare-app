import moment from 'moment';
import React, { useEffect } from 'react';
import { Dimensions, Platform } from 'react-native';
import { Constants } from '../constants';
import DeviceInfo from 'react-native-device-info';

type AppContextData = {
  location: any;
  setUserLocation: (data: any) => void;
  userData: any;
  setUserData: React.Dispatch<React.SetStateAction<any>>;
  setCurrentScreenName: React.Dispatch<React.SetStateAction<any>>,
};

type EventDefaultParams = {
  "log_date": string,
  "device_type": string,
  "currentAppVersion": string,
  "OS_Version": string,
  "screenResolution": string,
  "ScreenName"?: string,
  "patient_id": string,
  "patientGender": string,
  "patientIndication": string,
  "doctorId"?: string,
  "doctorSpecialization"?: string,
  "healthCoachId": string,
  "HealthCoachSpecialization": string,
  "city": string,
  "emailVerified": string,
  "current_plan_name": string,
  "current_plan_type": string,
  "current_plan_id": string
}
const AppContext = React.createContext<AppContextData>({} as AppContextData);

const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [location, setLocation] = React.useState<any>({});
  const [userData, setUserData] = React.useState<any>({});
  const [eventDefaultParams, setEventDefaultParams] = React.useState<EventDefaultParams | null>(null);
  const [currentScreenName, setCurrentScreenName] = React.useState<string>("");

  const setUserLocation = (data: any) => {
    setLocation(data);
  };

  useEffect(() => {
    // Get Nested Route Name
    let payload: EventDefaultParams = {
      log_date: moment().format('YYYY-MM-DD HH:mm:ss'),
      device_type: Platform.OS == 'android' ? 'Android' : 'iPhone',
      currentAppVersion: Platform.OS == 'android' ? DeviceInfo.getVersion() : DeviceInfo.getVersion(),
      OS_Version: DeviceInfo.getSystemVersion(),
      screenResolution: Dimensions.get('screen').width + 'X' + Dimensions.get('screen').height,
      ScreenName: currentScreenName ?? "",
      patient_id: userData?.patient_id ?? "",
      patientGender: userData?.gender ?? "",
      patientIndication: userData?.medical_condition_name?.[0]?.medical_condition_name ?? "",
      healthCoachId: userData?.hc_list?.map((a: any) => a.health_coach_id)?.join(', ') ?? "", //TODO: add id
      HealthCoachSpecialization: userData?.hc_list?.map((a: any) => a.role)?.join(', ') ?? "", //TODO: add id
      city: userData?.city,
      emailVerified: userData?.email_verified,
      current_plan_name: userData?.patient_plans?.map((a: any) => a.plan_name)?.join(', ') ?? "",
      current_plan_type: userData?.patient_plans?.map((a: any) => a.plan_type)?.join(', ') ?? "",
      current_plan_id: userData?.patient_plans?.map((a: any) => a.plan_master_id)?.join(', ') ?? ""
    }

    if (userData?.patient_link_doctor_details?.[0]?.doctorId) {
      Object.assign(payload, {
        doctorId: userData?.patient_link_doctor_details?.[0]?.doctorId ?? "",
        doctorSpecialization: userData?.patient_link_doctor_details?.[0]?.specialization ?? ""
      })
    }
    global.trackEventDefaultParams = payload ?? null
    setEventDefaultParams(payload)
  }, [userData])
  return (
    //This component will be used to encapsulate the whole App,
    //so all components will have access to the Context
    <AppContext.Provider
      value={{
        location,
        setUserLocation,
        setUserData,
        setCurrentScreenName,
      }}>
      {children}
    </AppContext.Provider>
  );
};

function useApp(): AppContextData {
  const context = React.useContext(AppContext);
  if (!context) {
    throw new Error('Error!');
  }
  return context;
}

export { AppContext, AppProvider, useApp };
