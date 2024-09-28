import {API_KEY} from '@env';

const TRENDING_MOVIES_URL = 'https://api.themoviedb.org/3/trending/movie/week';

type ApiMovie = {
  id: number;
  title: string;
  overview: string;
  vote_average: number;
  poster_path: string;
};

type MoviesResponse = {
  results: ApiMovie[];
  page: number;
  total_pages: number;
  total_results: number;
};

export type Movie = {
  id: number;
  url: string;
  title: string;
  movieDescription: string;
  rating: number;
};

export type TrendingMoviesResponse = {
  movies: Movie[];
  page: number;
  totalPages: number;
};

const mapApiMoviesToMovies = (data: MoviesResponse): Movie[] => {
  return data.results.map(movie => ({
    id: movie.id,
    url: `https://image.tmdb.org/t/p/w500${movie.poster_path}`,
    title: movie.title,
    movieDescription: movie.overview,
    rating: movie.vote_average,
  }));
};

export const fetchTrendingMovies = async (
  page = 1,
): Promise<TrendingMoviesResponse> => {
  const urlParams = new URLSearchParams({
    api_key: API_KEY,
    page: page.toString(),
    language: 'en-US',
  });
  const response = await fetch(
    `${TRENDING_MOVIES_URL}?${urlParams.toString()}`,
  );

  if (!response.ok) {
    const errorData = await response.json();
    throw new Error(
      `Error ${response.status}: ${response.statusText} - ${errorData.status_message}`,
    );
  }

  const data: MoviesResponse = await response.json();

  return {
    movies: mapApiMoviesToMovies(data),
    page: data.page,
    totalPages: data.total_pages,
  };
};
