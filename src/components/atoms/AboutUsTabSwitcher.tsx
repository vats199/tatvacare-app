import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';

type AboutUsTabSwitcherProps = {
  activeTab: 'about' | 'terms' | 'policy';
  setActiveTab: React.Dispatch<
    React.SetStateAction<'about' | 'terms' | 'policy'>
  >;
};

const AboutUsTabSwitcher: React.FC<AboutUsTabSwitcherProps> = ({
  activeTab,
  setActiveTab,
}) => {
  return (
    <View style={styles.row}>
      <TouchableOpacity
        style={[styles.tab, activeTab === 'about' && styles.activeTab]}
        activeOpacity={0.7}
        onPress={() => setActiveTab('about')}>
        <Text
          style={[styles.tabText, activeTab === 'about' && styles.activeText]}>
          About Us
        </Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={[styles.tab, activeTab === 'terms' && styles.activeTab]}
        activeOpacity={0.7}
        onPress={() => setActiveTab('terms')}>
        <Text
          style={[styles.tabText, activeTab === 'terms' && styles.activeText]}>
          T&C's
        </Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={[styles.tab, activeTab === 'policy' && styles.activeTab]}
        activeOpacity={0.7}
        onPress={() => setActiveTab('policy')}>
        <Text
          style={[styles.tabText, activeTab === 'policy' && styles.activeText]}>
          Privacy Policy
        </Text>
      </TouchableOpacity>
    </View>
  );
};

export default AboutUsTabSwitcher;

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  tab: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
    justifyContent: 'center',
    borderBottomColor: colors.lightGrey,
    borderBottomWidth: 1,
  },
  activeTab: {
    borderBottomColor: colors.themePurple,
    borderBottomWidth: 3,
  },
  tabText: {
    color: colors.subTitleLightGray,
    fontWeight: '400',
    fontSize: 14,
  },
  activeText: {
    fontWeight: 'bold',
    color: colors.themePurple,
  },
});
