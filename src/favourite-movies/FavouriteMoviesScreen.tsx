import React from 'react';
import {FlatList, ListRenderItemInfo, StyleSheet, View} from 'react-native';
import {useFavouriteMovies} from './useFavouriteMovies';
import {FavouriteMovieItem} from './FavouriteMovieItem';
import {FavouriteMovie} from 'react-native-movie-list';

export const FavoritesScreen = () => {
  const {favouriteMovies, removeFavouriteMovie} = useFavouriteMovies();

  const handleRemoveMovie = (id: number) => {
    removeFavouriteMovie(id);
  };

  const renderFavouriteMovie = (
    itemInfo: ListRenderItemInfo<FavouriteMovie>,
  ) => {
    return (
      <FavouriteMovieItem
        favouriteMovie={itemInfo.item}
        onRemove={handleRemoveMovie}
      />
    );
  };

  return (
    <View style={styles.container}>
      <FlatList
        data={favouriteMovies}
        keyExtractor={({id}) => id.toString()}
        renderItem={renderFavouriteMovie}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 8,
  },
});
