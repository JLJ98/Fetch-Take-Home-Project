//
//  RecipeListView.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 11/30/24.
//
//
//
//  RecipeListView.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 11/30/24.
//

import SwiftUI

struct RecipeListView: View {
    @State private var recipes: [Recipe] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                // Show progress indicator if loading
                if isLoading {
                    ProgressView("Loading recipes...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .padding(.top, 50)
                        .accessibilityIdentifier("loadingIndicator") // Add an identifier for testing
                        .accessibilityLabel("Loading recipes...") // Optional: for better accessibility
                }
                // Show error message if there's an error
                else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .accessibilityIdentifier("errorMessage") // Accessibility identifier for the error message
                }
                // Show the recipe list or empty state
                else if recipes.isEmpty {
                    Text("No recipes available.")
                        .font(.headline)
                        .padding()
                        .accessibilityIdentifier("noRecipesMessage")  // Accessibility identifier for empty state
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
                                .accessibilityIdentifier("recipeRow") // Identifier for recipe row
                                .accessibilityLabel(recipe.name) // Optional: better accessibility
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
    
    private func fetchRecipes() async {
        isLoading = true
        do {
            let fetchedRecipes = try await NetworkingManager.shared.fetchRecipes()
            self.recipes = fetchedRecipes
        } catch NetworkError.invalidURL {
            self.errorMessage = "Invalid URL. Please try again later."
        } catch NetworkError.noData {
            self.errorMessage = "No data found. Please check your connection."
        } catch NetworkError.decodingError {
            self.errorMessage = "Failed to decode the recipe data."
        } catch NetworkError.serverError(let message) {
            self.errorMessage = "Server error: \(message)"
        } catch {
            self.errorMessage = "An unknown error occurred."
        }
        isLoading = false
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
