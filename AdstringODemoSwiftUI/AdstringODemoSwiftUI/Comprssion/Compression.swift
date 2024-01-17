//
//  Compression.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 17/05/23.
//

import Foundation
import UIKit
import Photos
import PhotosUI


struct Compression {

//    func assetCompression(asset: PHAsset, compressionQuality: CGFloat, completion: @escaping (ImageSizeInfo?, ImageSizeInfo?, Bool, URL?, URL?) -> Void) {
//        // ... existing code ...
//        var originalAssetURL: URL?
//        var compressedAssetURL: URL?
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = true
//        
//        guard let album = getAlbum(withName: "AdstringOSoftware") else {
//            print("Error: album not found or couldn't be created")
//            completion(nil, nil, false, nil, nil)
//            return
//        }
//        
//        getAssetURL(asset: asset) { originalURL in
//            originalAssetURL = originalURL
//        }
//        requestOptions.deliveryMode = .highQualityFormat
//        var originalImageSizeInfo: ImageSizeInfo?
//        var compressedImageSizeInfo: ImageSizeInfo?
//        var compressionSuccess = false
//        
//        PHImageManager.default().requestImageData(for: asset, options: requestOptions) { [self] (data, uti, orientation, info) in
//            guard let data = data else {
//                completion(nil, nil, false, nil, nil)
//                return
//            }
//            
//            let originalSize = Double(data.count)
//            let options = PHAssetResourceCreationOptions()
//            let assetResources = PHAssetResource.assetResources(for: asset).first
//            let originalFilename = assetResources?.originalFilename ?? ""
//            
//            if originalFilename.contains("_compressed") {
//                options.originalFilename = originalFilename
//                options.uniformTypeIdentifier = assetResources?.uniformTypeIdentifier
//                originalImageSizeInfo = getImageSizeInfo(from: data)
//                showAlert(title: "Warning", message: "The image is already compressed. Please choose another higher quality image.")
//                completion(originalImageSizeInfo, compressedImageSizeInfo, compressionSuccess,nil,nil)
//            } else {
//                let watermarkedImage = drawText("AstringO", in: UIImage(data: data), textcolor: UIColor.red, at: CGPoint(x: 25, y: 25))
//                let compressedData = watermarkedImage?.jpegData(compressionQuality: compressionQuality)
//                let compressedSize = Double(compressedData?.count ?? 0)
//                compressedImageSizeInfo = getImageSizeInfo(from: compressedData!)
//                originalImageSizeInfo = getImageSizeInfo(from: data)
//                
//                if compressedSize >= originalSize {
//                    showAlert(title: "Warning", message: "The compressed image size is larger than the original size. Please choose a higher compression quality.")
//                    completion(originalImageSizeInfo, compressedImageSizeInfo, compressionSuccess,nil,nil)
//                } else {
//                    saveImageToAlbum1(album, compressedData!) { result in
//                        switch result {
//                        case .success(let url):
//                            print("Saved image to album: \(url)")
//                            compressionSuccess = true
//                            compressedAssetURL = url
//                        case .failure(let error):
//                            print("Error saving image: \(error.localizedDescription)")
//                            compressionSuccess = false
//                        }
//                        
//                        print(compressionSuccess, "compressionSuccess")
//                        completion(originalImageSizeInfo, compressedImageSizeInfo, compressionSuccess,originalAssetURL,compressedAssetURL)
//                    }
//                }
//            }
//        }
//    }

    
    
    
    
