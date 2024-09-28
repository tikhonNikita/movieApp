import React, {useState} from 'react';
import {SafeAreaView, StyleSheet} from 'react-native';
import {
  MovieListView,
  OnMovieInteractionCallback,
  type FavouriteMovie,
} from 'react-native-movie-list';
import {useMovieDetails} from './useMovieDetails';
import isUndefined from 'lodash/isUndefined';
import {useFavouriteMovies} from '../favourite-movies/useFavouriteMovies';
import {useMovies} from './useMovieList';

export const TrendingMoviesScreen = () => {
  const [selectedMovieId, setSelectedMovieId] = useState<number>();

  const {movies, trendingMoviesRequestStatus, fetchNextPage} = useMovies();
  const {favouriteMovies, addFavouriteMovie, removeFavouriteMovie} =
    useFavouriteMovies();

  const {selectedMovieDetails, movieDetailsRequestStatus} = useMovieDetails(
    selectedMovieId,
    favouriteMovies,
  );

  const onFavoritesPress = () => {
    if (isUndefined(selectedMovieDetails)) {
      return;
    }

    const finalMovieToAdd: FavouriteMovie = {
      id: selectedMovieDetails.id,
      url: selectedMovieDetails.posterURL,
      title: selectedMovieDetails.title,
      rating: selectedMovieDetails.rating.toString(),
    };

    addFavouriteMovie(finalMovieToAdd);
  };

  const onMovieRemovedFromFavorites: OnMovieInteractionCallback = ({
    nativeEvent: {movieID},
  }) => {
    removeFavouriteMovie(movieID);
  };

  const onMoviePress: OnMovieInteractionCallback = ({
    nativeEvent: {movieID},
  }) => {
    setSelectedMovieId(Number(movieID));
  };

  const onMoreMoviesRequested = () => {
    fetchNextPage();
  };

  return (
    <SafeAreaView style={styles.container}>
      <MovieListView
        onMoreMoviesRequested={onMoreMoviesRequested}
        onMovieRemovedFromFavorites={onMovieRemovedFromFavorites}
        onMoviePress={onMoviePress}
        movieDetailsStatus={movieDetailsRequestStatus}
        movieDetails={selectedMovieDetails}
        movies={movies || []}
        style={StyleSheet.absoluteFill}
        movieListStatus={trendingMoviesRequestStatus}
        onMovieAddedToFavorites={onFavoritesPress}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
