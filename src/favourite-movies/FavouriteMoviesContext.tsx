import {noop} from 'lodash';
import React, {
  createContext,
  FC,
  PropsWithChildren,
  useEffect,
  useState,
} from 'react';
import {RealmMoviesStorage, type FavouriteMovie} from 'react-native-movie-list';

type FavouriteMoviesContextType = {
  favouriteMovies: FavouriteMovie[];
  addFavouriteMovie: (movieId: FavouriteMovie) => void;
  removeFavouriteMovie: (movieId: number) => void;
  removeAllFavouriteMovies: () => void;
};

export const FavouriteMoviesContext = createContext<FavouriteMoviesContextType>(
  {
    favouriteMovies: [],
    addFavouriteMovie: noop,
    removeFavouriteMovie: noop,
    removeAllFavouriteMovies: noop,
  },
);

export const FavouriteMoviesProvider: FC<PropsWithChildren> = ({children}) => {
  const [favouriteMovies, setFavouriteMovies] = useState<FavouriteMovie[]>([]);

  useEffect(() => {
    setFavouriteMovies(RealmMoviesStorage.getFavouriteMovies());
  }, []);

  const addFavouriteMovie = async (movie: FavouriteMovie) => {
    const movies = await RealmMoviesStorage.addFavouriteMovie(movie);
    setFavouriteMovies(movies);
  };

  const removeFavouriteMovie = async (movieId: number) => {
    const movies = await RealmMoviesStorage.removeFavouriteMovie(movieId);
    setFavouriteMovies(movies);
  };

  const removeAllFavouriteMovies = async () => {
    await RealmMoviesStorage.removeAllFavouriteMovies();
    setFavouriteMovies([]);
  };

  return (
    <FavouriteMoviesContext.Provider
      value={{
        favouriteMovies,
        addFavouriteMovie,
        removeFavouriteMovie,
        removeAllFavouriteMovies,
      }}>
      {children}
    </FavouriteMoviesContext.Provider>
  );
};
