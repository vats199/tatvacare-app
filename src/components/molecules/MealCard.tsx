import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Fonts, Matrics } from '../../constants';
import moment from 'moment';
import { globalStyles } from '../../constants/globalStyles';

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
const MealCard: React.FC<MealCardProps> = ({ cardData, onPressPlus }) => {
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
      <View style={styles.topRow}>
        <View style={styles.leftContent}>
          <View style={styles.circle}>{mealIcons(cardData?.meal_type)}</View>
          <View style={styles.textContainer}>
            <Text style={styles.title}>{cardData.label}</Text>
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
              <Text style={styles.textBelowTitle}>
                {moment(cardData?.default_time, 'HH:mm:ss').format('h:mm A') +
                  ' - ' +
                  moment(cardData?.default_time, 'HH:mm:ss').add(1, "hour").format('h:mm A') +
                  ' | '}
              </Text>
              <Text style={[styles.textBelowTitle, { textTransform: 'lowercase', color: colors.labelDarkGray }]}>
                {+ 0 +
                  ' of ' +
                  0 +
                  'cal'}
              </Text>
            </View>
          </View>
        </View>
        <TouchableOpacity
          onPress={() => {
            handlePulsIconPress(cardData);
          }}
          style={styles.iconContainer}>
          <Icons.AddCircle height={20} width={20} />
        </TouchableOpacity>
      </View>
      <View style={styles.line} />
      <View>
        <View style={styles.messageContainer}>
          <Text style={styles.message}>{mealMessage(cardData.meal_type)}</Text>
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    borderRadius: Matrics.mvs(12),
    marginVertical: Matrics.vs(8),
    backgroundColor: colors.white,
    paddingVertical: Matrics.vs(12),
  },
  innerContainer: {
    backgroundColor: 'white',
  },
  topRow: {
    paddingHorizontal: Matrics.s(15),
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
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.BOLD,
    color: colors.labelDarkGray,
  },
  textBelowTitle: {
    fontSize: Matrics.mvs(11),
    fontFamily: Fonts.REGULAR,
    color: colors.subTitleLightGray,
    lineHeight: 16,
  },
  line: {
    height: StyleSheet.hairlineWidth,
    backgroundColor: colors.seprator,
    marginTop: Matrics.vs(11),
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
    color: colors.darkGray,
    fontFamily: Fonts.REGULAR,
    paddingTop: Matrics.vs(16),
    paddingBottom: Matrics.vs(4),
  },
  optionContainer: {
    height: Matrics.vs(28),
    width: Matrics.s(60),
    borderRadius: Matrics.mvs(8),
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    marginVertical: Matrics.vs(10),
    marginTop: Matrics.vs(15),
  },
  optionText: {
    fontFamily: Fonts.REGULAR,
    color: colors.labelDarkGray,
    fontSize: Matrics.mvs(12),
    lineHeight: 16,
  },
  iconContainer: {
    height: 30,
    width: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
  caloriesTxt: {
    fontSize: Matrics.mvs(11),
    fontFamily: Fonts.REGULAR,
    color: colors.labelDarkGray,
  },
});

export default MealCard;
