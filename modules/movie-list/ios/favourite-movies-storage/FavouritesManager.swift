//
//  FavouritesManager.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 03.08.2024.
//

import RealmSwift

import Foundation
import RealmSwift

import Foundation
import RealmSwift

@objc
public class FavouriteMoviesStorageManager: NSObject {
    @objc public static let shared = FavouriteMoviesStorageManager()
    private var realm: Realm

    private override init() {
        realm = try! Realm()
    }

    @objc
    public func addFavouriteID(_ favouriteID: Int) {
        let favouriteIDs = fetchOrCreateFavouriteIDs()
        if !favouriteIDs.favouriteIDs.contains(favouriteID) {
            try! realm.write {
                favouriteIDs.favouriteIDs.append(favouriteID)
            }
        }
    }

    @objc
    public func removeFavouriteID(_ favouriteID: Int) {
        let favouriteIDs = fetchOrCreateFavouriteIDs()
        if let index = favouriteIDs.favouriteIDs.firstIndex(of: favouriteID) {
            try! realm.write {
                favouriteIDs.favouriteIDs.remove(at: index)
            }
        }
    }

    @objc
    public func clearFavouriteIDs() {
        let favouriteIDs = fetchOrCreateFavouriteIDs()
        try! realm.write {
            favouriteIDs.favouriteIDs.removeAll()
        }
    }

    @objc
    public func fetchAllFavouriteIDs() -> [NSNumber] {
        let favouriteIDs = fetchOrCreateFavouriteIDs()
        return favouriteIDs.favouriteIDs.map { NSNumber(value: $0) }
    }

    // Helper method to ensure there is always one FavouriteIDs instance
    private func fetchOrCreateFavouriteIDs() -> FavouriteIDs {
        if let favouriteIDs = realm.object(ofType: FavouriteIDs.self, forPrimaryKey: "unique_id") {
            return favouriteIDs
        } else {
            let newFavouriteIDs = FavouriteIDs()
            newFavouriteIDs.id = "unique_id"
            try! realm.write {
                realm.add(newFavouriteIDs)
            }
            return newFavouriteIDs
        }
    }
}
