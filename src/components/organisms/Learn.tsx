import {
  Image,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import moment from 'moment';
import LearnItem from '../atoms/LearnItem';

type LearnProps = {
  data: any;
  onPressBookmark: (data: any) => void;
  onPressItem: (contentId: string, contentType: string) => void;
  onPressViewAll: () => void;
};

const Learn: React.FC<LearnProps> = ({
  data,
  onPressBookmark,
  onPressItem,
  onPressViewAll,
}) => {
  return (
    <View style={styles.container}>
      <View style={styles.headerContainer}>
        <Text style={styles.title}>Learn</Text>
        <TouchableOpacity activeOpacity={0.6} onPress={onPressViewAll}>
          <Text style={styles.linkText}>View All</Text>
        </TouchableOpacity>
      </View>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.scrollContainer}
        bounces={false}>
        {data.map((learnData: any, learnIdx: number) => {
          return (
            <LearnItem
              onPressBookmark={onPressBookmark}
              onPressItem={onPressItem}
              learnItem={learnData}
              key={learnIdx}
            />
          );
        })}
      </ScrollView>
    </View>
  );
};

export default Learn;

const styles = StyleSheet.create({
  container: {
    marginVertical: 10,
  },
  headerContainer: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  title: {
    color: colors.black,
    fontFamily: 'SFProDisplay-Bold',
    fontSize: 16,
  },
  linkText: {
    color: colors.themePurple,
    fontSize: 12,
    fontFamily: 'SFProDisplay-Bold',
    textDecorationLine: 'underline',
  },
  scrollContainer: {
    paddingVertical: 10,
  },
});
