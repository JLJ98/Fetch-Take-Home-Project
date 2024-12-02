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
            // Recipe image
            if let photoURL = recipe.photoURLSmall, let url = URL(string: photoURL) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 2)
                } else {
                    ProgressView()
                        .frame(width: 70, height: 70)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .onAppear {
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

            // Recipe details
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .fontWeight(.bold) // Make the text bold
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.black.opacity(0.7)) // Add a semi-transparent background
                    .cornerRadius(5)
                    .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 1) // Add a text shadow for extra visibility

                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
            }
            .padding(.leading, 10)
        }
        .padding()
        .background(randomBackgroundColor) // Random background color
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
