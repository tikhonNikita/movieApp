//
//  IntermediateFavouriteMovie.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 06.08.2024.
//


import Foundation

@objcMembers
public class IntermediateFavouriteMovie: NSObject {
    public let id: Int
    public let url: String
    public let title: String
    public let rating: String

    @objc
    public init(id: Int, url: String, title: String, rating: String) {
        self.id = id
        self.url = url
        self.title = title
        self.rating = rating
    }

    convenience init(realmMovie: RealmFavouriteMovie) {
        self.init(id: realmMovie.id, url: realmMovie.url, title: realmMovie.title, rating: realmMovie.rating)
    }

    @objc
    public static func createIntermediateMovie(id: Int, url: String, status: String, title: String, rating: String) -> IntermediateFavouriteMovie {
        return IntermediateFavouriteMovie(id: id, url: url, title: title, rating: rating)
    }
}
