//
//  MovieRating.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 06.07.2024.
//

import Foundation
import SwiftUI

struct MovieRating: View {
    var rating: Double

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(0..<5) { index in
                if index < Int(rating / 2) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                } else if index < Int(ceil(rating / 2)) && rating.truncatingRemainder(dividingBy: 2) >= 0.5 {
                    Image(systemName: "star.leadinghalf.filled")
                        .foregroundStyle(.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundStyle(.yellow)
                }
            }
        }
    }
}
