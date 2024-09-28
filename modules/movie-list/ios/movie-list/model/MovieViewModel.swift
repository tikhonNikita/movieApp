//
//  MoviesViewModel.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 06.07.2024.
//

import Foundation
import SwiftUI


@objc public enum NetworkStatus: Int {
    case loading
    case error
    case success
}

public class MovieViewModel: NSObject, ObservableObject {
    @Published public var movies: [Movie] = []
    @Published public var selectedMovieDetails: MovieDetails?
    @Published public var seletedMovieDetailsStatus: NetworkStatus
    @Published public var movieListStatus: NetworkStatus
    @Published var onMoviePress: ((Int) -> Void)?
    @Published var onMovieAddedToFavorites: ((Int) -> Void) = { _ in }
    @Published var onMovieRemovedToFavorites: ((Int) -> Void) = {_ in }
    @Published var onMoreMoviesRequested: () -> Void = {}

    
    public override init() {
        self.movies = []
        self.movieListStatus = .loading
        self.seletedMovieDetailsStatus = .loading
        super.init()
    }
    
    public init(movies: [Movie]) {
        if(movies.isEmpty) {
            self.movieListStatus = .loading
        } else {
            self.movieListStatus = .success
        }
        self.seletedMovieDetailsStatus = .loading
        super.init()
        self.movies = movies
    }
    
    public func updateMovies(newMovies: [Movie]) {
        self.movies = newMovies
    }
    
    public func updateMovieListStatus(status: NetworkStatus) {
        if(self.movies.count > 0 && status != .success) {
            return
        }
        self.movieListStatus = status
    }
    
    public func setOnPressHandler(onMoviePress: @escaping ((Int) -> Void)) {
        self.onMoviePress = onMoviePress
    }
    
    public func setOnMovieAddedToFavorites(onMovieAddedToFavorites: @escaping ((Int) -> Void)) {
        self.onMovieAddedToFavorites = onMovieAddedToFavorites
    }
    public func setOnMovieRemovedToFavorites(onMovieRemovedToFavorites: @escaping ((Int) -> Void)) {
        self.onMovieRemovedToFavorites = onMovieRemovedToFavorites
    }
    
    public func updateMovieDetailsStatus(status: NetworkStatus) {
        self.seletedMovieDetailsStatus = status
    }
    
    public func updateSelectedMovieDetails(newSelectedMovie: MovieDetails) {
        self.selectedMovieDetails = newSelectedMovie
    }
    
    public func setOnMoreMoviesRequested(onMoreMoviesRequested: @escaping () -> Void) {
        self.onMoreMoviesRequested = onMoreMoviesRequested
    }

}

