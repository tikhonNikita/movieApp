//
//  FavouriteMovie.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 05.08.2024.
//

import Foundation
import RealmSwift

class RealmFavouriteMovie: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var url: String = ""
    @Persisted var title: String = ""
    @Persisted var rating: String = ""

    override init() {
        super.init()
    }

    convenience init(id: Int, url: String, status: String, title: String, rating: String) {
        self.init()
        self.id = id
        self.url = url
        self.title = title
        self.rating = rating
    }

    convenience init(favouriteMovie: IntermediateFavouriteMovie) {
        self.init()
        self.id = favouriteMovie.id
        self.url = favouriteMovie.url
        self.title = favouriteMovie.title
        self.rating = favouriteMovie.rating
    }
}
