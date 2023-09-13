import { Image, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'
import moment from 'moment'

type LearnProps = {
    data: any,
    onPressBookmark: (data: any) => void
}

const Learn: React.FC<LearnProps> = ({ data, onPressBookmark }) => {

    return (
        <View style={styles.container}>
            <View style={styles.headerContainer}>
                <Text style={styles.title}>Learn</Text>
                <TouchableOpacity activeOpacity={0.6}>
                    <Text style={styles.linkText}>View All</Text>
                </TouchableOpacity>
            </View>
            <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.scrollContainer}
                bounces={false}
            >
                {
                    data.map((learnData: any, learnIdx: number) => {
                        return (
                            <View key={learnIdx} style={styles.itemContainer}>
                                <Image style={styles.imageStyle} source={learnData.url ? { uri: learnData.url } : require('../../assets/images/learnImage.jpg')} />
                                <View style={styles.detailsContainer}>
                                    <Text style={styles.itemTitle}>{learnData?.topic_name || '-'}</Text>
                                    <Text style={styles.itemDescription}>{learnData?.title || '-'}</Text>
                                    <View style={styles.bottomContainer}>
                                        <Text style={styles.itemDescription}>{learnData?.publish_date ? moment(learnData?.publish_date).format('MMM D, yyyy') : '-'}</Text>
                                        <TouchableOpacity activeOpacity={0.6}>
                                            <Icons.Bookmark onPress={() => { onPressBookmark(learnData) }} />
                                        </TouchableOpacity>
                                    </View>
                                </View>
                            </View>
                        )
                    })
                }

            </ScrollView>
        </View>
    )
}

export default Learn

const styles = StyleSheet.create({
    container: {
        marginVertical: 10,
    },
    headerContainer: {
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    title: {
        color: colors.black,
        fontWeight: '700',
        fontSize: 16
    },
    linkText: {
        color: colors.themePurple,
        fontSize: 12,
        fontWeight: '700',
        textDecorationLine: 'underline'
    },
    scrollContainer: {
        paddingVertical: 10
    },
    itemContainer: {
        marginBottom: 5,
        backgroundColor: colors.white,
        borderRadius: 12,
        padding: 2,
        width: 260,
        minHeight: 120,
        marginRight: 15,
        flexDirection: 'row',
        alignItems: 'center'
    },
    imageStyle: {
        maxWidth: 100,
        borderTopLeftRadius: 12,
        borderBottomLeftRadius: 12
    },
    detailsContainer: {
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        padding: 10,
        width: '60%'
    },
    itemTitle: {
        flex: 1,
        color: colors.black,
        fontWeight: '600',
        fontSize: 14,
        lineHeight: 18
    },
    itemDescription: {
        flex: 1,
        color: colors.darkGray,
        fontWeight: '300',
        fontSize: 10,
        lineHeight: 12
    },
    bottomContainer: {
        flex: 1,
        display: 'flex',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    }
})