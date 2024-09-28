import {RequestStatus} from './trending-movies/useMovieDetails';
import negate from 'lodash/negate';
import isUndefined from 'lodash/isUndefined';

export const pendingToLoading = (
  status: 'success' | 'error' | 'pending',
  isFetchingNextPage = false,
): RequestStatus => {
  if (isFetchingNextPage) {
    return 'loading';
  }
  if (status === 'pending') {
    return 'loading';
  }
  return status;
};

export const isDefined = negate(isUndefined);
