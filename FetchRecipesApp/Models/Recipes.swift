//
//  Recipes.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 11/30/24.
//
import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let id: String // Matches "uuid" from the JSON
    let name: String
    let cuisine: String
    let photoURLSmall: String?
    let photoURLLarge: String?
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
