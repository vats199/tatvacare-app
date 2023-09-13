import { bindQueryParams } from "../helpers/Tools";
import Ajax from './base';

const Home = {
    getPatientCarePlan: (query: object) => {
        const route = bindQueryParams('/patient/get_patient_details', query)
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true
        })
    },
    getLearnMoreData: (query: object) => {
        const route = bindQueryParams('/content/stay_informed', query)
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true
        })
    },
    getHomePagePlans: (query: object, payload: object) => {
        const route = bindQueryParams('/patient_plans/home_page_plans', query)
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true,
            payload
        })
    },
    getMyHealthInsights: (query: object) => {
        const route = bindQueryParams('/goal_readings/my_health_insights', query)
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true
        })
    },
    getMyHealthDiaries: (query: object) => {
        const route = bindQueryParams('/goal_readings/my_health_dairy', query)
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true
        })
    },
    addBookmark: (query: object, payload: object) => {
        const route = bindQueryParams('/content/update_bookmarks', query)
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true,
            payload
        })
    },
}

export default Home