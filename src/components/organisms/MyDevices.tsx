import {FlatList, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';

type MyDevicesDataType = {
  id: number;
  title: string;
  date: string;
  icon: React.ReactNode;
};
type MyDevicesProps = {
  onPress: (title: string) => void;
};

const MyDevices: React.FC<MyDevicesProps> = ({onPress}) => {
  const myDevicesData: MyDevicesDataType[] = [
    {
      id: 1,
      title: 'Smart Analyser',
      date: 'Date & Time',
      icon: (
        <Icons.SmartAnalyser height={Matrics.s(28)} width={Matrics.s(28)} />
      ),
    },
    {
      id: 2,
      title: 'Lung Function Analyser',
      date: 'Date & Time',
      icon: <Icons.LungFunction height={Matrics.s(28)} width={Matrics.s(28)} />,
    },
  ];

  const renderItem = ({
    item,
    index,
  }: {
    item: MyDevicesDataType;
    index: number;
  }) => {
    return (
      <>
        <View style={styles.itemContainer}>
          <View style={styles.itemIconContainer}>
            {item.icon}
            <View style={styles.itemTxtContainer}>
              <Text numberOfLines={1} style={styles.itemTitleTxt}>
                {item.title}
              </Text>
              <Text numberOfLines={1} style={styles.itemDateTxt}>
                Last synced on {item.date}
              </Text>
            </View>
          </View>
          <TouchableOpacity
            onPress={() => onPress(item.title)}
            activeOpacity={0.5}>
            <Text style={styles.connectTxt}>Connect</Text>
          </TouchableOpacity>
        </View>
        {index !== myDevicesData.length - 1 ? (
          <View style={styles.itemSeprator} />
        ) : null}
      </>
    );
  };

  return (
    <>
      <Text style={styles.myDevicesTxt}>My Devices</Text>
      <FlatList
        scrollEnabled={false}
        data={myDevicesData}
        renderItem={renderItem}
        style={styles.deviceDataListContainer}
        contentContainerStyle={styles.deviceDataListContentContainer}
      />
    </>
  );
};

export default MyDevices;

const styles = StyleSheet.create({
  myDevicesTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    lineHeight: Matrics.vs(20),
    color: colors.labelDarkGray,
    marginHorizontal: Matrics.s(15),
    marginVertical: Matrics.vs(15),
  },
  deviceDataListContainer: {
    paddingHorizontal: Matrics.s(15),
    paddingVertical: Matrics.vs(3),
    marginBottom: Matrics.s(10),
  },
  deviceDataListContentContainer: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.04,
    shadowRadius: 3,
    elevation: 1,
    borderRadius: Matrics.s(15),
    overflow: 'hidden',
    backgroundColor: colors.white,
  },
  itemContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: colors.white,
    padding: Matrics.s(10),
  },
  itemIconContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    flex: 1,
  },
  itemTxtContainer: {
    marginHorizontal: Matrics.s(10),
    flex: 1,
  },
  itemTitleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
    fontWeight: '400',
    lineHeight: Matrics.vs(18),
    color: colors.labelDarkGray,
  },
  itemDateTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '300',
    lineHeight: Matrics.vs(16),
    color: colors.inactiveGray,
  },
  connectTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '700',
    lineHeight: Matrics.vs(16),
    color: colors.themePurple,
  },
  itemSeprator: {
    height: Matrics.vs(1),
    backgroundColor: colors.lightGray,
    marginLeft: Matrics.s(50),
  },
});
