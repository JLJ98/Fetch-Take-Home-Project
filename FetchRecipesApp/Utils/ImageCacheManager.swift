//
//  ImageCacheManager.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager() // Singleton instance

    private let memoryCache = NSCache<NSString, UIImage>() // Memory cache
    private let fileManager = FileManager.default // FileManager for disk operations
    private let cacheDirectory: URL // Disk cache directory

    private init() {
        // Define the disk cache directory
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    // Retrieve an image from memory or disk cache
    func getCachedImage(forKey key: String) -> UIImage? {
        // Check in-memory cache first
        if let image = memoryCache.object(forKey: NSString(string: key)) {
            print("Image fetched from memory cache for key: \(key)")
            return image
        }

        // Check disk cache
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            print("Image fetched from disk cache for key: \(key)")
            // Store it back into memory cache
            memoryCache.setObject(image, forKey: NSString(string: key))
            return image
        }

        print("No image found in cache for key: \(key)")
        return nil // Image not found in cache
    }

    // Save an image to memory and disk cache
    func saveImage(_ image: UIImage, forKey key: String) {
        // Save to memory cache
        memoryCache.setObject(image, forKey: NSString(string: key))
        print("Image saved to memory cache for key: \(key)")

        // Save to disk cache
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.jpegData(compressionQuality: 0.8) { // Compress the image for disk storage
            do {
                try data.write(to: fileURL)
                print("Image saved to disk cache for key: \(key)")
            } catch {
                print("Failed to save image to disk: \(error)")
            }
        }
    }

    // Clear memory cache
    func clearMemoryCache() {
        memoryCache.removeAllObjects()
        print("Memory cache cleared.")
    }

    // Clear disk cache
    func clearDiskCache() {
        do {
            let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for fileURL in contents {
                try fileManager.removeItem(at: fileURL)
                print("Removed cached file: \(fileURL.lastPathComponent)")
            }
            print("Disk cache cleared.")
        } catch {
            print("Failed to clear disk cache: \(error)")
        }
    }
}
