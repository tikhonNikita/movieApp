import React, {FC} from 'react';
import {Image, StyleSheet, Text, useWindowDimensions, View} from 'react-native';
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withSpring,
  runOnJS,
  useAnimatedReaction,
} from 'react-native-reanimated';
import {Gesture, GestureDetector} from 'react-native-gesture-handler';
import {FavouriteMovie} from 'react-native-movie-list';

type FavouriteMovieItemProps = {
  favouriteMovie: FavouriteMovie;
  onRemove: (id: number) => void;
};

export const FavouriteMovieItem: FC<FavouriteMovieItemProps> = ({
  favouriteMovie,
  onRemove,
}) => {
  const {width} = useWindowDimensions();

  const translateX = useSharedValue(0);
  const itemIsVisible = useSharedValue(1);
  const hasTriggeredCallback = useSharedValue(false);

  const swipeGesture = Gesture.Pan()
    .onUpdate(event => {
      translateX.value = event.translationX;
    })
    .onEnd(event => {
      if (event.translationX < -(width * 0.2)) {
        translateX.value = withSpring(-width);
        itemIsVisible.value = withSpring(0);
      } else {
        translateX.value = withSpring(0);
      }
    })
    .activeOffsetX(-10);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{translateX: translateX.value}],
    opacity: itemIsVisible.value ? 1 : 0,
  }));

  useAnimatedReaction(
    () => translateX.value,
    currentValue => {
      if (currentValue <= -(width * 0.75) && !hasTriggeredCallback.value) {
        hasTriggeredCallback.value = true;
        runOnJS(onRemove)(favouriteMovie.id);
      }
    },
  );

  return (
    <Animated.View style={animatedStyle}>
      <GestureDetector gesture={swipeGesture}>
        <View style={styles.contentContainer}>
          <Image source={{uri: favouriteMovie.url}} style={styles.image} />
          <Text>{favouriteMovie.title}</Text>
        </View>
      </GestureDetector>
    </Animated.View>
  );
};

const styles = StyleSheet.create({
  contentContainer: {
    marginVertical: 8,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-start',
    gap: 8,
    padding: 4,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    borderRadius: 8,
    shadowOpacity: 0.23,
    shadowRadius: 2.62,
    backgroundColor: 'lightgrey',
  },
  image: {width: 70, height: 70, borderRadius: 8},
});