    func assetCompression(asset: PHAsset, compressionQuality: CGFloat, showAlert: @escaping (String, String) -> Void, completion: @escaping (ImageSizeInfo?, ImageSizeInfo?, Bool, URL?, URL?) -> Void) {
        // ... existing code ...
        var originalAssetURL: URL?
        var compressedAssetURL: URL?
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        guard let album = getAlbum(withName: "AdstringOSoftware") else {
            print("Error: album not found or couldn't be created")
            completion(nil, nil, false, nil, nil)
            return
        }
        
        getAssetURL(asset: asset) { originalURL in
            originalAssetURL = originalURL
        }
        requestOptions.deliveryMode = .highQualityFormat
        var originalImageSizeInfo: ImageSizeInfo?
        var compressedImageSizeInfo: ImageSizeInfo?
        var compressionSuccess = false
        
        PHImageManager.default().requestImageData(for: asset, options: requestOptions) { [self] (data, uti, orientation, info) in
            guard let data = data else {
                completion(nil, nil, false, nil, nil)
                return
            }
            
            let originalSize = Double(data.count)
            let options = PHAssetResourceCreationOptions()
            let assetResources = PHAssetResource.assetResources(for: asset).first
            let originalFilename = assetResources?.originalFilename ?? ""
            
            if originalFilename.contains("_compressed") {
                options.originalFilename = originalFilename
                options.uniformTypeIdentifier = assetResources?.uniformTypeIdentifier
                originalImageSizeInfo = getImageSizeInfo(from: data)
                showAlert("Warning", "The image is already compressed. Please choose another higher quality image.")
                completion(originalImageSizeInfo, compressedImageSizeInfo, compressionSuccess, nil, nil)
            } else {
                let watermarkedImage = drawText("AstringO", in: UIImage(data: data), textcolor: UIColor.red, at: CGPoint(x: 25, y: 25))
                let compressedData = watermarkedImage?.jpegData(compressionQuality: compressionQuality)
                let compressedSize = Double(compressedData?.count ?? 0)
                compressedImageSizeInfo = getImageSizeInfo(from: compressedData!)
                originalImageSizeInfo = getImageSizeInfo(from: data)
                
                if compressedSize >= originalSize {
                    showAlert("Warning", "The compressed image size is larger than the original size. Please choose a higher compression quality.")
                    completion(originalImageSizeInfo, compressedImageSizeInfo, compressionSuccess, nil, nil)
                } else {
                    saveImageToAlbum1(album, compressedData!) { result in
                        switch result {
                        case .success(let url):
                            print("Saved image to album: \(url)")
                            compressionSuccess = true
                            compressedAssetURL = url
                        case .failure(let error):
                            print("Error saving image: \(error.localizedDescription)")
                            compressionSuccess = false
                        }
                        
                        print(compressionSuccess, "compressionSuccess")
                        completion(originalImageSizeInfo, compressedImageSizeInfo, compressionSuccess, originalAssetURL, compressedAssetURL)
                    }
                }
            }
        }
    }



    
    //MARK: - Image Compression
    func imageCompression(image: UIImage, compressionQuality: CGFloat, completion: @escaping (ImageSizeInfo?, ImageSizeInfo?, Bool) -> Void) {
        guard let album = getAlbum(withName: "AdstringOSoftware") else {
            print("Error: album not found or couldn't be created")
            completion(nil, nil, false)
            return
        }
        
        let originalData = image.jpegData(compressionQuality: 1)
        let watermarkedImage = drawText("AstringO", in: UIImage(data: originalData ?? Data()), textcolor: UIColor.red, at: CGPoint(x: 25, y: 25))
        let compressedData = watermarkedImage?.jpegData(compressionQuality: compressionQuality) // Compress the image with the specified compression quality
        
        var originalImageSizeInfo: ImageSizeInfo?
        var compressedImageSizeInfo: ImageSizeInfo?
        
        let compressedSize = Double(compressedData?.count ?? 0)
        let originalSize = Double(originalData?.count ?? 0)
        
        compressedImageSizeInfo = getImageSizeInfo(from: compressedData ?? Data())
        originalImageSizeInfo = getImageSizeInfo(from: originalData ?? Data())
        
        if compressedSize >= originalSize {
            showAlert(title: "Warning", message: "The compressed image size is larger than the original size. Please choose a higher compression quality.")
            completion(originalImageSizeInfo, compressedImageSizeInfo, false)
        } else {
            saveImageToAlbum2(album, compressedData!) { result in
                switch result {
                case .success(let (url, originalFilename)):
                    print("Saved image to album: \(url) \(originalFilename)")
                    var updatedOriginalImageSizeInfo = originalImageSizeInfo
                    updatedOriginalImageSizeInfo?.title = originalFilename
                    completion(updatedOriginalImageSizeInfo, compressedImageSizeInfo, true)
                case .failure(let error):
                    print("Error saving image: \(error.localizedDescription)")
                    completion(originalImageSizeInfo, compressedImageSizeInfo, false)
                }
            }
        }
    }


    
  
    
    func saveImageToAlbum(_ album: PHAssetCollection, _ compressedData: Data) {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: Date())
        let randomNumber = Int.random(in: 1...1000)
        let originalFilename = "IMG_compressed_\(dateString)_\(randomNumber).jpeg"
        
