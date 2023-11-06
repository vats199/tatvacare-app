import {bindQueryParams} from '../helpers/Tools';
import Ajax from './base';

const Diet = {
  getDietPlan: (payload: object, query: object  ) => {
    const route = bindQueryParams('/patient_hc/get_patient_diet_plan', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload: payload,
      // headers: token,
    });
  },
  deleteFoodItem: (payload: object, query: object  ) => {
    // console.log('delete payload', payload);

    const route = bindQueryParams(
      '/patient_hc/delete_food_item_patient',
      query,
    );
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload: payload,
      // headers: token,
    });
  },
  searchFoodItem: (payload: object, query: object) => {
 
    const route = bindQueryParams(
      '/goal_readings/search_food_with_nutrition',
      query,
    );
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload: payload,
      // headers: token,
    });
  },
  addFoodItem: (payload: object, query: object) => {
    // console.log('add payload', payload);

    const route = bindQueryParams('/patient_hc/add_food_item_patient', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload: payload,
      // headers: token,
    });
  },
  updateFoodItem: (payload: object, query: object) => {
    const route = bindQueryParams('/patient_hc/update_food_item_patient', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload: payload,
      // headers: token,
    });
  },
  updateFoodConsumption: (payload: object, query: object) => {
        // console.log('add payload', payload);

    const route = bindQueryParams('/patient_hc/update_food_consumption', query);
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload: payload,
      // headers: token,
    });
  },
  noDietPalncraet: (payload: object, query: object) => {
    const route = bindQueryParams(
      '/patient_hc/create_diet_plan_patient',
      query,
    );
    return Ajax.request(route, {
      method: Ajax.POST,
      priv: true,
      payload: payload,
      // headers: token,
    });
  },
};

export default Diet;
