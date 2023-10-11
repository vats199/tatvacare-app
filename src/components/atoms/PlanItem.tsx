import {Image, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';

type PlanItemProps = {
  plan: any;
  onPressKnowMore: () => void;
};

const PlanItem: React.FC<PlanItemProps> = ({
  plan,
  onPressKnowMore = () => {},
}) => {
  return (
    <TouchableOpacity
      onPress={onPressKnowMore}
      activeOpacity={0.6}
      style={styles.planItemContainer}>
      <Image
        source={{uri: plan.image_url}}
        style={styles.image}
        resizeMode={'stretch'}
      />
    </TouchableOpacity>
  );
};

export default PlanItem;

const styles = StyleSheet.create({
  planItemContainer: {
    height: 80,
    width: 240,
    borderWidth: 1,
    borderColor: colors.lightGrey,
    borderRadius: 12,
    padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  image: {
    height: '100%',
    width: '100%',
    backgroundColor: colors.lightGrey,
  },
  textContainer: {
    flex: 1,
    height: '100%',
    justifyContent: 'space-between',
  },
  name: {
    color: colors.labelDarkGray,
    fontSize: 12,
    fontWeight: '600',
  },
  subtitle: {
    color: colors.labelDarkGray,
    fontSize: 8,
    fontWeight: '300',
  },
  knowmore: {
    textDecorationLine: 'underline',
    textDecorationColor: colors.themePurple,
    color: colors.themePurple,
    fontSize: 10,
    fontWeight: '700',
  },
});
