import {
  FlatList,
  LayoutAnimation,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React, {useState} from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import {Icons} from '../../constants/icons';
import Animated from 'react-native-reanimated';
import {useIsFocused} from '@react-navigation/native';

type FaqsItem = {
  id: number;
  title: string;
  description: string;
};

const AppointmentFaqs = () => {
  const [selectedItem, setItemSelected] = useState<number | null>(null);

  const focus = useIsFocused();

  const faqs: FaqsItem[] = [
    {
      id: 1,
      title: 'What is a care plan?',
      description:
        'Care health insurance plan is a comprehensive medical policy for individuals and families.It is an ideal plan for those who want a higher sum insured option to secure their present and future from medical expenses.',
    },
    {
      id: 2,
      title: 'What is a care plan?',
      description:
        'Care health insurance plan is a comprehensive medical policy for individuals and families.It is an ideal plan for those who want a higher sum insured option to secure their present and future from medical expenses.',
    },
    {
      id: 3,
      title: 'What is things are covered in care plan?',
      description:
        'Care health insurance plan is a comprehensive medical policy for individuals and families.It is an ideal plan for those who want a higher sum insured option to secure their present and future from medical expenses.',
    },
  ];

  const onFaqItemPress = (index: number) => {
    if (selectedItem !== index) {
      setItemSelected(index);
    } else {
      setItemSelected(null);
    }
    focus
      ? LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut)
      : null;
  };

  const renderItem = ({item, index}: {item: FaqsItem; index: number}) => {
    const {title, description, id} = item;
    const itemSelected = selectedItem === index;
    return (
      <>
        <TouchableOpacity
          activeOpacity={0.9}
          onPress={() => onFaqItemPress(index)}>
          <View style={styles.faqSubContainer}>
            <Text style={styles.faqTitleTxt}>{title}</Text>
            <Icons.Dropdown
              height={Matrics.s(8.5)}
              width={Matrics.s(8.5)}
              style={{
                transform: [{rotate: itemSelected ? '180deg' : '360deg'}],
              }}
            />
          </View>
          {itemSelected ? (
            <Animated.Text style={styles.faqDesTxt}>
              {description}
            </Animated.Text>
          ) : null}
        </TouchableOpacity>
        {index !== faqs.length - 1 ? (
          <View style={styles.faqsSeprator} />
        ) : null}
      </>
    );
  };

  return (
    <View style={styles.container}>
      <Text numberOfLines={1} style={styles.yourServicesTxt}>
        FAQs
      </Text>
      <FlatList
        data={faqs}
        scrollEnabled={false}
        renderItem={renderItem}
        style={{
          marginTop: Matrics.s(14),
        }}
      />
    </View>
  );
};

export default AppointmentFaqs;

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
  faqsSeprator: {
    height: Matrics.s(0.5),
    backgroundColor: colors.darkGray,
    marginVertical: Matrics.s(10),
    opacity: 0.5,
  },
  faqSubContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  faqTitleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(13),
    color: colors.labelDarkGray,
  },
  faqDesTxt: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(10),
    color: colors.subTitleLightGray,
    lineHeight: Matrics.vs(14),
    marginTop: Matrics.vs(5),
  },
});
