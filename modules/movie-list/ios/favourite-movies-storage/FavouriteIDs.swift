//
//  FavouriteIDs.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 03.08.2024.
//

import RealmSwift

let favouritesID = "favourite_films_ids"
class FavouriteIDs: Object {
    @Persisted var id = favouritesID
    @Persisted var favouriteIDs = List<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
