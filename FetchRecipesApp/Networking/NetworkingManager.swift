import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String) // For HTTP error responses
    case unknownError
}

class NetworkingManager {
    static let shared = NetworkingManager()

    private init() {}

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
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.serverError("Server returned an error")
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
            throw NetworkError.unknownError
        }
    }
}

