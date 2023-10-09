export type AppStackParamList = {
  BottomTabs: undefined;
  DietScreen:
    | {
        dietData: {
          title: string;
        };
      }
    | undefined;

  AddDiet: undefined;
  DietDetail: undefined;
};

export type BottomTabParamList = {
  HomeScreen: undefined;
  ProgramsScreen: undefined;
  LearnScreen: undefined;
  ExerciseScreen: undefined;
};
