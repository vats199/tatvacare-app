import { bindQueryParams } from "../helpers/Tools";
import Ajax from './base';

const Home = {
    getPatientCarePlan: (query: object) => {
        const route = bindQueryParams('/patient/get_patient_details', query)
        return Ajax.request(route, {
            method: Ajax.GET,
            priv: true
        })
    },
    // updatePatientLocation: (payload: object) => {
    //     const route = '/patient/update_patient_location'
    //     return Ajax.request(route, {
    //         payload,
    //         method: Ajax.POST,
    //         priv: true
    //     })
    // },
}

export default Home