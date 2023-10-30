import React, { SetStateAction } from 'react';

type AppContextData = {
  location: any;
  setUserLocation: (data: any) => void;
  userData: any;
  setUserData: (data: any) => void;
  coupan: string;
  setCoupan: (data: string) => void;
};

const AppContext = React.createContext<AppContextData>({} as AppContextData);

const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [location, setLocation] = React.useState<any>({});
  const [userData, setData] = React.useState<any>({});
  const [coupan, setSelectedCoupan] = React.useState<string>("");

  const setUserLocation = (data: any) => {
    setLocation(data);
  };

  const setUserData = (data: any) => {
    console.log(data, 'userData');
    setData(data);
  };
  const setCoupan = (data: string) => {
    setSelectedCoupan(data);
  }

  return (
    //This component will be used to encapsulate the whole App,
    //so all components will have access to the Context
    <AppContext.Provider
      value={{
        location,
        setUserLocation,
        setUserData,
        userData,
        coupan,
        setCoupan
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
