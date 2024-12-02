//
//  RecipeViewModelTest.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

//
//  RecipeViewModelTest.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import XCTest
@testable import FetchRecipesApp

final class RecipeViewModelTest: XCTestCase {
    // Mock Networking Manager
    class MockNetworkingManager: NetworkingManager {
        var mockRecipes: [Recipe]?
        var mockError: NetworkError?

        override func fetchRecipes() async throws -> [Recipe] {
            if let error = mockError {
                throw error
            }
            if let recipes = mockRecipes {
                return recipes
            }
            throw NetworkError.noData
        }
    }

    // Test for Successful Recipe Fetching
    func testFetchRecipesSuccess() async {
        // Arrange
        let mockManager = MockNetworkingManager()
        mockManager.mockRecipes = [
            Recipe(id: "1", name: "Test Recipe", cuisine: "Italian", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let viewModel = RecipeViewModel(networkingManager: mockManager)
        let expectation = XCTestExpectation(description: "Fetch recipes successfully")

        // Act
        Task {
            await viewModel.fetchRecipes()
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

        // Assert
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.name, "Test Recipe")
        XCTAssertEqual(viewModel.recipes.first?.cuisine, "Italian")
    }

    // Test for Failure During Recipe Fetching
    func testFetchRecipesFailure() async {
        // Arrange
        let mockManager = MockNetworkingManager()
        mockManager.mockError = .invalidURL
        let viewModel = RecipeViewModel(networkingManager: mockManager)
        let expectation = XCTestExpectation(description: "Handle recipe fetch failure")

        // Act
        Task {
            await viewModel.fetchRecipes()
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

        // Assert
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "The URL is invalid. Please try again later.")
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
}
