//
//  MovieListStatusHelper.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 22.07.2024.
//

import Foundation

@objc public class NetworkStatusHelper: NSObject {
    @objc public static func createSuccess() -> NetworkStatus {
        return .success
    }
    @objc public static func createError() -> NetworkStatus {
        return .error
    }
    @objc public static func createLoading() -> NetworkStatus {
        return .loading
    }
}
