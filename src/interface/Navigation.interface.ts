export type AppStackParamList = {
  // BottomTabs: undefined;
  DrawerScreen: DrawerParamList;
  TabScreen: TabParamList
};

export type DrawerParamList = {
  HomeScreen: undefined;
  AboutUsScreen: undefined;
  ExerciseDetailScreen:{Data:any}
  ExplorScreen:undefined;
};
export type TabParamList = {
  RoutineScreen:undefined;
  ExplorScreen:undefined;
 };

export type BottomTabParamList = {
  HomeScreen: undefined;
  ProgramsScreen: undefined;
  LearnScreen: undefined;
  ExerciseScreen: undefined;
};
