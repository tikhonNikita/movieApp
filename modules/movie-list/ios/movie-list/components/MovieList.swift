//
//  MovieList.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 06.07.2024.
//

import SwiftUI

struct MovieList: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var isOpen: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.movieListStatus != .loading {
                List(viewModel.movies.indices, id: \.self) { index in
                    let movie = viewModel.movies[index]
                    MovieItem(movie: movie)
                        .padding(.vertical, 4)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            isOpen = true
                            viewModel.onMoviePress?(movie.id)
                        }
                    
                    if index == viewModel.movies.endIndex - 1 {
                        GradientLoader()
                            .listRowSeparator(.hidden)
                            .onAppear {
                                viewModel.onMoreMoviesRequested()
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(8)
            } else {
                ProgressView()
            }
        }
        .sheet(isPresented: $isOpen) {
            if viewModel.seletedMovieDetailsStatus == .loading {
                ProgressView()
            } else {
                if let movieDetails = viewModel.selectedMovieDetails {
                    MovieDetailsView(
                        movieDetails: movieDetails,
                        onAddToFavourites: viewModel.onMovieAddedToFavorites,
                        onRemoveFromFavourites: viewModel.onMovieRemovedToFavorites
                    ) {
                        isOpen = false
                    }
                } else {
                    Text("Something went wrong")
                }
            }
        }
    }
}
