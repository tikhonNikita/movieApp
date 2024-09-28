import {API_KEY} from '@env';

const movie_details_url = 'https://api.themoviedb.org/3/movie';

type MovieDetailsResponse = {
  id: number;
  title: string;
  poster_path: string;
  overview: string;
  genres: {id: number; name: string}[];
  vote_average: number;
};

export type Genre = {
  id: number;
  name: string;
};

export type MovieDetails = {
  readonly id: number;
  readonly title: string;
  readonly posterURL: string;
  readonly overview: string;
  readonly genres: Genre[];
  readonly rating: number;
  readonly isFavourite: boolean;
};

export const fetchMovieDetails = async (
  movieId: number,
): Promise<MovieDetails> => {
  const urlParams = new URLSearchParams({api_key: API_KEY});
  const response = await fetch(
    `${movie_details_url}/${movieId}?${urlParams.toString()}`,
  );

  if (!response.ok) {
    const errorData = await response.json();
    throw new Error(
      `Error ${response.status}: ${response.statusText} - ${errorData.status_message}`,
    );
  }

  const data: MovieDetailsResponse = await response.json();

  return {
    id: data.id,
    title: data.title,
    posterURL: `https://image.tmdb.org/t/p/original${data.poster_path}`,
    overview: data.overview,
    genres: data.genres,
    rating: data.vote_average,
    isFavourite: false,
  };
};