        let options = PHAssetResourceCreationOptions()
        options.originalFilename = originalFilename
//        options.uniformTypeIdentifier = "public.jpeg"
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: compressedData, options: options)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            let assetPlaceholder = request.placeholderForCreatedAsset
            albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
        }, completionHandler: { success, error in
            if let error = error {
                print("Error saving image: \(error.localizedDescription)")
                return
            }
            if success {
                print("Image saved successfully")
                self.showAlert(title: "Success", message: "Image saved successfully")
            } else {
                print("Error saving image")
            }
        })
    }
    
    
    
    
    func saveImageToAlbum2(_ album: PHAssetCollection, _ compressedData: Data, completion: @escaping (Result<(URL, String), Error>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: Date())
        let randomNumber = Int.random(in: 1...1000)
        let originalFilename = "IMG_compressed_\(dateString)_\(randomNumber).jpeg"
        
        let options = PHAssetResourceCreationOptions()
        options.originalFilename = originalFilename
        
        var assetPlaceholder: PHObjectPlaceholder?
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: compressedData, options: options)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            assetPlaceholder = request.placeholderForCreatedAsset
            albumChangeRequest?.addAssets([assetPlaceholder!] as NSFastEnumeration)
        }, completionHandler: { success, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if success, let localIdentifier = assetPlaceholder?.localIdentifier,
               let asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil).firstObject {
                print(asset.localIdentifier)
                
                let assetResources = PHAssetResource.assetResources(for: asset)
                if let originalFilename = assetResources.first?.originalFilename {
                    print(originalFilename, "originalFilename")
                    self.getAssetURL(asset: asset) { url in
                        if let url = url {
                            print("Asset URL: \(url.absoluteString)")
                            completion(.success((url, originalFilename)))
                        } else {
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error getting asset URL"])
                            completion(.failure(error))
                        }
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error retrieving original filename"])
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error saving image"])
                completion(.failure(error))
            }
        })
    }

    
    func saveImageToAlbum1(_ album: PHAssetCollection, _ compressedData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: Date())
        let randomNumber = Int.random(in: 1...1000)
        let originalFilename = "IMG_compressed_\(dateString)_\(randomNumber).jpeg"
        
        let options = PHAssetResourceCreationOptions()
        options.originalFilename = originalFilename
        
        var assetPlaceholder: PHObjectPlaceholder?
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: compressedData, options: options)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            assetPlaceholder = request.placeholderForCreatedAsset
            albumChangeRequest?.addAssets([assetPlaceholder!] as NSFastEnumeration)
        }, completionHandler: { success, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if success, let localIdentifier = assetPlaceholder?.localIdentifier,
               let asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil).firstObject {
                print(asset.localIdentifier)
                
                let assetResources = PHAssetResource.assetResources(for: asset)
                           if let originalFilename = assetResources.first?.originalFilename {
                              print(originalFilename, "originalFilename")
                           }
                self.getAssetURL(asset: asset) { url in
                    if let url = url {
                        print("Asset URL: \(url.absoluteString)")
                        completion(.success(url))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error getting asset URL"])
                        completion(.failure(error))
                    }
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error saving image"])
                completion(.failure(error))
            }
        })
    }

    //MARK: - Get IMAGE asset URL
    func getAssetURL(asset: PHAsset, completion: @escaping (URL?) -> Void) {
        let options = PHContentEditingInputRequestOptions()
        asset.requestContentEditingInput(with: options) { (contentEditingInput, _) in
            guard let fullSizeImageUrl = contentEditingInput?.fullSizeImageURL else {
                completion(nil)
                return
            }
            completion(fullSizeImageUrl)
        }
    }

    // MARK: - watermark for image
    func drawText(_ text: String?, in image: UIImage?,textcolor:UIColor?, at point: CGPoint) -> UIImage? {
                let font = UIFont(name: "Helvetica Bold", size: 40)
                let textcolor = UIColor.red
                UIGraphicsBeginImageContext((image?.size)!)
                image?.draw(in: CGRect(x: 0, y: 0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0))
                let rect = CGRect(x: image!.size.width / 2, y: image!.size.height - 80, width: image!.size.width / 2, height: image!.size.height / 2)
        
                if let aFont = font {
                    text?.draw(in: rect.integral, withAttributes: [NSAttributedString.Key.font : aFont,NSAttributedString.Key.foregroundColor: textcolor])
                }
                //[text drawInRect:CGRectIntegral(rect) withAttributes:@{NSFontAttributeName:font}];
                let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return newImage
            }

    func getAlbum(withName: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", withName)
        var album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions).firstObject
        
        if album != nil {
            return album
        }
        
        // If album doesn't exist, create a new one
        var albumPlaceholder: PHObjectPlaceholder?
        
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: withName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
            }
            
            album = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder!.localIdentifier], options: nil).firstObject
            return album
            
        } catch {
            print("Error creating album: \(error.localizedDescription)")
            return nil
        }
    }


    func getImageSizeInfo(from data: Data) -> ImageSizeInfo? {
        let originalSize = Double(data.count)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        if originalSize < 1000 {
           
            let sizeString = "\(Int(originalSize)) bytes"
            return ImageSizeInfo(image: image, sizeString: sizeString, dimension: "\(Int(image.size.width))*\(Int(image.size.height))", title: "")
        } else if originalSize < 1000000 {
            let kilobytes = originalSize / 1000.0
            let sizeString = numberFormatter.string(from: NSNumber(value: kilobytes)) ?? ""
            
            return ImageSizeInfo(image: image, sizeString: "\(sizeString) KB", dimension: "\(Int(image.size.width))*\(Int(image.size.height))", title: "")
        } else {
            let megabytes = originalSize / 1000000.0
            let sizeString = numberFormatter.string(from: NSNumber(value: megabytes)) ?? ""
    
            return ImageSizeInfo(image: image, sizeString: "\(sizeString) MB", dimension: "\(Int(image.size.width))*\(Int(image.size.height))", title: "")
        }
    }



    //MARK: - SHOW ALERT
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first,
                  let rootViewController = window.rootViewController
            else {
                completion?()
                return
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            })
            
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
    /*
    
    //MARK: - Image Compression
    func imageCompression(image: UIImage, compressionQuality: CGFloat, completion: @escaping (ImageSizeInfo?, ImageSizeInfo?) -> Void) {
        guard let album = getAlbum(withName: "AdstringOSoftware") else {
            print("Error: album not found or couldn't be created")
            completion(nil, nil)
            return
        }
        
        let originalData = image.jpegData(compressionQuality: 1)
        let watermarkedImage = drawText("AstringO", in: UIImage(data: originalData ?? Data()), textcolor: UIColor.red, at: CGPoint(x: 25, y: 25))
        let compressedData = watermarkedImage?.jpegData(compressionQuality: compressionQuality) // Compress the image with the specified compression quality
        
        var originalImageSizeInfo: ImageSizeInfo?
        var compressedImageSizeInfo: ImageSizeInfo?
        
        let compressedSize = Double(compressedData?.count ?? 0)
        let originalSize = Double(originalData?.count ?? 0)
        
        compressedImageSizeInfo = getImageSizeInfo(from: compressedData ?? Data())
        originalImageSizeInfo = getImageSizeInfo(from: originalData ?? Data())
        
        if compressedSize >= originalSize {
            showAlert(title: "Warning", message: "The compressed image size is larger than the original size. Please choose a higher compression quality.")
        } else {
            saveImageToAlbum1(album, compressedData!) { result in
                switch result {
                case .success(let url):
                    print("Saved image to album: \(url)")
                    // Do something with the local file URL
                case .failure(let error):
                    print("Error saving image: \(error.localizedDescription)")
                }
            }
        }
        
        completion(originalImageSizeInfo, compressedImageSizeInfo)
    }
    
    
    
      func assetCompression(asset: PHAsset, compressionQuality: CGFloat, completion: @escaping (ImageSizeInfo?, ImageSizeInfo?) -> Void) {
          let requestOptions = PHImageRequestOptions()
          requestOptions.isSynchronous = true
          
          guard let album = getAlbum(withName: "AdstringOSoftware") else {
              print("Error: album not found or couldn't be created")
              completion(nil, nil)
              return
          }
          
          requestOptions.deliveryMode = .highQualityFormat
          var originalImageSizeInfo: ImageSizeInfo?
          var compressedImageSizeInfo: ImageSizeInfo?
          
          PHImageManager.default().requestImageData(for: asset, options: requestOptions) { [self] (data, uti, orientation, info) in
              guard let data = data else {
                  completion(nil, nil)
                  return
              }
              
              let originalSize = Double(data.count)
              let options = PHAssetResourceCreationOptions()
              let assetResources = PHAssetResource.assetResources(for: asset).first
              let originalFilename = assetResources?.originalFilename ?? ""
              
              if originalFilename.contains("_compressed") {
                  options.originalFilename = originalFilename
                  options.uniformTypeIdentifier = assetResources?.uniformTypeIdentifier
                  originalImageSizeInfo = getImageSizeInfo(from: data)
                  showAlert(title: "Warning", message: "The image is already compressed. Please choose another higher quality image.")
              } else {
                  let watermarkedImage = drawText("AstringO", in: UIImage(data: data), textcolor: UIColor.red, at: CGPoint(x: 25, y: 25))
                  let compressedData = watermarkedImage?.jpegData(compressionQuality: compressionQuality)
                  let compressedSize = Double(compressedData?.count ?? 0)
                  compressedImageSizeInfo = getImageSizeInfo(from: compressedData!)
                  originalImageSizeInfo = getImageSizeInfo(from: data)
                  
                  if compressedSize >= originalSize {
                      showAlert(title: "Warning", message: "The compressed image size is larger than the original size. Please choose a higher compression quality.")
                  } else {
                      saveImageToAlbum1(album, compressedData!) { result in
                          switch result {
                          case .success(let url):
                              print("Saved image to album: \(url)")
                              // Do something with the local file URL
                          case .failure(let error):
                              print("Error saving image: \(error.localizedDescription)")
                          }
                      }
                  }
              }
              
              completion(originalImageSizeInfo, compressedImageSizeInfo)
          }
      }
      */


}

