import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case emptyData
    case malformedData
    case unknownError
}

class NetworkingManager {
    static let shared = NetworkingManager()

    public init() {}

    func fetchRecipes() async throws -> [Recipe] {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json" // Change to test different endpoints

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.serverError("Invalid HTTP response")
            }

            guard !data.isEmpty else {
                throw NetworkError.emptyData // Handle empty response
            }

            do {
                // Decode the data
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                if decodedResponse.recipes.isEmpty {
                    throw NetworkError.emptyData
                }
                return decodedResponse.recipes
            } catch DecodingError.dataCorrupted {
                throw NetworkError.malformedData // Handle malformed data
            } catch {
                throw NetworkError.decodingError // Handle other decoding errors
            }
        } catch let urlError as URLError {
            throw NetworkError.serverError("Network error: \(urlError.localizedDescription)")
        } catch {
            throw NetworkError.unknownError
        }
    }
}
