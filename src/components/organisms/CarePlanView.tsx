import {
  Dimensions,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  FlatList,
  TouchableHighlight,
  TouchableNativeFeedback,
} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import ProgressBar from '../atoms/ProgressBar';
import moment from 'moment';
import PlanItem from '../atoms/PlanItem';
import {navigateToChronicCareProgram, onPressRenewPlan, openPlanDetails} from '../../routes/Router';

type CarePlanViewProps = {
  data?: any;
  allPlans: any[];
  onPressCarePlan: (plan: any) => void;
  onPressRenew: (plan: any) => void;
};

const CarePlanView: React.FC<CarePlanViewProps> = ({
  data,
  onPressCarePlan,
  onPressRenew,
  allPlans = [],
}) => {
  const isFreePlan: boolean =
    data?.patient_plans && data?.patient_plans[0]?.plan_type === 'Free';

  const getPlanProgress = (plan: any) => {
    if (moment(plan.expiry_date) < moment(new Date())) {
      return 100;
    }
    const totalDuration =
      moment(plan.expiry_date).diff(moment(plan.plan_start_date), 'day') ?? 1;
    const completedDuration = moment(new Date()).diff(
      moment(plan.plan_start_date),
      'day',
    );

    return (completedDuration / totalDuration) * 100 < 0
      ? 0
      : (completedDuration / totalDuration) * 100;
  };

  const onPressKnowMore = (plan: any) => {
    // navigateToChronicCareProgram();
    onPressRenewPlan([{planDetails: plan}]);
   
  };

  const onCarePlanNeedCotainer = () => {
    navigateToChronicCareProgram();
   
   
  };


  const renderPlanItem = ({item, index}: {item: any; index: number}) => {
    return (
      

      <PlanItem plan={item} onPressKnowMore={() => onPressKnowMore(item)} />
    );
  };

  const getText = (plan: any): string => {
    if (moment(plan.expiry_date) < moment(new Date())) {
      return 'Plan Expired';
    }

    const planDuration = moment(plan.expiry_date).diff(new Date(), 'day') + 1;

    if (planDuration > 14) {
      return `Expires on ${moment(plan?.expiry_date).format('MMM Do, yyyy')}`;
    } else {
      return `${planDuration} day(s) remaining`;
    }
  };

  const getColor = (plan: any): string => {
    if (moment(plan.expiry_date) < moment(new Date())) {
      return colors.red;
    }

    const planDuration = moment(plan.expiry_date).diff(new Date(), 'day') + 1;

    if (planDuration > 14) {
      return colors.green;
    } else if (planDuration > 7) {
      return colors.orange;
    } else {
      return colors.red;
    }
  };

  const showRenewButton = (plan: any): boolean => {
    const planDuration = moment(plan.expiry_date).diff(new Date(), 'day') + 1;

    if (planDuration > 14) {
      return false;
    } else {
      return true;
    }
  };

  return (
    <>
      {data?.patient_plans?.length <= 0 || isFreePlan ? (
        <TouchableNativeFeedback onPress={() => onCarePlanNeedCotainer()}>

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
        </TouchableNativeFeedback>

      ) : (
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          bounces={false}>
          {data?.patient_plans?.map((plan: any, planIdx: number) => {
            return (
              <TouchableOpacity
                key={planIdx}
                onPress={() => onPressCarePlan(plan)}
                style={styles.container}>
                <View style={{flex: 1}}>
                  <View style={styles.details}>
                    <Text style={styles.title}>{plan?.plan_name || '-'}</Text>
                    <Text style={styles.subTitle}>
                      {plan?.sub_title || '-'}
                    </Text>
                    <ProgressBar
                      progress={getPlanProgress(plan) || 0}
                      expired={moment(plan.expiry_date) < moment(new Date())}
                    />
                    <View style={styles.rowBetween}>
                      <Text style={[styles.expiry, {color: getColor(plan)}]}>
                        {getText(plan)}
                      </Text>
                      {showRenewButton(plan) && (
                        <TouchableOpacity onPress={() => onPressRenew(plan)}>
                          <Text style={styles.renew}>Renew</Text>
                        </TouchableOpacity>
                      )}
                    </View>
                  </View>
                </View>
                <Image
                  source={require('../../assets/images/carePlan.png')}
                  style={styles.cpimage}
                  resizeMode={'contain'}
                />
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
    shadowColor: '#2121210D',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.1,
    shadowRadius: 1.41,
  },
  rowBetween: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  renew: {
    fontSize: 12,
    fontWeight: '400',
    color: colors.themePurple,
    textDecorationLine: 'underline',
    textDecorationColor: colors.themePurple,
  },
  itemSep: {
    width: 10,
  },
  container: {
    marginVertical: 10,
    marginRight: 10,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    width: Dimensions.get('screen').width - 45,
    shadowColor: '#2121210D',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.1,
    shadowRadius: 1.41,
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
    fontSize: 12,
    fontWeight: '400',
  },
  image: {
    width: 80,
    height: 60,
  },
});
