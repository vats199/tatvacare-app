import React from 'react';

type AppContextData = {
  location: any;
  setUserLocation: React.SetStateAction<any>;
  userData: any;
  setUserData: React.SetStateAction<any>;
};

const AppContext = React.createContext<AppContextData>({} as AppContextData);

const AppProvider: React.FC<{children: React.ReactNode}> = ({children}) => {
  const [location, setLocation] = React.useState<any>({});
  const [userData, setUserData] = React.useState<any>({});

  const setUserLocation = (data: any) => {
    setLocation(data);
  };

  return (
    //This component will be used to encapsulate the whole App,
    //so all components will have access to the Context
    <AppContext.Provider
      value={{
        location,
        setUserLocation,
        userData,
        setUserData,
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

export {AppContext, AppProvider, useApp};
