import React, { useEffect, useRef, useState } from 'react';
import { date } from 'yup';

type DietContextData = {
  totalPreCalories: React.MutableRefObject<number>;
  totalPreConsumedCalories: React.MutableRefObject<number>;
  updatePreCalories: (calories: number) => void;
  updatePreConsumedCalories: (calories: number) => void;
  totalCalories: number;
  totalConsumedCalories: number;
  updateCalories: (calories: number) => void;
  updateConsumedCalories: (calories: number) => void;
  resetData: () => void;
  addConsumedCalories: (calories: number) => void;
  removeConsumedCalories: (calories: number) => void;
  selectedOptionsId: React.MutableRefObject<OptionType[]>;
  updateOptionsId: (option: OptionType) => void;
  dietPlanDataAssign: (data: any[]) => void;
  dietPlanData: any[];
  resetCalories: () => void;
};

export type OptionType = {
  mealId: string;
  optionId: string;
};

const DietContext = React.createContext<DietContextData>({} as DietContextData);

const DietProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  //   const [totalPreCalories, setTotalPreCalories] = React.useState<number>(0);
  //   const [totalPreConsumedCalories, setTotalPreConsumedCalories] =
  //     React.useState<number>(0);

  const totalPreCalories = useRef<number>(0);
  const totalPreConsumedCalories = useRef<number>(0);

  const [totalCalories, setTotalCalories] = useState<number>(0);
  const [totalConsumedCalories, setTotalConsumedCalories] = useState<number>(0);

  const selectedOptionsId = useRef<OptionType[]>([]);
  const [dietPlanData, setDietPlanData] = useState<any[]>([]);

  const updatePreCalories = (calories: number) => {
    totalPreCalories.current = calories;
  };

  const updatePreConsumedCalories = (calories: number) => {
    totalPreConsumedCalories.current = calories;
  };

  const resetData = () => {
    // setTotalCalories(0);
    // setTotalConsumedCalories(0);
    selectedOptionsId.current = [];
  };

  const resetCalories = () => {
    setTotalCalories(0);
    setTotalConsumedCalories(0);
  };

  const updateCalories = (calories: number) => {
    const tempValue = totalPreCalories.current + calories;
    totalPreCalories.current = tempValue;
  };

  const updateConsumedCalories = (calories: number) => {
    const tempValue = totalPreConsumedCalories.current + calories;
    totalPreConsumedCalories.current = tempValue;
  };

  const addConsumedCalories = (calories: number) => {
    totalPreConsumedCalories.current =
      totalPreConsumedCalories.current + calories;
  };

  const removeConsumedCalories = (calories: number) => {
    totalPreConsumedCalories.current =
      totalPreConsumedCalories.current - calories;
  };

  const updateOptionsId = (option: OptionType) => {
    const items = selectedOptionsId.current.findIndex(
      item => item.mealId == option.mealId,
    );

    if (items > -1) {
      const tempArray = [...selectedOptionsId.current];
      tempArray[items] = {
        mealId: option.mealId,
        optionId: option.optionId,
      };
      selectedOptionsId.current = [...tempArray];
    } else {
      const tempArray = [...selectedOptionsId.current, option];
      selectedOptionsId.current = tempArray;
    }
    let total = 0;
    let totalConsumed = 0;
    const tempArray = [...selectedOptionsId.current];
    if (tempArray.length !== 0) {
      dietPlanData?.meals?.map((meal, index) => {
        meal.options.map(item => {
          item?.food_items?.length !== 0 &&
            tempArray.map(q => {
              if (
                q.mealId == item.diet_meal_type_rel_id &&
                q.optionId == item.diet_meal_options_id
              ) {
                total = total + Number(item?.total_calories) ?? 0;
                totalConsumed =
                  totalConsumed + Number(item?.consumed_calories) ?? 0;
              }
            });
        });
      });
    }
    setTotalCalories(Number(total));
    setTotalConsumedCalories(Number(totalConsumed));
  };

  const dietPlanDataAssign = (data: any[]) => {
    setDietPlanData(data);
  };

  useEffect(() => {
    let total = 0;
    let totalConsumed = 0;
    const tempArray = [...selectedOptionsId.current];
    if (tempArray.length !== 0) {
      dietPlanData?.meals?.map((meal, index) => {
        meal.options.map(item => {
          item?.food_items?.length !== 0 &&
            tempArray.map(q => {
              if (
                q.mealId == item.diet_meal_type_rel_id &&
                q.optionId == item.diet_meal_options_id
              ) {
                total = total + Number(item?.total_calories) ?? 0;
                totalConsumed =
                  totalConsumed + Number(item?.consumed_calories) ?? 0;
              }
            });
        });
      });
    }
    setTotalCalories(Number(total));
    setTotalConsumedCalories(Number(totalConsumed));
  }, [dietPlanData]);

  return (
    //This component will be used to encapsulate the whole App,
    //so all components will have access to the Context
    <DietContext.Provider
      value={{
        totalPreCalories,
        totalPreConsumedCalories,
        updateCalories,
        updateConsumedCalories,
        totalCalories,
        totalConsumedCalories,
        updatePreCalories,
        updatePreConsumedCalories,
        resetData,
        addConsumedCalories,
        removeConsumedCalories,

        selectedOptionsId,
        updateOptionsId,
        dietPlanDataAssign,
        dietPlanData,
        resetCalories,
      }}>
      {children}
    </DietContext.Provider>
  );
};

function useDiet(): DietContextData {
  const context = React.useContext(DietContext);
  if (!context) {
    throw new Error('Error!');
  }
  return context;
}

export { DietContext, DietProvider, useDiet };
