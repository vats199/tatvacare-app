import { bindQueryParams } from '../helpers/Tools';
import Ajax from './base';

const Home = {
  getPatientCarePlan: (query: object) => {
    const route = bindQueryParams('/patient/get_patient_details', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
    });
  },
  getLearnMoreData: (query: object) => {
    const route = bindQueryParams('/content/stay_informed', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
    });
  },
  getHomePagePlans: (query: object, payload: object) => {
    const route = bindQueryParams('/patient_plans/home_page_plans', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload,
    });
  },
  getMyHealthInsights: () => {
    const route = '/goal_readings/my_health_insights';
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
    });
  },
  getHCDevicePlan: () => {
    const route = '/patient_plans/hc_device_plan';
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
    });
  },
  getGoalsAndReadings: (headers: object) => {
    const route = '/goal_readings/daily_summary';
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      headers,
    });
  },
  getMyHealthDiaries: (query: object) => {
    const route = bindQueryParams('/goal_readings/my_health_dairy', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
    });
  },
  addBookmark: (query: object, payload: object) => {
    const route = bindQueryParams('/content/update_bookmarks', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload,
    });
  },
  updatePatientLocation: (query: object, payload: object) => {
    const route = bindQueryParams('/patient/update_patient_location', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload,
    });
  },
  getIncidentDetails: () => {
    const route = '/survey/get_incident_survey';
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
    });
  },
};

export default Home;
