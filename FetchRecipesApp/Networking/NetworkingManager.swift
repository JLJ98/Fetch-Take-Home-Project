import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unknownError
}

class NetworkingManager {
    static let shared = NetworkingManager()
    
    // Public initializer for testing purposes
        public init() {}

    // Fetch recipes using async/await and improved error handling
    func fetchRecipes() async throws -> [Recipe] {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        
        // Check if the URL is valid
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        do {
            // Perform the network request asynchronously
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check the HTTP response status
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError("Invalid response from the server")
            }

            // Check for successful HTTP status code (200 OK)
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.serverError("Server returned error: HTTP \(httpResponse.statusCode)")
            }

            // If there is data, decode it into the model
            if !data.isEmpty {
                do {
                    let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                    return decodedResponse.recipes
                } catch {
                    throw NetworkError.decodingError // Handle decoding errors
                }
            } else {
                throw NetworkError.noData // Handle empty data
            }
        } catch {
            // Handle network failure or unexpected errors
            if let urlError = error as? URLError {
                throw NetworkError.serverError("Network error: \(urlError.localizedDescription)")
            } else {
                throw NetworkError.unknownError // Generic unknown error
            }
        }
    }
}

