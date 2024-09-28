import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type {ViewProps} from 'react-native';
import {
  Double,
  WithDefault,
  DirectEventHandler,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypes';

type Movie = {
  readonly id: Int32;
  readonly title: string;
  readonly url: string;
  readonly movieDescription: string;
  readonly rating: Double;
};

type Genre = {
  id: Int32;
  name: string;
};

type MovieDetails = {
  readonly id: Int32;
  readonly title: string;
  readonly posterURL: string;
  readonly overview: string;
  readonly genres: Genre[];
  readonly rating: Double;
  readonly isFavourite: boolean;
};

export type OnMoviePressEventData = {
  readonly movieID: Int32;
};

export type OnMovieAddedToFavorites = OnMoviePressEventData;

export type OnMovieRemovedFromFavorites = OnMovieAddedToFavorites;

export type OnMovieInteractionCallback =
  DirectEventHandler<OnMoviePressEventData>;

type NetworkStatus = WithDefault<'loading' | 'success' | 'error', 'loading'>;

interface NativeProps extends ViewProps {
  readonly movies: Movie[];
  readonly onMoviePress: DirectEventHandler<OnMoviePressEventData>;
  readonly onMovieAddedToFavorites: DirectEventHandler<OnMovieAddedToFavorites>;
  readonly onMovieRemovedFromFavorites: DirectEventHandler<OnMovieRemovedFromFavorites>;
  readonly movieListStatus?: NetworkStatus;
  readonly movieDetailsStatus?: NetworkStatus;
  readonly movieDetails?: MovieDetails;
  readonly onMoreMoviesRequested: DirectEventHandler<null>;
}

export default codegenNativeComponent<NativeProps>('MovieListView');
