import Foundation


enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError // Added a decoding error case for better error handling
}

class NetworkingManager {
    static let shared = NetworkingManager()

    private init() {}

    // Refactored fetchRecipes to use async/await
    func fetchRecipes() async throws -> [Recipe] {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        // Perform the network request asynchronously
        let (data, _) = try await URLSession.shared.data(from: url)

        // Decode the response into RecipeResponse
        do {
            let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decodedResponse.recipes
        } catch {
            throw NetworkError.decodingError
        }
    }
}

