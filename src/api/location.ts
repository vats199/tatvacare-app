import Ajax from './base';

const Location = {
  getLocationFromLatLong: (payload: object) => {
    const {lat, long} = payload as {lat: number; long: number};
    const route = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${long}&key=AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo`;
    return Ajax.request(route, {
      method: Ajax.GET,
      baseURL: '',
      isEncrypted: false,
      priv: false,
    });
  },
  getLocationFromPincode: (payload: object) => {
    const {pincode} = payload as {pincode: string};
    const route = `https://maps.googleapis.com/maps/api/geocode/json?address=${pincode}&key=AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo`;
    return Ajax.request(route, {
      method: Ajax.GET,
      baseURL: '',
      isEncrypted: false,
      priv: false,
    });
  },
};

export default Location;
