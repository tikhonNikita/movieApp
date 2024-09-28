//
//  MovieDetails.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 23.07.2024.
//

import Foundation

@objc public class Genre: NSObject, Identifiable {
    @objc public let id: Int
    @objc public let name: String
    
    @objc init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    @objc public static func createGenre(id: Int, name: String) -> Genre {
        return Genre(id: id, name: name)
    }
}


@objc public class MovieDetails: NSObject, Identifiable {
    @objc public let id: Int
    @objc public let posterURL: String
    @objc public let title: String
    @objc public let overview: String
    @objc public let genres: [Genre]
    @objc public let isFavourite: Bool
    
    @objc init(id: Int, posterURL: String, title: String, overview: String, genres: [Genre], isFavourite: Bool) {
        self.id = id
        self.posterURL = posterURL
        self.title = title
        self.overview = overview
        self.genres = genres
        self.isFavourite = isFavourite
    }
    //need it to be able to create instance in Obj-c
    @objc public static func create(id: Int, posterURL: String, title: String, overview: String, rating: Double, genres: [Genre], isFavourite: Bool) -> MovieDetails {
        return MovieDetails(id: id, posterURL: posterURL, title: title, overview: overview, genres: genres, isFavourite: isFavourite)
    }
}
