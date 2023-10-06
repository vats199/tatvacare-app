import {View, Text, StyleSheet} from 'react-native';
import {colors} from '../../constants/colors';
import React from 'react';
import {TouchableOpacity} from 'react-native-gesture-handler';
import {Icons} from '../../constants/icons';

type RoutineHeaderProps = {
  date: String;
  Vadlidity: String;
};
const RoutineHeader: React.FC<RoutineHeaderProps> = ({date, Vadlidity}) => {
  const TabArray = [
    {
      id: 1,
      title: 'Routine 1',
      selected: true,
    },
    {
      id: 2,
      title: 'Routine 2',
      selected: false,
    },
    {
      id: 3,
      title: 'Routine 3',
      selected: false,
    },
  ];
  const [tab, setTab] = React.useState(TabArray);

  const handlePress = (id: number) => {
    const updatedTabArray = TabArray.map(item => ({
      ...item,
      selected: id === item?.id ? true : false,
    }));

    setTab(updatedTabArray);
  };

  return (
    <View style={styles.haederContainer}>
      <View style={styles.headerTitleContainer}>
        <Text style={styles.headerTitle}> Exercise Plan Name</Text>
        <View style={styles.dateBox}>
          <Icons.calendar />
          <Text style={styles.dateText}>{date}</Text>
        </View>
      </View>
      <Text style={styles.haederContent}>{Vadlidity}</Text>
      <View style={styles.routineTab}>
        {tab?.map((item: any) => {
          return (
            <TouchableOpacity onPress={() => handlePress(item.id)}>
              <Text
                style={
                  item?.selected
                    ? styles.routineSelectedTabText
                    : styles?.routineUnselectedTabText
                }>
                {item.title}
              </Text>
              {item?.selected ? (
                <View style={styles.routineTabUnderline}></View>
              ) : null}
            </TouchableOpacity>
          );
        })}
      </View>
    </View>
  );
};

export default RoutineHeader;

const styles = StyleSheet.create({
  haederContainer: {
    margin: 5,
    marginHorizontal: 20,
    marginTop: '7%',
    flex: 0.2,
  },
  headerTitleContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  headerTitle: {
    fontSize: 22,
    fontWeight: '700',
  },
  dateBox: {
    height: 30,
    width: 103,
    borderRightColor: colors.darkBlue,
    borderWidth: 1,
    flexDirection: 'row',
    borderRadius: 6,
    justifyContent: 'center',
    alignItems: 'center',
  },
  dateText: {
    color: colors.darkBlue,
    fontSize: 12,
    textAlign: 'center',
    marginLeft: 2,
  },
  haederContent: {fontSize: 14, color: colors.darkBlue, marginTop: 12},
  cardTitleContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginVertical: 20,
  },
  routineTab: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 12,
  },
  routineSelectedTabText: {
    color: colors.themePurple,
    fontSize: 16,
    fontWeight: '700',
  },
  routineUnselectedTabText: {
    fontSize: 16,
    color: colors.darkBlue,
    fontWeight: '400',
  },
  routineTabUnderline: {
    backgroundColor: colors.themePurple,
    height: 4,
    borderRadius: 4,
    marginVertical: 10,
  },
});
