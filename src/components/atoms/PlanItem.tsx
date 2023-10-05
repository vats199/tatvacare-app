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
      <View style={styles.textContainer}>
        <Text style={styles.name}>{plan.plan_name}</Text>
        <Text style={styles.subtitle}>{plan.sub_title}</Text>
        <View>
          <Text style={styles.knowmore}>Know More</Text>
        </View>
      </View>
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
    height: 60,
    width: 60,
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
