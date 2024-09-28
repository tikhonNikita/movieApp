//
//  MovieDetailsView.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 30.07.2024.
//
import SwiftUI
import SwiftUIIntrospect


public struct RoundedBadge: View {
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        HStack {
            Text(text.capitalized)
                .foregroundStyle(.white)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.leading, 10)
                .padding([.top, .bottom], 5)
                .padding(.trailing, 10)
        }
        .background(
            ZStack {
                Color.black
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
        )
        .cornerRadius(8)
        .padding(.bottom, 4)
    }
}

struct TopActionIcon: View {
    var icon: String
    var action: (() -> Void)

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName:icon).foregroundColor(.black)
            }.padding(8).background(.thinMaterial).cornerRadius(15)
        }
    }
}

struct MovieDetailsView: View {
    let movieDetails: MovieDetails
    let onAddToFavourites: (Int) -> Void
    let onRemoveFromFavourites: (Int) -> Void
    let onClose: () -> Void
    
    var body: some View {
            ScrollView {
                ZStack(alignment: .topTrailing) {
                    VStack(
                        alignment: .leading,
                        spacing: 8.0
                    ) {
                        AsyncImage(url: URL(string: movieDetails.posterURL)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.6)
                        }
                        .frame(height: 550)
                        VStack(alignment: .leading) {
                            Text(movieDetails.title.uppercased())
                                .foregroundStyle(.blue)
                                .font(.system(size: 26, weight: .bold, design: .default))
                            HStack {
                                ForEach(movieDetails.genres) { genre in
                                    RoundedBadge(text: genre.name)
                                }
                            }
                            Text(movieDetails.overview)
                                .fontWeight(.medium)
                                .fixedSize(horizontal: false, vertical: true)
                        }.padding()
                    }
                    HStack {
                        TopActionIcon(
                            icon: movieDetails.isFavourite ? "star.fill" : "star",
                            action: movieDetails.isFavourite ? {
                                onRemoveFromFavourites(movieDetails.id)
                            } : {
                                onAddToFavourites(movieDetails.id)
                            })
                        Spacer()
                        TopActionIcon(
                            icon: "xmark",
                            action: onClose)
                    }.padding([.top, .horizontal], 32)
                }
            }.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { scrollView in
                scrollView.bounces = false
            }
            .ignoresSafeArea(edges:[.top])
    }
}
