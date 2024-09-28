//
//  FavouriteMoviesManager.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 05.08.2024.
//

import Foundation
import RealmSwift

@objc
public class FavouriteMoviesManager: NSObject {
    @objc public static let shared = FavouriteMoviesManager()
    
    private override init() {}
    
    @objc
    public func addFavouriteMovie(_ movie: IntermediateFavouriteMovie, onSuccess: @escaping ([IntermediateFavouriteMovie]) -> Void, onError: @escaping (Error) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let realmMovie = RealmFavouriteMovie(favouriteMovie: movie)
                let realm = try Realm()
                
                try realm.write {
                    realm.add(realmMovie, update: .modified)
                }
                
                let movies = realm.objects(RealmFavouriteMovie.self).map { IntermediateFavouriteMovie(realmMovie: $0) }
                onSuccess(Array(movies))
                
            } catch {
                onError(error)
            }
        }
    }

    @objc
    public func removeFavouriteMovie(byID movieID: Int, onSuccess: @escaping ([IntermediateFavouriteMovie]) -> Void, onError: @escaping (Error) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let realm = try Realm()
                
                try realm.write {
                    if let movie = realm.object(ofType: RealmFavouriteMovie.self, forPrimaryKey: movieID) {
                        realm.delete(movie)
                    }
                }
                
                let movies = realm.objects(RealmFavouriteMovie.self).map { IntermediateFavouriteMovie(realmMovie: $0) }
                onSuccess(Array(movies))
                
            } catch {
                onError(error)
            }
        }
    }
    
    @objc
    public func removeAllFavouriteMovies(onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let realm = try Realm()
                let allMovies = realm.objects(RealmFavouriteMovie.self)
                try realm.write {
                    realm.delete(allMovies)
                }
                onSuccess()
            } catch {
                onError(error)
            }
        }
    }
    
    @objc
    public func fetchAllFavouriteMoviesAsList() -> [IntermediateFavouriteMovie] {
        do {
            let realm = try Realm()
            let movies = realm.objects(RealmFavouriteMovie.self).map { IntermediateFavouriteMovie(realmMovie: $0) }
            return Array(movies)
        } catch {
            return []
        }
    }
}
