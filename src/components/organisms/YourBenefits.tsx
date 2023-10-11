import {FlatList, StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import {Icons} from '../../constants/icons';

type YourBenefitsItemDescription = {
  id: number;
  title: string;
};

type YourBenefitsItem = {
  id: number;
  title: string;
  description?: YourBenefitsItemDescription[];
};

const YourBenefits = () => {
  const yourBenefits: YourBenefitsItem[] = [
    {
      id: 1,
      title: 'Consultaions with our qualified Health coaches.',
      description: [
        {
          id: 1,
          title: 'Nutritionist - 12 sessions',
        },
        {
          id: 2,
          title: 'Physiotherapist - 24 sessions',
        },
        {
          id: 3,
          title: 'Success coach - 3 sessions',
        },
      ],
    },
    {
      id: 2,
      title:
        'Diagnostic tests at the start and end of the plan to analyse your progress.Test include:',
      description: [
        {
          id: 1,
          title: 'Liver Profile',
        },
        {
          id: 2,
          title: 'Complete Blood Count',
        },
        {
          id: 3,
          title: 'HBA1C',
        },
        {
          id: 4,
          title: 'Fasting Blood Sugar',
        },
        {
          id: 5,
          title: 'Blood Sugar Post Prandial (PPBS)',
        },
        {
          id: 6,
          title: 'Lipid Profile',
        },
      ],
    },
    {
      id: 3,
      title:
        'You can integrate your existing wearable device with MyTatva app for better activity tracking.',
    },
    {
      id: 4,
      title: 'Body Composition Analysis Machine to track your progress.',
    },
    {
      id: 5,
      title: 'Additional MyTatva app features:',
      description: [
        {
          id: 1,
          title: 'Diet tracking',
        },
        {
          id: 2,
          title: 'Vital tracking',
        },
        {
          id: 3,
          title: 'Activity tracking',
        },
        {
          id: 4,
          title: 'Sleep tracking',
        },
      ],
    },
  ];

  const renderItemDescription = (
    item: YourBenefitsItemDescription,
    index: number,
  ) => {
    const {id, title} = item;
    return (
      <View style={styles.descriptionBenefitsContainer}>
        <View style={styles.descriptionDot} />
        <Text numberOfLines={1} style={styles.descriptionTitleTxt}>
          {title}
        </Text>
      </View>
    );
  };

  const renderItem = ({
    item,
    index,
  }: {
    item: YourBenefitsItem;
    index: number;
  }) => {
    const {id, title, description} = item;
    return (
      <View style={styles.benefitsItemContainer}>
        <Icons.Correct height={Matrics.s(19)} width={Matrics.s(19)} />
        <View style={styles.benefitsItemSubContainer}>
          <Text numberOfLines={2} style={styles.benefitsTitleTxt}>
            {title}
          </Text>
          <View
            style={{
              paddingVertical: Matrics.s(7),
            }}>
            {description?.map(renderItemDescription)}
          </View>
        </View>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <Text numberOfLines={1} style={styles.yourServicesTxt}>
        YourBenefits
      </Text>
      <FlatList
        data={yourBenefits}
        scrollEnabled={false}
        renderItem={renderItem}
        style={{
          marginTop: Matrics.s(14),
        }}
      />
    </View>
  );
};

export default YourBenefits;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.white,
    paddingVertical: Matrics.s(10),
    paddingHorizontal: Matrics.s(17),
  },
  yourServicesTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(15),
    fontWeight: '600',
    color: colors.black,
  },
  benefitsItemContainer: {
    flexDirection: 'row',
    flex: 1,
  },
  benefitsItemSubContainer: {
    marginLeft: Matrics.s(10),
    flex: 1,
  },
  benefitsTitleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    color: colors.labelTitleDarkGray,
  },
  descriptionBenefitsContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingLeft: Matrics.s(8),
    paddingVertical: Matrics.s(1),
  },
  descriptionDot: {
    height: Matrics.s(3),
    width: Matrics.s(3),
    backgroundColor: colors.labelTitleDarkGray,
    borderRadius: Matrics.s(3),
  },
  descriptionTitleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    color: colors.labelTitleDarkGray,
    marginLeft: Matrics.s(10),
  },
});
