//
//  ImageCacheManager.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        // Define cache directory
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    // Retrieve an image from memory or disk cache
    func getCachedImage(forKey key: String) -> UIImage? {
        // Check in-memory cache first
        if let image = memoryCache.object(forKey: NSString(string: key)) {
            return image
        }

        // Check disk cache
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            // Store it back into memory cache
            memoryCache.setObject(image, forKey: NSString(string: key))
            return image
        }

        return nil // Image not found in cache
    }

    // Save an image to memory and disk cache
    func saveImage(_ image: UIImage, forKey key: String) {
        // Save to memory cache
        memoryCache.setObject(image, forKey: NSString(string: key))

        // Save to disk cache
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("Failed to save image to disk: \(error)")
            }
        }
    }
}
