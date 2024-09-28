import {TrendingMoviesResponse} from './../api/fetchTrendingMovies';
import {useInfiniteQuery} from '@tanstack/react-query';
import {fetchTrendingMovies, Movie} from '../api/fetchTrendingMovies';
import {pendingToLoading} from '../utils';
import {RequestStatus} from './useMovieDetails';
import flatMap from 'lodash/flatMap';

type MovieQueryResult = {
  movies: Movie[];
  trendingMoviesRequestStatus: RequestStatus;
  fetchNextPage: () => void;
};
const nextPageParam = (lastPage: TrendingMoviesResponse) => {
  return lastPage.page < lastPage.totalPages ? lastPage.page + 1 : null;
};

export const useMovies = (): MovieQueryResult => {
  const {data, error, fetchNextPage, isFetchingNextPage, status} =
    useInfiniteQuery({
      queryKey: ['trendingMovies'],
      queryFn: ({pageParam = 1}) => fetchTrendingMovies(pageParam),
      getNextPageParam: nextPageParam,
      initialPageParam: 1,
    });

  const movies = flatMap(data?.pages, page => page.movies) || [];

  const trendingMoviesRequestStatus = pendingToLoading(
    status,
    isFetchingNextPage,
  );

  if (error) {
    console.log(error);
  }

  return {
    movies,
    trendingMoviesRequestStatus,
    fetchNextPage,
  };
};
