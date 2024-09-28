import {useQuery} from '@tanstack/react-query';
import {fetchMovieDetails, MovieDetails} from '../api/fetchMovieDetails';
import isUndefined from 'lodash/isUndefined';
import {isDefined, pendingToLoading} from '../utils';
import {FavouriteMovie} from 'react-native-movie-list';

export type RequestStatus = 'success' | 'loading' | 'error';

type MovieDetailsQueryResult = {
  movieDetailsRequestStatus: RequestStatus;
  selectedMovieDetails: MovieDetails | undefined;
};

export const useMovieDetails = (
  movieId: number | undefined,
  favorites: FavouriteMovie[],
): MovieDetailsQueryResult => {
  const queryResult = useQuery<MovieDetails, Error>({
    queryKey: ['movieDetails', movieId],
    queryFn: () => {
      if (isUndefined(movieId)) {
        throw new Error('movieId is null');
      }
      return fetchMovieDetails(movieId);
    },
    enabled: isDefined(movieId),
  });

  const status = pendingToLoading(queryResult.status);

  const data = queryResult.data;
  if (isUndefined(data)) {
    return {movieDetailsRequestStatus: status, selectedMovieDetails: undefined};
  }
  const movieDetails = {
    ...data,
    isFavourite: isDefined(
      favorites.find(favouriteMovie => favouriteMovie.id === data.id),
    ),
  };

  return {
    selectedMovieDetails: movieDetails,
    movieDetailsRequestStatus: status,
  };
};
