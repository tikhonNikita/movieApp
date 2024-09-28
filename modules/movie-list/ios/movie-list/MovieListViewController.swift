//
//  MovieListViewController.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 06.07.2024.
//

import Foundation
import SwiftUI


import SwiftUI

@objc public class MovieListViewController: UIViewController {
    private var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupHostingController()
    }

    @objc public static func createViewController() -> MovieListViewController {
        let viewModel = MovieViewModel(movies: [])
        return MovieListViewController(viewModel: viewModel)
    }
    
    @objc public func updateMovies(movies: [Movie]) -> Void {
        self.viewModel.updateMovies(newMovies: movies)
    }
    
    @objc public func updateMovieListStatus(status: NetworkStatus) -> Void {
        self.viewModel.updateMovieListStatus(status: status)
    }
    
    @objc public func updateOnMovieAddedToFavoritesHandler(onAddToFavourites: @escaping (Int) -> Void) {
        self.viewModel.setOnMovieAddedToFavorites(onMovieAddedToFavorites: onAddToFavourites)
    }
    
    @objc public func updateOnMovieRemovedFromFavoritesHandler(onMovieRemove: @escaping (Int) -> Void) {
        self.viewModel.setOnMovieRemovedToFavorites(onMovieRemovedToFavorites: onMovieRemove)
    }
    
    @objc public func updateOnMoreMoviesRequested(onMoreMoviesRequested: @escaping () -> Void) -> Void {
        self.viewModel.setOnMoreMoviesRequested(onMoreMoviesRequested: onMoreMoviesRequested)
    }

    
    @objc public func updateOnMoviePressHandler(onMoviePress: @escaping (Int) -> Void) -> Void {
        viewModel.setOnPressHandler(onMoviePress: onMoviePress)
    }
    
    
    @objc public func updateSelectedMovieDetailsStatus(status: NetworkStatus) -> Void {
        self.viewModel.updateMovieDetailsStatus(status: status)
    }
    
    @objc public func updateSelectedMovieDetails(selectedMovie: MovieDetails) -> Void {
        self.viewModel.updateSelectedMovieDetails(newSelectedMovie: selectedMovie)
    }


    private func setupHostingController() {
        let hostingController = UIHostingController(rootView: MovieList(viewModel: viewModel))
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
