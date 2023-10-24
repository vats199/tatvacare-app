// // --------------- LIBRARIES ---------------
import {configureStore} from '@reduxjs/toolkit';
import {persistStore, persistReducer} from 'redux-persist';
import AsyncStorage from '@react-native-async-storage/async-storage';
import createSagaMiddleware from '@redux-saga/core';
import logger from 'redux-logger';

// // --------------- ASSETS ---------------
import appReducer from './slices';
import rootSaga from './sagas';

// // Roor reducer with persist config
const reducers = persistReducer(
  {
    key: 'root',
    storage: AsyncStorage,
    // whitelist: ['Auth'],
  },
  appReducer,
);

// Middlewares setup
const sagaMiddleware = createSagaMiddleware();
const middlewares = [];

if (__DEV__) {
  middlewares.push(sagaMiddleware, logger); // With logger
} else {
  middlewares.push(sagaMiddleware); // without logger
}

export const Store = configureStore({
  reducer: reducers,
  middleware: middlewares,
  devTools: process.env.NODE_ENV !== 'production',
});

// Infer the `RootState` and `AppDispatch` types from the store itself
export type RootState = ReturnType<typeof Store.getState>;
// Inferred type: {posts: PostsState, comments: CommentsState, users: UsersState}
export type AppDispatch = typeof Store.dispatch;

// // PersistStore contains all the data from store ----->>>>>
export const Persistor = persistStore(Store);
sagaMiddleware.run(rootSaga); // Run Saga
