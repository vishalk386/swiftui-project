//
//  ImageResultView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 17/05/23.
//

import SwiftUI
import Photos
import PhotosUI
import AVKit
import AVFoundation
import UIKit

struct ImageResultView: View {
    @State private var videos: [VideoModel] = []
    @ObservedObject var imagePickerModel = ImagePickerModel()
    @State private var originalSizeText = ""
    @State private var compressedSizeText = ""
    @State private var originalDimensionText = ""
    @State private var compressionDimensionText = ""
    @State private var imageFromPHAsset: UIImage? // New state variable
    @State private var compressedImage: UIImage? // New state variable
    @State private var isAlertPresented = false
    @State private var isDetailsViewActive = false
    @State private var isCompressionSucceeded = false
    @State private var isVideoCompressionSucceeded = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    //Video Compression
    @State private var originalSizeHidden = true
    @State private var sizeAfterCompressionHidden = true
    @State private var durationHidden = true
    @State private var progressBarHidden = true
    @State private var progressLabelHidden = true
    @State private var progress: Float = 0.0
    @State private var sizeAfterCompression = ""
    @State private var duration = ""
    @State private var progressLabel = ""
    @State private var compressedPath: URL?
    @State private var  compression = VideoCompression()
    @State private var showShareSheet = false
    
    
    @State private var originalVideoURL: URL?
    @State private var compressedVideoURL: URL?
    @State private var isCompareActive = false
    @State private var isCompareImageActive = false
    
    

    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 20)
                if imagePickerModel.isVideoSelected {
                    // Display video view
                    VideoPlayer(player: AVPlayer(url: imagePickerModel.selectedVideoURL!))
                        .aspectRatio(contentMode: .fit)
                } else {
                    if let image = imagePickerModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if let phAsset = imagePickerModel.selectedPHAsset {
                        // Display PHAsset details
                        PHAssetImageView(phAsset: phAsset)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Text("No image selected or PHAsset")
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    if imagePickerModel.selectedImage != nil || imagePickerModel.selectedPHAsset != nil {
                        if isDetailsViewActive {
                            DetailRow(title: "Original Size", value: imagePickerModel.originalAssetSize!)
                            DetailRow(title: "Original Dimension", value: imagePickerModel.originalAssetDimension!)
                            DetailRow(title: "Compressed Size", value: compressedSizeText)
                            DetailRow(title: "Compression Dimension", value: compressionDimensionText)
                        } else {
                            DetailRow(title: "Original Size", value: imagePickerModel.originalAssetSize!)
                            DetailRow(title: "Original Dimension", value: imagePickerModel.originalAssetDimension!)
                        }
                    }
                    else if  imagePickerModel.selectedVideoURL != nil {
                        if isVideoCompressionSucceeded{
                            DetailRow(title: "Original File Size:", value: imagePickerModel.selectedVideoURL!.fileSizeInMB())
                            DetailRow(title: "Video Dimensions:", value: imagePickerModel.originalAssetDimension!)
                            DetailRow(title: "Size after compression:", value: sizeAfterCompression)
                            DetailRow(title: "Duration:", value: "\(duration) Sec" )
                            
                        }else{
                            DetailRow(title: "Original File Size:", value: imagePickerModel.selectedVideoURL!.fileSizeInMB())
                            DetailRow(title: "Video Dimensions:", value: imagePickerModel.originalAssetDimension ?? "0")
                        }
                        DetailRow(title: "", value: progressLabel)
                        ProgressBarView(progress: $progress, hidden: $progressBarHidden)
//                        DetailRow(title: "Original File Size:", value: imagePickerModel.selectedVideoURL!.fileSizeInMB())
//                        DetailRow(title: "Video Dimensions:", value: imagePickerModel.originalAssetDimension!)
//                        DetailRow(title: "Size after compression:", value: sizeAfterCompression)
//                        DetailRow(title: "Duration:", value: "\(duration) Sec" )
//                        DetailRow(title: "", value: progressLabel)
//                        ProgressBarView(progress: $progress, hidden: $progressBarHidden)

                    }
                }
                .padding(10)
                Spacer()
                if isCompressionSucceeded {
                    HStack(spacing: 20) {
//                        Button(action: {
//                            // Handle view button action
//                        }) {
//                            VStack {
//                                Image(systemName: "eye")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 20, height: 20)
//                                    .foregroundColor(.white)
//
//                                Text("View")
//                                    .foregroundColor(.white)
//                            }
//                            .padding()
//                            .background(Color.clear) // Use any desired background color
//                            .cornerRadius(10)
//                        }
                        
                        Button(action: {
                            // Handle button action for Compare
                            
                            isCompareImageActive = true
                        }) {
                            VStack {
                                Image(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                                Text("Compare")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                        }
                        .background(
                            ZStack {
                                if let originalPHAsset = imagePickerModel.selectedPHAsset {
                                    NavigationLink(
                                        destination: CompareImageView(originalImage: nil, originalPHAsset: originalPHAsset, compressedImage: Image(uiImage: compressedImage ?? UIImage())),
                                        isActive: $isCompareImageActive
                                    ) {
                                        EmptyView()
                                    }
                                    .hidden()
                                } else if let originalImage = imagePickerModel.selectedImage {
                                    NavigationLink(
                                        destination: CompareImageView(originalImage: Image(uiImage: originalImage), originalPHAsset: nil, compressedImage: Image(uiImage: compressedImage ?? UIImage())),
                                        isActive: $isCompareImageActive
                                    ) {
                                        EmptyView()
                                    }
                                    .hidden()
                                }
                            }
                        )

                        
                        Button(action: {
                            // Handle button action for Share
                        }) {
                            VStack {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                                Text("Share")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                        }
                        Button(action: {
                            // Handle button action for Delete Image // Delete Original Image
                            deleteImageFromGallery()
                        }) {
                            VStack {
                                Image(systemName: "trash")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                                Text("Delete")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                        }
                        
                        
                    }
                }
                else if  isVideoCompressionSucceeded{
                    HStack(spacing: 20) {
//                        Button(action: {
//                            // Handle view button action
//                        }) {
//                            VStack {
//                                Image(systemName: "play.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 20, height: 20)
//                                    .foregroundColor(.white)
//
//                                Text("Play")
//                                    .foregroundColor(.white)
//                            }
//                            .padding()
//                            .background(Color.clear) // Use any desired background color
//                            .cornerRadius(10)
//                        }
                        
                        Button(action: {
                            // Handle button action for Compare
                            
                            if let originalVideoURL  = imagePickerModel.selectedVideoURL ,  let compressedVideoURL = compressedPath {
                                self.originalVideoURL = originalVideoURL
                                                        self.compressedVideoURL = compressedVideoURL
                                                        self.isCompareActive = true
                            }
                        }) {
                            VStack {
                                Image(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                                Text("Compare")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                        }
                        .background(
                            Group {
                                if let originalVideoURL = originalVideoURL, let compressedVideoURL = compressedVideoURL {
                                    NavigationLink(
                                        destination: CompareVideoView(originalVideoURL: originalVideoURL, compressedVideoURL: compressedVideoURL),
                                        isActive: $isCompareActive
                                    ) {
                                        EmptyView()
                                    }
                                }
                            
                            }
                        )


                        
                        Button(action: {
                            // Handle button action for Share
                            showShareSheet.toggle()
                        }) {
                            VStack {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                                Text("Share")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                        }
                       
                       
                        Button(action: {
                            // Handle button action for Delete Image // Delete Original Image
                            deleteImageFromGallery()
                        }) {
                            VStack {
                                Image(systemName: "trash")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                                Text("Delete")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                        }
                        
                        
                    }
                }
                else {
                    if imagePickerModel.isImageSelected {
                        Button(action: {
                            compressImage()
                        }) {
                            Text("Compress Image")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    else {
                        Button(action: {
                            compressVideo()
                        }) {
                            Text("Compress Video")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                }
                
                Spacer()
                Text("© 2023 AdstringO Software Pvt. Ltd. All rights reserved.")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
            .sheet(isPresented: $showShareSheet) {
                if let videoURL = compressedPath {
                    VideoShareSheet(videoURL: videoURL)
                        .frame(width: 300, height: 400) // Adjust the size of the sheet as needed
                }
            }

            .gradientBackground()
            .alert(isPresented: $isAlertPresented) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
           
            
        }
        .withCommonLogoutButton {
                    // Perform logout action here
                }
        
        .navigationBarBackButtonHidden(false)
    
        .toolbarBackground(
            Color.clear,
            for: .navigationBar)
//        .modifier(CommonNavigationTitleModifier(title: "Compression"))
    }
    

    
    func deleteImageFromGallery() {
        guard let asset = imagePickerModel.selectedPHAsset else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }) { success, error in
            if success {
                // Image deleted successfully
                // Perform any additional actions or updates you need
                print("Image deleted successfully")
            } else if let error = error {
                // Error deleting the image
                print("Error deleting image: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    func compressImage() {
        if let image = imagePickerModel.selectedImage {
            // Compress the selected image
            let compressionQuality: CGFloat = 0.1 // Set your desired compression quality
            
            Compression().imageCompression(image: image, compressionQuality: compressionQuality) { originalImageSizeInfo, compressedImageSizeInfo , compressionSuccess in
                updateCompressionResults(originalImageSizeInfo, compressedImageSizeInfo)
                print(originalImageSizeInfo?.title , "Title8888")
                if compressionSuccess {
                    // Compression succeeded
                    
                    compressedImage = compressedImageSizeInfo?.image
                    alertTitle = "Success"
                    alertMessage = "Image compressed successfully."
                    isAlertPresented = true
                    isDetailsViewActive = true // Activate the details view
                    isCompressionSucceeded = true
                    print(originalImageSizeInfo?.title, "Title")
                } else {
                    // Compression failed
                    alertTitle = "Error"
                    alertMessage = "Image compression failed."
                    isAlertPresented = true
                    isCompressionSucceeded = false
                }
            }
        }else if let asset = imagePickerModel.selectedPHAsset {
            // Compress the selected PHAsset
            let compressionQuality: CGFloat = 0.1 // Set your desired compression quality
            
            Compression().assetCompression(asset: asset, compressionQuality: compressionQuality, showAlert: { title, message in
                alertTitle = title
                alertMessage = message
                isAlertPresented = true
            }) { originalImageSizeInfo, compressedImageSizeInfo, compressionSuccess, originalURL, compressedURL in
                updateCompressionResults(originalImageSizeInfo, compressedImageSizeInfo)
                print(originalImageSizeInfo?.title , "Title8888")
                if compressionSuccess {
                    // Compression succeeded
                    alertTitle = "Success"
                    alertMessage = "Image compressed successfully."
                    isAlertPresented = true
                    isCompressionSucceeded = true
                    isDetailsViewActive = true // Activate the details view
                    compressedImage = compressedImageSizeInfo?.image
                    print(compressedImageSizeInfo?.image, "Image")
                    print(originalImageSizeInfo?.title, "Title")
                    
                } else {
                    // Compression failed
                    //                                    alertTitle = "Error"
                    //                                   alertMessage = "Image compression failed."
                    //                                   isAlertPresented = true
                    isCompressionSucceeded = false
                }
            }
        }else{
            print("Not select Image Or Assets")
        }
    }
    
    func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    
    private func compressVideo() {
        if let videoToCompress = imagePickerModel.selectedVideoURL {
            let currentDate = getCurrentDateString()
            print(currentDate)
            let destinationPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ADS_Compressed_\(currentDate).mp4")
            try? FileManager.default.removeItem(at: destinationPath)
            
            let startingPoint = Date()
            let videoCompressor = VideoCompression()
            
            videoCompressor.compressVideo(
                video: videoToCompress,
                outputURL: destinationPath
            ) { result in
                switch result {
                case .onSuccess(let url):
                    self.compressedPath = url
                    DispatchQueue.main.async {
                        // Update UI based on success
                        self.sizeAfterCompression = "\(url.fileSizeInMB())"
                        self.duration = String(format: "%.2f", startingPoint.timeIntervalSinceNow * -1)
                        isVideoCompressionSucceeded = true
                        print(url, "path")
                        self.saveVideoToAlbum(at: url, videos: &videos)
                    }
                case .onStart:
                    DispatchQueue.main.async {
                        // Update UI at the start of compression
                    }
                case .onFailure(let error):
                    DispatchQueue.main.async {
                        // Update UI based on failure
                        print("---------------------------\(error)")
                    }
                case .onCancelled:
                    print("---------------------------")
                    print("Cancelled")
                    print("---------------------------")
                }
            }
        } else {
            print("Video URL Not Found")
        }
    }





    
    /*
    
    private func compressVideo() {
        if let videoToCompress = imagePickerModel.selectedVideoURL {
            
            let currentDate = getCurrentDateString()
            print(currentDate)
        let destinationPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ADS_Compressed_"+"\(currentDate).mp4")
            try? FileManager.default.removeItem(at: destinationPath)
            
            let startingPoint = Date()
            let videoCompressor = LightCompressor()
            
            compression = videoCompressor.compressVideo(
                videos: [.init(
                    source: videoToCompress,
                    destination: destinationPath,
                    configuration: .init(
                        quality: VideoQuality.very_low,
                        videoBitrateInMbps: 1,
                        disableAudio: false,
                        keepOriginalResolution: false,
                        videoSize: nil
                    )
                )],
                progressQueue: .main,
                progressHandler: { progress in
                    DispatchQueue.main.async {
                        self.progress = Float(progress.fractionCompleted)
                        self.progressLabel = "\(Int(progress.fractionCompleted * 100))%"
                        self.progressLabelHidden = false
                        self.sizeAfterCompressionHidden = true
                        self.durationHidden = true
                    }
                },
                completion: { result in
                    switch result {
                    case .onSuccess(let index, let path):
                        self.compressedPath = path
                        DispatchQueue.main.async {
                            self.sizeAfterCompressionHidden = false
                            self.durationHidden = false
                            self.progressBarHidden = true
                            self.progressLabelHidden = true
                            
                            self.sizeAfterCompression = "\(path.fileSizeInMB())"
                            self.duration = String(format: "%.2f", startingPoint.timeIntervalSinceNow * -1)
                            isVideoCompressionSucceeded = true
                            print(path, "path")
                            self.saveVideoToAlbum(at: path, videos: &videos)
                        }
                    case .onStart:
                        DispatchQueue.main.async {
                            self.progressBarHidden = false
                            self.progressLabelHidden = false
                            self.sizeAfterCompressionHidden = true
                            self.durationHidden = true
                        }
                        
                    case .onFailure(let index, let error):
                        DispatchQueue.main.async {
                            self.progressBarHidden = true
                            self.progressLabelHidden = false
                            self.progressLabel = (error as! CompressionError).title
                        }
                        
                    case .onCancelled:
                        print("---------------------------")
                        print("Cancelled")
                        print("---------------------------")
                        
                    }
                }
            )
        } else {
            print("Video URL Not Found")
        }
    }
    */
    func saveVideoToAlbum(at videoURL: URL, videos: inout [VideoModel]) {
        let albumName = "AdstringO" // Replace with the actual name of your album
        var videosRef = videos
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)

        guard let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            .firstObject else {
                createAlbum(with: albumName, videoURL: videoURL, videos: &videos)
                return
        }

        PHPhotoLibrary.shared().performChanges({
            guard let assetCreationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL) else {
                print("Failed to create asset change request")
                return
            }

            guard let assetPlaceholder = assetCreationRequest.placeholderForCreatedAsset else {
                print("Failed to retrieve asset placeholder")
                return
            }

            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
        }) { success, error in
            if let error = error {
                print("Failed to save video to album: \(error.localizedDescription)")
            } else {
                print("Video saved to album successfully")

                let videoName = videoURL.lastPathComponent
             
                let video = VideoModel(url: videoURL, thumbnailImage: UIImage(named: "logo"), size: "20", name: videoName )
                videosRef.append(video)
            }
        }
    }

    private func createAlbum(with name: String, videoURL: URL, videos: inout [VideoModel]) {
        var albumPlaceholder: PHObjectPlaceholder?
        var videosRef = videos
        PHPhotoLibrary.shared().performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }) { success, error in
            if let error = error {
                print("Failed to create album: \(error.localizedDescription)")
                return
            }

            guard let albumPlaceholder = albumPlaceholder else {
                print("Failed to retrieve album placeholder")
                return
            }

            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
            guard let album = fetchResult.firstObject else {
                print("Failed to fetch newly created album")
                return
            }

            PHPhotoLibrary.shared().performChanges({
                guard let assetCreationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL) else {
                    print("Failed to create asset change request")
                    return
                }

                guard let assetPlaceholder = assetCreationRequest.placeholderForCreatedAsset else {
                    print("Failed to retrieve asset placeholder")
                    return
                }

                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
            }) { success, error in
                if let error = error {
                    print("Failed to save video to album: \(error.localizedDescription)")
                } else {
                    print("Video saved to album successfully")

                    let videoName = videoURL.lastPathComponent
                    print(videoName, "VideoName")
                    let video = VideoModel(url: videoURL, thumbnailImage: UIImage(named: "logo"), size: "20", name: videoName )
                    videosRef.append(video)
                }
            }
        }
    }


    
    
    func deleteAsset(with assetURL: URL) {
        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil)
        guard let asset = fetchResult.firstObject else {
            print("Asset not found")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }) { success, error in
            if success {
                // Asset deleted successfully
                // Perform any additional actions or updates you need
                print("Asset deleted successfully")
            } else if let error = error {
                // Error deleting the asset
                print("Error deleting asset: \(error.localizedDescription)")
            }
        }
    }
    
    
    func deleteImage(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("Image deleted successfully at \(url)")
        } catch {
            print("Error deleting image at \(url): \(error.localizedDescription)")
        }
    }
    
    func updateCompressionResults(_ originalImageSizeInfo: ImageSizeInfo?, _ compressedImageSizeInfo: ImageSizeInfo?) {
        guard let originalSizeInfo = originalImageSizeInfo, let compressedSizeInfo = compressedImageSizeInfo else {
            print("Error retrieving image size information")
            return
        }
        
        imagePickerModel.selectedImage = compressedImageSizeInfo?.image
        originalSizeText = originalSizeInfo.sizeString
        compressedSizeText = compressedSizeInfo.sizeString
        originalDimensionText = originalSizeInfo.dimension
        compressionDimensionText = compressedSizeInfo.dimension
    }
}


struct ImageResultView_Previews: PreviewProvider {
    static var previews: some View {
        ImageResultView()
    }
}


extension View {
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, tintColor: tintColor))
    }
}

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var tintColor: UIColor
    
    init(backgroundColor: UIColor, tintColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = tintColor
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .edgesIgnoringSafeArea(.top)
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
        .onAppear {
            UINavigationBar.appearance().backgroundColor = backgroundColor
            UINavigationBar.appearance().isTranslucent = true
        }
    }
}



struct ProgressBarView: View {
    @Binding var progress: Float
    @Binding var hidden: Bool
    
    var body: some View {
        ProgressBar(progress: progress)
            .frame(height: 10)
            .opacity(hidden ? 0 : 1)
            .foregroundColor(.orange)
    }
}

struct ProgressBar: View {
    var progress: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                Rectangle()
                    .foregroundColor(.orange)
                    .frame(width: geometry.size.width * CGFloat(progress), height: geometry.size.height)
                    .animation(.linear)
            }
        }
    }
}


struct VideoModel: Identifiable {
    let id = UUID()
    let url: URL?
    let thumbnailImage: UIImage?
    let size: String
    let name: String
}
