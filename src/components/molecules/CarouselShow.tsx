import { StyleSheet, Text, View, Dimensions, Image } from 'react-native'
import React, { useState } from 'react';
import Carousel from 'react-native-reanimated-carousel';


const width = Dimensions.get('window').width;
type Data = {
    title: string;
    body: string;
    imgUrl: string;
}

const CarouselShow = () => {
    const [activeIndex, setActiveIndex] = useState(1);

    const data: Data[] = [
        {
            title: "Aenean leo",
            body: "Ut tincidunt tincidunt erat. Sed cursus turpis vitae tortor. Quisque malesuada placerat nisl. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.",
            imgUrl: "https://picsum.photos/id/11/200/300",
        },
        {
            title: "In turpis",
            body: "Aenean ut eros et nisl sagittis vestibulum. Donec posuere vulputate arcu. Proin faucibus arcu quis ante. Curabitur at lacus ac velit ornare lobortis. ",
            imgUrl: "https://picsum.photos/id/10/200/300",
        },
        {
            title: "Lorem Ipsum",
            body: "Phasellus ullamcorper ipsum rutrum nunc. Nullam quis ante. Etiam ultricies nisi vel augue. Aenean tellus metus, bibendum sed, posuere ac, mattis non, nunc.",
            imgUrl: "https://picsum.photos/id/12/200/300",
        },
        {
            title: "Lorem Ipsum",
            body: "Phasellus ullamcorper ipsum rutrum nunc. Nullam quis ante. Etiam ultricies nisi vel augue. Aenean tellus metus, bibendum sed, posuere ac, mattis non, nunc.",
            imgUrl: "https://picsum.photos/id/10/200/300",
        },
        {
            title: "Lorem Ipsum",
            body: "Phasellus ullamcorper ipsum rutrum nunc. Nullam quis ante. Etiam ultricies nisi vel augue. Aenean tellus metus, bibendum sed, posuere ac, mattis non, nunc.",
            imgUrl: "https://picsum.photos/id/11/200/300",
        },
    ];

    const RenderDotIndicator = () => {
        return (
            data?.map((dot, index) => {
                if (activeIndex === index) {
                    return (
                        <View key={index} style={{ marginRight: 5, height: 10, width: 10, borderRadius: 5, backgroundColor: '#616161' }}>
                        </View>
                    )
                } else {
                    return (
                        <View key={index} style={{ marginRight: 5, height: 10, width: 10, borderRadius: 5, backgroundColor: '#9E9E9E' }}>
                        </View>
                    )
                }
            })
        )
    }

    return (
        <View>
            <View style={{ width: "100%", height: 200 }}>
                <Carousel
                    loop
                    width={width - 38}
                    height={200}
                    autoPlay={false}
                    data={data}
                    scrollAnimationDuration={500}
                    onSnapToItem={(index) => setActiveIndex(index)}
                    renderItem={({ index }) => (
                        <View style={styles.container}>
                            <Image
                                source={{ uri: data[index].imgUrl }}
                                style={styles.image}
                            />
                        </View>
                    )}
                />
            </View>

            <View style={{
                flexDirection: 'row',
                justifyContent: 'center',
                marginTop: 10
            }}>{RenderDotIndicator()}</View>
        </View>
    )
}

export default CarouselShow;

const styles = StyleSheet.create({
    container: {
        backgroundColor: 'white',
        // borderRadius: 8,
        width: "100%",
        height: "100%",
        paddingBottom: 40,
        shadowColor: "#000",
        shadowOffset: {
            width: 0,
            height: 3,
        },
        shadowOpacity: 0.29,
        shadowRadius: 4.65,
        elevation: 7,
    },
    image: {
        width: "100%",
        height: "100%",
    },

})