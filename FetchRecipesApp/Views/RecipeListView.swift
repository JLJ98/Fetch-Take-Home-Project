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
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 50)
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if recipes.isEmpty {
                    Text("No recipes available.")
                        .font(.headline)
                        .padding()
                } else {
                    List(recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRow(recipe: recipe)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Recipes")
                    .refreshable {
                        await fetchRecipes()
                    }
                }
            }
            .onAppear {
                Task {
                    await fetchRecipes()
                }
            }
        }
    }

    
    private func fetchRecipes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedRecipes = try await NetworkingManager.shared.fetchRecipes()
            recipes = fetchedRecipes
        } catch NetworkError.emptyData {
            errorMessage = "No recipes are available at this time."
        } catch NetworkError.malformedData {
            errorMessage = "The recipe data is malformed and cannot be displayed."
        } catch NetworkError.invalidURL {
            errorMessage = "The URL is invalid."
        } catch NetworkError.serverError(let message) {
            errorMessage = "Server error: \(message)"
        } catch {
            errorMessage = "An unknown error occurred."
        }
        
        isLoading = false
    }
}
