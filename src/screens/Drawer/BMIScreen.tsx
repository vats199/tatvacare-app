import {Image, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {StackScreenProps} from '@react-navigation/stack';
import {useSafeAreaInsets, SafeAreaView} from 'react-native-safe-area-context';

import {
  AppStackParamList,
  DrawerParamList,
  SetupProfileStackParamList,
} from '../../interface/Navigation.interface';
import images from '../../constants/images';
import Button from '../../components/atoms/Button';
import {Matrics} from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import {GoalsScreen as styles} from './styles';
import DrawerHeader from '../../components/molecules/DrawerHeader';
import {Icons} from '../../constants/icons';
import {FlatList} from 'react-native';
import {colors} from '../../constants/colors';
type GoalScreenProps = CompositeScreenProps<
  StackScreenProps<DrawerParamList, 'GoalScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;
type goalsList = {
  id: number;
  title: string;
  value?: number | undefined;
  desc: string;
  icon: React.ReactNode;
};
const BMIScreen: React.FC<GoalScreenProps> = ({navigation}) => {
  // const {setUserData} = useApp();
  const [arr, setArr] = React.useState<goalsList[]>([
    {
      id: 1,
      title: 'Medication',
      desc: 'doses per day',
      value: 0,
      icon: <Icons.Medication />,
    },
    {
      id: 2,
      title: 'Breathing',
      desc: 'minutes per day',
      value: 120,
      icon: <Icons.Breathing />,
    },
    {
      id: 3,
      title: 'Steps',
      desc: 'steps per day',
      value: 2540,
      icon: <Icons.Other />,
    },
    {
      id: 4,
      title: 'Exercise',
      desc: 'minutes per day',
      value: 20,
      icon: <Icons.Other />,
    },
    {
      id: 5,
      title: 'Water',
      desc: 'glasses per day',
      value: 20,
      icon: <Icons.Other />,
    },
    {
      id: 6,
      title: 'Diet',
      desc: 'cal per day',
      value: 2500,
      icon: <Icons.Other />,
    },
    {
      id: 6,
      title: 'Sleep',
      desc: '5 hour per day',
      value: 5,
      icon: <Icons.Other />,
    },
  ]);

  const insets = useSafeAreaInsets();

  const renderItem = ({item, index}: {item: goalsList; index: number}) => {
    return (
      <View
        style={{
          marginHorizontal: Matrics.s(15),
          borderWidth: 1,
          borderColor: '#D9D9D9',
          paddingHorizontal: Matrics.s(6),
          paddingVertical: Matrics.s(8),
          backgroundColor: colors.white,
          flexDirection: 'row',
          // alignItems: 'center',
          borderRadius: Matrics.s(2),
        }}>
        <View style={{flexDirection: 'row', flex: 1}}>
          {item.icon}
          <View style={{marginLeft: Matrics.s(20)}}>
            <Text style={styles.itemTitleStyle}>{item.title}</Text>
            <Text
              style={styles.itemDescStyle}>{`${item.value}${item.desc}`}</Text>
          </View>
        </View>

        <TouchableOpacity
          style={{
            alignSelf:
              item?.value != undefined && item?.value > 0
                ? 'flex-start'
                : 'flex-end',
          }}>
          <Text style={styles.itemButtonStyle}>
            {item?.value != undefined && item?.value > 0
              ? `Edit goal >`
              : `Update`}
          </Text>
          {/* <Text style={styles.itemButtonStyle}>{`Update`}</Text> */}
        </TouchableOpacity>
      </View>
    );
  };

  const itemSeparatorComponent = () => {
    return <View style={{height: Matrics.vs(15)}}></View>;
  };

  return (
    <SafeAreaView style={styles.container}>
      <MyStatusbar />
      <View style={{paddingHorizontal: Matrics.s(15)}}>
        <DrawerHeader />
        <View style={{height: Matrics.vs(28)}}></View>

        <View style={{flexDirection: 'row', alignItems: 'center'}}>
          <TouchableOpacity onPress={() => navigation.goBack()}>
            <Icons.BackIcon />
          </TouchableOpacity>
          <Text style={styles.headingText}>{`Define Your goals`}</Text>
          <Icons.InfoPurple />
        </View>
        <View style={{marginTop: Matrics.vs(24)}}>
          <Text
            style={
              styles.descText
            }>{`Define your Activity Goals that best suit your health.`}</Text>
        </View>
      </View>
      <FlatList
        style={{marginTop: Matrics.vs(20)}}
        data={arr}
        renderItem={renderItem}
        ItemSeparatorComponent={itemSeparatorComponent}
      />

      <Button
        title="Submit"
        buttonStyle={{marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0}}
      />
    </SafeAreaView>
  );
};

export default BMIScreen;
