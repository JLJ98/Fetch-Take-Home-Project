//
//  NetworkingManagerTest.swift
//  FetchRecipesAppTests
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import XCTest
@testable import FetchRecipesApp

final class NetworkingManagerTests: XCTestCase {

    // Mock NetworkingManager that returns predefined data or errors
    class MockNetworkingManager: NetworkingManager {
        var mockData: Data?
        var mockError: Error?

        // Use the public initializer
        override init() {
            super.init()
        }

        override func fetchRecipes() async throws -> [Recipe] {
            if let error = mockError {
                throw error
            }
            guard let data = mockData else {
                throw NetworkError.noData
            }
            let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decodedResponse.recipes
        }
    }

    // Test successful fetch of recipes
    func testFetchRecipesSuccess() async throws {
        // Arrange: Set up a mock successful response
        let mockResponseData = """
        {
            "recipes": [
                {
                    "uuid": "1",
                    "name": "Test Recipe",
                    "cuisine": "Italian",
                    "photo_url_small": "https://example.com/small.jpg",
                    "photo_url_large": "https://example.com/large.jpg",
                    "source_url": "https://example.com",
                    "youtube_url": "https://youtube.com"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockNetworkingManager = MockNetworkingManager()
        mockNetworkingManager.mockData = mockResponseData // Provide the mock data

        // Act: Call the method to fetch recipes
        do {
            let result = try await mockNetworkingManager.fetchRecipes()

            // Assert: Check that the result is not nil and matches the expected data
            XCTAssertNotNil(result)
            XCTAssertEqual(result.count, 1) // Should have one recipe in mock data
            XCTAssertEqual(result.first?.name, "Test Recipe")
            XCTAssertEqual(result.first?.cuisine, "Italian")
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }

    // Test failure when URL is invalid
    func testFetchRecipesFailure() async throws {
        // Arrange: Simulate a failure case by using a mock error (e.g., invalid URL)
        let mockNetworkingManager = MockNetworkingManager()
        mockNetworkingManager.mockError = NetworkError.invalidURL // Simulate failure with invalid URL

        // Act & Assert: Try to fetch recipes and expect an error
        do {
            let _ = try await mockNetworkingManager.fetchRecipes()
            XCTFail("Expected failure but got success.")
        } catch let error as NetworkError {
            // Assert: Ensure the error is of the expected type
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // Test failure when no data is returned
    func testFetchRecipesNoData() async throws {
        // Arrange: Simulate no data returned
        let mockNetworkingManager = MockNetworkingManager()
        mockNetworkingManager.mockData = nil // No data to return

        // Act & Assert: Expect failure due to no data
        do {
            let _ = try await mockNetworkingManager.fetchRecipes()
            XCTFail("Expected failure but got success.")
        } catch let error as NetworkError {
            // Assert: Ensure the error is due to no data
            XCTAssertEqual(error, .noData)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
