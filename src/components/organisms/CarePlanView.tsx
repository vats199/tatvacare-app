import {
  Dimensions,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  FlatList,
} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import ProgressBar from '../atoms/ProgressBar';
import moment from 'moment';
import PlanItem from '../atoms/PlanItem';

type CarePlanViewProps = {
  data?: any;
  allPlans: any[];
  onPressCarePlan: () => void;
};

const CarePlanView: React.FC<CarePlanViewProps> = ({
  data,
  onPressCarePlan,
  allPlans = [],
}) => {
  const isFreePlan: boolean =
    data?.patient_plans && data?.patient_plans[0]?.plan_type === 'Free';

  const getPlanProgress = (plan: any) => {
    if (plan?.plan_end_date && plan?.plan_start_date) {
      const planDuration = moment(plan?.plan_end_date).diff(
        plan?.plan_start_date,
        'days',
      ); //duration of plan in days

      const completedPlanDuration = moment(new Date()).diff(
        plan?.plan_start_date,
        'days',
      ); //completed plan duration in days

      if (completedPlanDuration >= 0 && planDuration > 0) {
        return (completedPlanDuration / planDuration) * 100;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  };

  const onPressKnowMore = (plan: any) => {};

  const renderPlanItem = ({item, index}: {item: any; index: number}) => {
    return (
      <PlanItem plan={item} onPressKnowMore={() => onPressKnowMore(item)} />
    );
  };

  return (
    <>
      {data?.patient_plans?.length <= 0 || isFreePlan ? (
        <View style={styles.compcontainer}>
          <View style={styles.rowBetween}>
            <View>
              <Text style={styles.cp}>Care Plans for all your needs</Text>
              <Text style={styles.subTitle}>
                Bundled with diagnostic tests and more.
              </Text>
            </View>
            <Image
              source={require('../../assets/images/carePlan.png')}
              style={styles.cpimage}
              resizeMode={'contain'}
            />
          </View>
          <FlatList
            data={allPlans}
            keyExtractor={(_item, index) => index.toString()}
            horizontal
            showsHorizontalScrollIndicator={false}
            renderItem={renderPlanItem}
            ItemSeparatorComponent={() => <View style={styles.itemSep} />}
          />
        </View>
      ) : (
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          bounces={false}>
          {data?.patient_plans?.map((plan: any, planIdx: number) => {
            return (
              <TouchableOpacity key={planIdx} onPress={onPressCarePlan}>
                <View style={styles.container}>
                  <View style={styles.details}>
                    <Text style={styles.title}>{plan?.plan_name || '-'}</Text>
                    <Text style={styles.subTitle}>
                      {plan?.sub_title || '-'}
                    </Text>
                    <ProgressBar progress={getPlanProgress(plan) || 0} />
                    <Text style={styles.expiry}>
                      Expires on{' '}
                      {plan?.plan_end_date
                        ? moment(plan?.plan_end_date).format('MMMM Do yyyy')
                        : '-'}
                    </Text>
                  </View>
                  <Image
                    source={require('../../assets/images/carePlan.png')}
                    style={styles.cpimage}
                    resizeMode={'contain'}
                  />
                </View>
              </TouchableOpacity>
            );
          })}
        </ScrollView>
      )}
    </>
  );
};

export default CarePlanView;

const styles = StyleSheet.create({
  compcontainer: {
    marginVertical: 10,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 10,
    width: '100%',
  },
  rowBetween: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  itemSep: {
    width: 10,
  },
  container: {
    marginVertical: 10,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    width: Dimensions.get('screen').width - 45,
  },
  cpimage: {
    height: 80,
    width: 80,
  },
  cp: {
    color: colors.labelDarkGray,
    fontWeight: '600',
    fontSize: 14,
  },
  details: {
    marginRight: 5,
    display: 'flex',
    flexDirection: 'column',
    flex: 1,
  },
  title: {
    color: colors.labelDarkGray,
    fontWeight: '700',
    fontSize: 14,
  },
  subTitle: {
    color: colors.subTitleLightGray,
    fontWeight: '400',
    fontSize: 10,
  },
  expiry: {
    color: colors.darkGray,
    fontSize: 12,
    fontWeight: '400',
  },
  image: {
    width: 80,
    height: 60,
  },
});
