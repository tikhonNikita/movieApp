import {type FavouriteMovie} from './NativeFavouriteMoviesStorage';
export type {FavouriteMovie} from './NativeFavouriteMoviesStorage';

export {default as MovieListView} from './MovieListViewNativeComponent';
export * from './MovieListViewNativeComponent';

const FavouriteMoviesStorage =
  require('./NativeFavouriteMoviesStorage').default;

export const RealmMoviesStorage = {
  getFavouriteMovies: (): FavouriteMovie[] =>
    FavouriteMoviesStorage.getFavouriteMovies(),
  addFavouriteMovie: (movie: FavouriteMovie): Promise<FavouriteMovie[]> =>
    FavouriteMoviesStorage.addFavouriteMovie(movie),
  removeAllFavouriteMovies: (): Promise<void> =>
    FavouriteMoviesStorage.removeAllFavouriteMovies(),
  removeFavouriteMovie: (id: number): Promise<FavouriteMovie[]> =>
    FavouriteMoviesStorage.removeFavouriteMovie(id),
};
