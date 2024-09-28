//
//  MovieItem.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 06.07.2024.
//

import Foundation
import SwiftUI


struct MovieItem: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: movie.url)) {
                image in image.image?.resizable()
            }
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(movie.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    
                    MovieRating(rating: movie.rating)
                }
                
                Text(movie.movieDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding()
        .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
    }
}

