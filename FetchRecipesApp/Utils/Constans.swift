//
//  Constans.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 11/30/24.
//

import Foundation

struct API {
    static let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/"
    static let recipesEndpoint = "\(baseURL)recipes.json"
    static let malformedEndpoint = "\(baseURL)recipes-malformed.json"
    static let emptyEndpoint = "\(baseURL)recipes-empty.json"
}
