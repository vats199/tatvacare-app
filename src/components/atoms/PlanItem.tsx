import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';

type PlanItemProps = {
  plan: any;
  onPressKnowMore: () => void;
};

const PlanItem: React.FC<PlanItemProps> = ({
  plan,
  onPressKnowMore = () => { },
}) => {
  return (
    <TouchableOpacity
      onPress={onPressKnowMore}
      activeOpacity={0.6}
      style={styles.planItemContainer}>
      <Image
        source={{ uri: plan.image_url }}
        style={styles.image}
        resizeMode={'cover'}
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
    overflow: 'hidden',
    // padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between'
  },
  image: {
    height: '100%',
    width: '100%',
    backgroundColor: colors.lightGrey,
    borderRadius: 12,
  },
  textContainer: {
    flex: 1,
    height: '100%',
    justifyContent: 'space-between',
  },
  name: {
    color: colors.labelDarkGray,
    fontSize: 12,
    fontFamily: 'SFProDisplay-Bold',
  },
  subtitle: {
    color: colors.labelDarkGray,
    fontSize: 8,
    fontFamily: 'SFProDisplay-Semibold',
  },
  knowmore: {
    textDecorationLine: 'underline',
    textDecorationColor: colors.themePurple,
    color: colors.themePurple,
    fontSize: 10,
    fontFamily: 'SFProDisplay-Bold',
  },
});
