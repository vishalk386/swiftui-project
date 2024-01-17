//
//  PHAssetView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 18/05/23.
//

import SwiftUI
import Photos
import PhotosUI

struct PHAssetImageView: View {
    @ObservedObject private var imageLoader: ImageLoader
    
    init(phAsset: PHAsset) {
        _imageLoader = ObservedObject(wrappedValue: ImageLoader(phAsset: phAsset))
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            // Placeholder or loading indicator
            Text("Loading...")
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private let phAsset: PHAsset
    
    init(phAsset: PHAsset) {
        self.phAsset = phAsset
        loadImage()
    }
    
    private func loadImage() {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        
        // Get the target size from the PHAsset
        let targetSize = CGSize(width: phAsset.pixelWidth, height: phAsset.pixelHeight)
        
        imageManager.requestImage(for: phAsset, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions) { (image, _) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}

