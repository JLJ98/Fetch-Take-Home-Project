//
//  ImageToUIImageView.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 12/1/24.
//

import SwiftUI
import UIKit

// A UIViewRepresentable to convert a SwiftUI Image to UIImage
struct ImageToUIImageView: UIViewRepresentable {
    let image: Image
    var targetSize: CGSize = CGSize(width: 300, height: 300)  // Adjust size as needed

    func makeUIView(context: Context) -> UIImageView {
        return UIImageView()
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        let controller = UIHostingController(rootView: image)
        let view = controller.view
        view?.frame = CGRect(origin: .zero, size: targetSize)

        // Render the SwiftUI Image to UIImage
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let uiImage = renderer.image { _ in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: targetSize), afterScreenUpdates: true)
        }

        uiView.image = uiImage  // Set the converted UIImage
    }
    
    // Convert to UIImage directly from the view
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: image)
        let view = controller.view
        view?.frame = CGRect(origin: .zero, size: targetSize)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: targetSize), afterScreenUpdates: true)
        }
    }
}
