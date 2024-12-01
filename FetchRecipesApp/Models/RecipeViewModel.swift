//
//  RecipeViewModel.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let networkingManager = NetworkingManager.shared

    // Fetch recipes using async/await
    func fetchRecipes() async {
        isLoading = true
        errorMessage = nil  // Clear any previous error message

        do {
            let fetchedRecipes = try await networkingManager.fetchRecipes()
            self.recipes = fetchedRecipes
        } catch let error as NetworkError {
            // Handle specific NetworkError cases with user-friendly messages
            switch error {
            case .invalidURL:
                self.errorMessage = "The URL is invalid. Please try again later."
            case .noData:
                self.errorMessage = "No data was returned from the server."
            case .decodingError:
                self.errorMessage = "There was an issue processing the recipe data."
            case .serverError(let message):
                self.errorMessage = message
            case .unknownError:
                self.errorMessage = "An unknown error occurred. Please try again later."
            }
        } catch {
            self.errorMessage = "Unexpected error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
