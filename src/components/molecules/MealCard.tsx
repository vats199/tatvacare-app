import {DrawerItemList} from '@react-navigation/drawer';
import React, {useEffect, useState} from 'react';
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import DietOption from './DietOption';
import {Fonts, Matrics} from '../../constants';
import fonts from '../../constants/fonts';
import moment from 'moment';
import {useFocusEffect} from '@react-navigation/native';
import {globalStyles} from '../../constants/globalStyles';

interface MealCardProps {
  onPressPlus: (optionFoodItems: mealTYpe) => void;
  cardData: mealTYpe;
}
type mealTYpe = {
  meal_types_id: string;
  value: string;
  meal_type: string;
  label: string;
  keys: string;
  default_time: string;
  order_no: number;
};
const MealCard: React.FC<MealCardProps> = ({cardData, onPressPlus}) => {
  const [foodItmeData, setFoodItemData] = React.useState<any | null>(cardData);

  const handlePulsIconPress = (item: mealTYpe) => {
    onPressPlus(item);
  };
  const mealMessage = (name: string) => {
    switch (name) {
      case 'Breakfast':
        return 'Breakfast is a passport to morning.';
      case 'Dinner':
        return 'Dinner is a passport to better sleep.';
      case 'Lunch':
        return 'Lunch is a passport to noon.';
      default:
        return 'Snacks is a passport to evening.';
    }
  };
  const mealIcons = (name: string) => {
    switch (name) {
      case 'Breakfast':
        return <Icons.Breakfast />;
      case 'Dinner':
        return <Icons.Dinner />;
      case 'Lunch':
        return <Icons.Lunch />;
      default:
        return <Icons.Snacks />;
    }
  };

  return (
    <View style={[styles.container, globalStyles.shadowContainer]}>
      <View style={styles.innerContainer}>
        <View style={styles.topRow}>
          <View style={styles.leftContent}>
            <View style={styles.circle}>{mealIcons(cardData?.meal_type)}</View>
            <View style={styles.textContainer}>
              <Text style={styles.title}>{cardData.label}</Text>
              <Text style={styles.textBelowTitle}>
                {moment(cardData?.default_time, 'HH:mm:ss').format('h:mm A') +
                  ' - ' +
                  moment(cardData?.default_time, 'HH:mm:ss')
                    .add(1, 'hour')
                    .format('h:mm A') +
                  ' | ' +
                  0 +
                  ' of ' +
                  0 +
                  'cal'}{' '}
              </Text>
            </View>
          </View>
          <TouchableOpacity
            onPress={() => {
              handlePulsIconPress(cardData);
            }}
            style={styles.iconContainer}>
            <Icons.AddCircle height={25} width={25} />
          </TouchableOpacity>
          {/* // ) : null} */}
        </View>
        <View style={styles.line} />
        <View style={styles.belowRow}>
          {cardData?.options?.length > 0 ? (
            <>
              <ScrollView
                showsHorizontalScrollIndicator={false}
                horizontal
                bounces={false}
                style={{flexDirection: 'row'}}></ScrollView>
            </>
          ) : (
            <View style={styles.messageContainer}>
              <Text style={styles.message}>
                {mealMessage(cardData.meal_type)}
              </Text>
            </View>
          )}
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    borderWidth: 0.1,
    borderColor: 'white',
    borderRadius: 12,
    marginVertical: 8,
    overflow: 'hidden',
    marginHorizontal: Matrics.s(15),
  },
  innerContainer: {
    backgroundColor: 'white',
  },
  topRow: {
    paddingHorizontal: Matrics.s(14),
    paddingVertical: 8,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  leftContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  circle: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#F3F3F3',
    marginRight: 10,
    justifyContent: 'center',
    alignItems: 'center',
    alignSelf: 'center',
    alignContent: 'center',
  },
  textContainer: {
    flex: 1,
  },
  title: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.labelDarkGray,
  },
  textBelowTitle: {
    fontSize: Matrics.mvs(13),
    color: '#444444',
  },
  line: {
    borderBottomWidth: Matrics.mvs(0.5),
    borderColor: '#808080',
    opacity: 0.5,
  },
  belowRow: {
    paddingVertical: Matrics.vs(15),
  },
  messageContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  message: {
    fontSize: Matrics.mvs(12),
    color: '#919191',
    fontWeight: '400',
    fontFamily: Fonts.REGULAR,
  },
  optionContainer: {
    height: Matrics.vs(28),
    width: Matrics.s(60),
    borderRadius: Matrics.mvs(8),
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
  },
  optionText: {
    fontFamily: Fonts.REGULAR,
    fontWeight: '500',
    color: colors.labelDarkGray,
    fontSize: Matrics.mvs(12),
  },
  iconContainer: {
    height: 30,
    width: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default MealCard;
