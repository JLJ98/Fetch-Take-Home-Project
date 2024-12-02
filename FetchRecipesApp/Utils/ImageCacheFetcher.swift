//
//  ImageCacheFetcher.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import UIKit

class ImageFetcher {
    static func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Use a unique cache key derived from the full URL
        let cacheKey = String(url.absoluteString.hashValue)

        // Check cache first
        if let cachedImage = ImageCacheManager.shared.getCachedImage(forKey: cacheKey) {
            print("Fetched image from cache for key: \(cacheKey)")
            completion(cachedImage)
            return
        }

        // Download image if not cached
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                // Save to cache
                ImageCacheManager.shared.saveImage(image, forKey: cacheKey)
                print("Saved image to cache for key: \(cacheKey)")
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("Image fetch error: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
