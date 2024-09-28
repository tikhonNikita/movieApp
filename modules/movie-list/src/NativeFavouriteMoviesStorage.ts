import type {TurboModule} from 'react-native';
import {TurboModuleRegistry} from 'react-native';

export interface FavouriteMovie {
  id: number;
  url: string;
  title: string;
  rating: string;
}

export interface Spec extends TurboModule {
  getFavouriteMovies(): FavouriteMovie[];
  addFavouriteMovie(movie: FavouriteMovie): Promise<FavouriteMovie[]>;
  removeFavouriteMovie(movieId: number): Promise<FavouriteMovie[]>;
  removeAllFavouriteMovies(): Promise<void>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('FavouriteMoviesStorage');
