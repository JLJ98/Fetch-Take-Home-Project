//
//  RecipeRow.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 11/30/24.
import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    @State private var image: UIImage? = nil
    private let randomBackgroundColor: Color

    // Initialize random background color
    init(recipe: Recipe) {
        self.recipe = recipe
        self.randomBackgroundColor = Color(
            red: .random(in: 0.5...1),
            green: .random(in: 0.5...1),
            blue: .random(in: 0.5...1)
        )
    }

    var body: some View {
        HStack(spacing: 16) {
            if let photoURL = recipe.photoURLSmall, let url = URL(string: photoURL) {
                if let image = image {
                    // Show fetched or cached image
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 2)
                } else {
                    // Show placeholder while image is loading
                    ProgressView()
                        .frame(width: 70, height: 70)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .onAppear {
                            // Fetch image using ImageFetcher
                            ImageFetcher.fetchImage(from: url) { fetchedImage in
                                self.image = fetchedImage
                            }
                        }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 10)
        }
        .padding()
        .background(randomBackgroundColor) // Apply random background color
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
