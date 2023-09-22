import { StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'
import { navigateTo , navigateToHistory, navigateToBookmark} from '../../routes/Router'

type DrawerMyHealthDiaryProps = {}

const DrawerMyHealthDiary: React.FC<DrawerMyHealthDiaryProps> = ({ }) => {

    const onPressGoals = () => {
        navigateTo('SetGoalsVC')
     }

     const onPressHealthRecords = () => {
        navigateToHistory('Records');
     }
     const onPressBookmarks = () => {
        navigateToBookmark('bookmarks');
     }
    
    return (
        <View style={styles.container}>
            <Text style={styles.headerText}>My Health Diary</Text>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7}  onPress={onPressHealthRecords}>
                <View style={styles.icon}><Icons.DrawerHealthRecords /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>Health Records</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7} onPress={onPressBookmarks}>
                <View style={styles.icon}><Icons.DrawerBookmarks /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>Bookmarks</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7} onPress={onPressGoals}>
                <View style={styles.icon}><Icons.DrawerGoals /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>Goals</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7} onPress={onPressGoals}>
                <View style={styles.icon}><Icons.DrawerHealthTrends /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>Health Trends</Text>
                </View>
            </TouchableOpacity>
        </View>
    )
}

export default DrawerMyHealthDiary

const styles = StyleSheet.create({
    container: {
        marginHorizontal: 10,
        marginVertical: 5,
        paddingVertical: 10,
        backgroundColor: colors.white,
        borderRadius: 12
    },
    headerText: {
        color: colors.black,
        fontSize: 14,
        fontWeight: '700',
        marginHorizontal: 10
    },
    itemContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 5
    },
    icon: {
        marginVertical: 5,
        marginHorizontal: 10
    },
    mhdItemTextContainer: {
        flex: 1,
        borderBottomWidth: 0.5,
        borderBottomColor: colors.lightGrey,
        padding: 10,
    },
    mhdItemText: {

    },
})