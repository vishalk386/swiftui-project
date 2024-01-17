//
//  VImagePickerView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 18/05/23.
//

import SwiftUI
import UIKit
import Photos
import MobileCoreServices

struct VUImagePickerView: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @ObservedObject var imagePickerModel: ImagePickerModel
    @Binding var shouldPresentVideoPicker: Bool
    @Binding var shouldPresentImagePicker: Bool

    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(imagePickerModel: _imagePickerModel, shouldPresentVideoPicker: $shouldPresentVideoPicker, shouldPresentImagePicker: $shouldPresentImagePicker)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
           let pickerController = UIImagePickerController()
           pickerController.sourceType = sourceType
           pickerController.delegate = context.coordinator
           
           // Set the initial media type based on the selection
           if shouldPresentVideoPicker {
               pickerController.mediaTypes = ["public.movie"]
               pickerController.videoQuality = UIImagePickerController.QualityType.typeHigh
               pickerController.videoExportPreset = AVAssetExportPresetPassthrough
           } else {
               pickerController.mediaTypes = [kUTTypeImage as String]
           }
           
           return pickerController
       }
       
       func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
           // Update the media type if there is a change in selection
           if shouldPresentVideoPicker {
               uiViewController.mediaTypes = [kUTTypeMovie as String]
           } else {
               uiViewController.mediaTypes = [kUTTypeImage as String]
           }
       }
}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @ObservedObject var imagePickerModel: ImagePickerModel
    @Binding var shouldPresentVideoPicker: Bool
    @Binding var shouldPresentImagePicker: Bool
   

    init(imagePickerModel: ObservedObject<ImagePickerModel>, shouldPresentVideoPicker: Binding<Bool>, shouldPresentImagePicker: Binding<Bool>) {
        self._imagePickerModel = imagePickerModel
        self._shouldPresentVideoPicker = shouldPresentVideoPicker
        self._shouldPresentImagePicker = shouldPresentImagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if shouldPresentVideoPicker {
            if let videoToCompress = info[.mediaURL] as? URL {
                // Handle video selection
                // Perform any necessary operations with the video URL

                imagePickerModel.selectedVideoURL = videoToCompress
                imagePickerModel.isVideoSelected = true
                imagePickerModel.selectedPHAsset = nil
                imagePickerModel.selectedImage = nil

              
             
                let asset = AVAsset(url: videoToCompress)
                           
                           // Get the first video track from the asset
                           guard let videoTrack = asset.tracks(withMediaType: .video).first else {
                               print("No video track found")
                               return
                           }
                           
                           // Get the dimensions of the video track
                           let videoSize = videoTrack.naturalSize
                           let videoWidth = videoSize.width
                           let videoHeight = videoSize.height
                           
                imagePickerModel.originalAssetDimension =  "\(videoWidth) x \(videoHeight)"
            
                    // Now you have the video dimensions (width and height) which you can use as needed

                }

        }
        else {
            if let phAsset = info[.phAsset] as? PHAsset {
                getImageSizeInfo(from: phAsset) { [self] imageSizeInfo in
                    if let imageSizeInfo = imageSizeInfo {
                        imagePickerModel.selectedPHAsset = phAsset
                        imagePickerModel.selectedImage = nil
                        imagePickerModel.isImageSelected = true
                      
                        imagePickerModel.originalAssetSize = imageSizeInfo.sizeString
                        imagePickerModel.originalAssetDimension = imageSizeInfo.dimension
                    }
                }
            } else if let image = info[.originalImage] as? UIImage {
                imagePickerModel.selectedImage = image
                imagePickerModel.selectedPHAsset = nil
                imagePickerModel.isImageSelected = true
               
                imagePickerModel.originalAssetSize = getImageSize(from: image)
                imagePickerModel.originalAssetDimension = getImageDimension(from: image)
            }
        }
        imagePickerModel.isPresented = false
        picker.dismiss(animated: true) // Dismiss the image picker
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerModel.isPresented = false
        picker.dismiss(animated: true)
    }
   private func getImageSizeInfo(from phAsset: PHAsset, completion: @escaping (ImageAssetInfo?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        PHImageManager.default().requestImageData(for: phAsset, options: options) { data, _, _, _ in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            let originalSize = Double(imageData.count)
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            
            if originalSize < 1000 {
                print("image size: \(Int(originalSize)) bytes")
                let sizeString = "\(Int(originalSize)) bytes"
                completion(ImageAssetInfo( sizeString: sizeString, dimension: "\(phAsset.pixelWidth)*\(phAsset.pixelHeight)"))
            } else if originalSize < 1000000 {
                let kilobytes = originalSize / 1000.0
                let sizeString = numberFormatter.string(from: NSNumber(value: kilobytes)) ?? ""
                print("image size: \(sizeString) KB")
                completion(ImageAssetInfo(sizeString: "\(sizeString) KB", dimension: "\(phAsset.pixelWidth)*\(phAsset.pixelHeight)"))
            } else {
                let megabytes = originalSize / 1000000.0
                let sizeString = numberFormatter.string(from: NSNumber(value: megabytes)) ?? ""
                print("image size: \(sizeString) MB")
                completion(ImageAssetInfo(sizeString: "\(sizeString) MB", dimension: "\(phAsset.pixelWidth)*\(phAsset.pixelHeight)"))
            }
        }
    }

    
    
    private func getImageSize(from image: UIImage) -> String {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return ""
        }
        
        let originalSize = Double(data.count)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        if originalSize < 1000 {
            return "\(Int(originalSize)) bytes"
        } else if originalSize < 1000000 {
            let kilobytes = originalSize / 1000.0
            return "\(numberFormatter.string(from: NSNumber(value: kilobytes)) ?? "") KB"
        } else {
            let megabytes = originalSize / 1000000.0
            return "\(numberFormatter.string(from: NSNumber(value: megabytes)) ?? "") MB"
        }
    }

    private func getImageDimension(from image: UIImage) -> String {
        let dimension = "\(Int(image.size.width)) * \(Int(image.size.height))"
        return dimension
    }


}



