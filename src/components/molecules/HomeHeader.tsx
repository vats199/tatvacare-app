import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react'
import { Icons } from '../../constants/icons'

type HomeHeaderProps = {
    onPressLocation: () => void,
    onPressBell: () => void,
    onPressProfile: () => void
}

const HomeHeader: React.FC<HomeHeaderProps> = ({onPressBell, onPressLocation ,onPressProfile}) => {
    return (
        <View style={styles.rowBetween}>
            <View>
                <Icons.MyTatvaLogo />
                <TouchableOpacity activeOpacity={0.6} style={styles.locationContainer} onPress={onPressLocation}>
                    <Text>Location</Text>
                    <Icons.Dropdown />
                </TouchableOpacity>
            </View>
            <View style={styles.row}>
                <TouchableOpacity activeOpacity={0.6} onPress={onPressBell} style={styles.bellContainer}>
                    <Icons.Bell />
                </TouchableOpacity>
                <TouchableOpacity activeOpacity={0.6} onPress={onPressProfile} style={styles.profileImageContainer}>
                    <Image source={{ uri: `https://randomuser.me/api/portraits/men/44.jpg` }} style={styles.userImg} resizeMode={'cover'} />
                </TouchableOpacity>
            </View>
        </View>
    )
}

export default HomeHeader

const styles = StyleSheet.create({
    headerContainer: {
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    locationContainer: {
        display: 'flex',
        flexDirection: 'row',
        alignItems: 'center',
        gap: 5
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    rowBetween: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
    bellContainer: {
        marginRight: 10
    },
    profileImageContainer: {
        marginLeft: 10,
        borderRadius: 14,
        height: 28,
        width: 28,
        overflow: 'hidden'
    },
    userImg: {
        height: '100%',
        width: '100%'
    },
})