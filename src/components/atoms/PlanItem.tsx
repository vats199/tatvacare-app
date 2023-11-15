import {
  Dimensions,
  Image,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import { Matrics } from '../../constants';

type PlanItemProps = {
  plan: any;
  index: number;
  onPressKnowMore: () => void;
};

const PlanItem: React.FC<PlanItemProps> = ({
  plan,
  index,
  onPressKnowMore = () => { },
}) => {
  return (
    <TouchableOpacity
      onPress={onPressKnowMore}
      activeOpacity={0.6}
      style={[styles.planItemContainer, { marginLeft: index == 0 ? 16 : 0, marginRight: index == 0 ? 0 : 16 }]}>
      <Image
        source={{ uri: plan.image_url }}
        style={styles.image}
        resizeMode={'stretch'}
      />
    </TouchableOpacity>
  );
};

export default PlanItem;

const styles = StyleSheet.create({
  planItemContainer: {
    aspectRatio: 2.45,
    width: Matrics.screenWidth - 64,
    borderWidth: 1,
    borderColor: colors.lightGrey,
    borderRadius: 12,
    overflow: 'hidden',
    // padding: 10,
  },
  image: {
    height: '100%',
    width: Matrics.screenWidth - 64,
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
