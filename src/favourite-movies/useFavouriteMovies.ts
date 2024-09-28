import {useContext} from 'react';
import {FavouriteMoviesContext} from './FavouriteMoviesContext';
import isEmpty from 'lodash/isEmpty';

export const useFavouriteMovies = () => {
  const favouriteMoviesContext = useContext(FavouriteMoviesContext);
  if (isEmpty(favouriteMoviesContext)) {
    throw new Error('FavouriteMoviesContext is not provided');
  }
  return favouriteMoviesContext;
};
