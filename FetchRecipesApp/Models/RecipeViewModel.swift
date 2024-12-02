//
//  RecipeViewModel.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let networkingManager: NetworkingManager

    init(networkingManager: NetworkingManager = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }

    func fetchRecipes() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedRecipes = try await networkingManager.fetchRecipes()
            DispatchQueue.main.async {
                self.recipes = fetchedRecipes
                self.isLoading = false
            }
        } catch let error as NetworkError {
            DispatchQueue.main.async {
                self.errorMessage = self.mapError(error)
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "An unknown error occurred."
                self.isLoading = false
            }
        }
    }

    private func mapError(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "The URL is invalid. Please try again later."
        case .noData:
            return "No data was returned from the server."
        case .decodingError:
            return "There was an issue processing the recipe data."
        case .serverError(let message):
            return message
        case .emptyData:
            return "No recipes available."
        case .malformedData:
            return "The data returned was malformed."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
