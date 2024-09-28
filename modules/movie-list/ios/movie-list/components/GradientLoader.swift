//
//  GradientLoader.swift
//  react-native-movie-list
//
//  Created by Nikita Tikhonov on 03.09.2024.
//

import SwiftUI

struct GradientLoader: View {
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ZStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.red, .orange, .yellow, .green, .cyan, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask(ProgressView())
                    )
            }
            Spacer()
        }
    }
}
