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
