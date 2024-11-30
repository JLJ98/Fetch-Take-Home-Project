//
//  RecipeListView.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 11/30/24.
//
//
import SwiftUI

struct RecipeListView: View {
    @State private var recipes: [Recipe] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading recipes...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .padding(.top, 50)
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRow(recipe: recipe)
                                .padding(.vertical, 8)
                                .background(
                                    Color.white
                                        .cornerRadius(12)
                                        .shadow(radius: 8)
                                )
                                .padding([.leading, .trailing], 15)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Recipes")
                    .refreshable {
                        await fetchRecipes() // Trigger refresh
                    }
                }
            }
        }
        .onAppear {
            Task {
                await fetchRecipes() // Fetch recipes when the view first appears
            }
        }
    }

    // Refactor to async/await
    private func fetchRecipes() async {
        isLoading = true
        do {
            let fetchedRecipes = try await NetworkingManager.shared.fetchRecipes() // Await the async fetch
            self.recipes = fetchedRecipes
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack {
            if let photoURL = recipe.photoURLSmall, let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
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
                    .lineLimit(1) // Ensures title is truncated if too long
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
