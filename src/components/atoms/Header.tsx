import { StyleSheet, Text, View, TouchableOpacity, ViewStyle, TextStyle } from 'react-native'
import React from 'react'
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';

interface HeaderProps {
  title?: string,
  isIcon?: boolean,
  icon?: any,
  containerStyle?: ViewStyle,
  titleStyle?: TextStyle,
  onIconPress?: () => {} | void,
  onBackPress?: () => {} | void
}

const Header: React.FC<HeaderProps> = ({
  title, isIcon = false, icon, containerStyle, titleStyle, onIconPress, onBackPress }) => {
  return (
    <View style={containerStyle}>
      <View style={styles.row}>
        <View style={styles.subRow}>
          <Icons.backArrow height={20} width={20} onPress={onBackPress} />
          <Text style={[styles.titleText, titleStyle]}>{title}</Text>
        </View>
        <TouchableOpacity onPress={onIconPress}>
          {
            isIcon && (
              icon
            )
          }
        </TouchableOpacity>
      </View>
    </View>
  )
}

export default Header

const styles = StyleSheet.create({
  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center"
  },
  subRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center"
  },
  titleText: {
    fontSize: 14,

  }
})