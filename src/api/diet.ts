import {bindQueryParams} from '../helpers/Tools';
import Ajax from './base';

const Diet = {
  getDietPlan: (query: object) => {
    const route = bindQueryParams('/patient_hc/get_patient_diet_plan',{});
    console.log(route);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload: query
    });
  }
  
};

export default Diet;
