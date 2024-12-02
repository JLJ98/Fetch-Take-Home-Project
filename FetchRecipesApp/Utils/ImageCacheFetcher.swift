//
//  ImageCacheFetcher.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import UIKit

class ImageFetcher {
    static func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.lastPathComponent

        // Check cache first
        if let cachedImage = ImageCacheManager.shared.getCachedImage(forKey: cacheKey) {
            print("Fetched image from cache for key: \(cacheKey)")
            completion(cachedImage)
            return
        }

        print("Fetching image from URL: \(url)") // Log the fetch attempt

        // Download image if not cached
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                print("Saving image to cache for key: \(cacheKey)") // Log the caching
                // Save to cache
                ImageCacheManager.shared.saveImage(image, forKey: cacheKey)
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
