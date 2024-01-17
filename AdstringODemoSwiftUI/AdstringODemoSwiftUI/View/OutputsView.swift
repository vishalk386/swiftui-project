//
//  OutputsView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 16/05/23.
//

import SwiftUI
/*
struct OutputsView: View {
    @State private var selectedOption = 0
    @State private var compressedItems: [UIImage] = [] // Declare the compressed items array
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer() // Add a spacer to push the picker to the top
                
                Picker(selection: $selectedOption, label: Text("Select Output")) {
                    Text("Video").tag(0)
                    Text("Image").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selectedOption == 0 {
                    VideoListView()
                } else {
                    // Display the Image Output section
                    ScrollView {
                        LazyVStack {
                            ForEach(compressedItems, id: \.self) { item in
                                CustomCellView(image: item, title: "Image Title", compressedSize: "10 MB")
                            }
                        }
                    }
                }
            }
        }
        .withCommonLogoutButton {
                    // Perform logout action here
                }
        
        .onAppear {
            // Update the compressedItems array with the compressed images
            compressedItems = [UIImage(named: "logo")!, UIImage(systemName: "play.fill")!, UIImage(named: "logo")!]
        }
    }
}


   struct VideoListView: View {
       var body: some View {
           // Display your video list here
           Text("Video List")
       }
   }

 */

import SwiftUI
import Photos

struct OutputsView: View {
  
    @State private var selectedTab = 0
    @State private var videos: [VideoModel] = []
    @State private var images: [ImageModel] = []

//    init() {
//        UITabBar.appearance().backgroundColor = .magenta
//        }
    var body: some View {
        TabView(selection: $selectedTab) {
            VideoListView(videos: videos)
                .tabItem {
                    Label("Videos", systemImage: "play.circle")
                }
                .tag(0)
         
            ImageListView(images: images)
                .tabItem {
                    Label("Images", systemImage: "photo.fill")
                }
                .tag(1)
        }
        .onAppear() {
            fetchVideos(fromAlbum: "AdstringO")
            fetchImages(fromAlbum: "AdstringOSoftware")
        }
        .accentColor(Color.red) // Set the selected tab color
        .background(Color.clear)
        .gradientBackground() // Set the background color
    }


    private func fetchVideos(fromAlbum albumName: String) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        fetchResult.enumerateObjects { collection, _, _ in
            if collection.localizedTitle == albumName {
                let albumFetchOptions = PHFetchOptions()
                albumFetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
                albumFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                let albumFetchResult = PHAsset.fetchAssets(in: collection, options: albumFetchOptions)
                
                albumFetchResult.enumerateObjects { asset, _, _ in
                    if asset.mediaType == .video {
                        getVideoURL(from: asset) { videoURL in
                            if let url = videoURL {
                                let videoName = getVideoName(from: asset)
                                let videoSize = url.fileSizeInMB()
                                let videoThumbnailImage = createThumbnailOfVideoFromFileURL(videoURL: url.absoluteString)
                                let video = VideoModel(url: url, thumbnailImage: UIImage(cgImage: videoThumbnailImage ?? UIImage(named: "logo")!.cgImage!), size: videoSize, name: videoName)
                                
                                videos.append(video)
                            }
                        }
                    }
                }
            }
        }
    }

    
    private func fetchImages(fromAlbum albumName: String) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        fetchResult.enumerateObjects { collection, _, _ in
            if collection.localizedTitle == albumName {
                let albumFetchOptions = PHFetchOptions()
                albumFetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                albumFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                let albumFetchResult = PHAsset.fetchAssets(in: collection, options: albumFetchOptions)
                
                albumFetchResult.enumerateObjects { asset, _, _ in
                    if asset.mediaType == .image {
                        getImageData(from: asset) { imageData in
                            if let data = imageData {
                                let imageName = getOriginalImageName(from: asset)
                                if let imageSizeInfo = getImageSizeInfo1(from: data, originalFilename: imageName) {
                                    let image = ImageModel(imageSizeInfo: imageSizeInfo, originalFilename: imageName)
                                    images.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
    func getImageSizeInfo1(from data: Data, originalFilename: String) -> ImageSizeInfo? {
        let originalSize = Double(data.count)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        if originalSize < 1000 {
            let sizeString = "\(Int(originalSize)) bytes"
            return ImageSizeInfo(image: image, sizeString: sizeString, dimension: "\(Int(image.size.width))*\(Int(image.size.height))", title: originalFilename)
        } else if originalSize < 1000000 {
            let kilobytes = originalSize / 1000.0
            let sizeString = numberFormatter.string(from: NSNumber(value: kilobytes)) ?? ""
            return ImageSizeInfo(image: image, sizeString: "\(sizeString) KB", dimension: "\(Int(image.size.width))*\(Int(image.size.height))", title: originalFilename)
        } else {
            let megabytes = originalSize / 1000000.0
            let sizeString = numberFormatter.string(from: NSNumber(value: megabytes)) ?? ""
            return ImageSizeInfo(image: image, sizeString: "\(sizeString) MB", dimension: "\(Int(image.size.width))*\(Int(image.size.height))", title: originalFilename)
        }
    }

    private func getOriginalImageName(from asset: PHAsset) -> String {
        var imageName = ""
        if let assetResources = PHAssetResource.assetResources(for: asset).first {
            imageName = assetResources.originalFilename
        }
        return imageName
    }

    private func getImageData(from asset: PHAsset, completion: @escaping (Data?) -> Void) {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        imageManager.requestImageData(for: asset, options: requestOptions) { imageData, _, _, _ in
            completion(imageData)
        }
    }

    
    func createThumbnailOfVideoFromFileURL(videoURL: String) -> CGImage? {
        let asset = AVAsset(url: URL(string: videoURL)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            return img
        } catch {
            return nil
        }
    }
    
    private func getVideoURL(from asset: PHAsset, completion: @escaping (URL?) -> Void) {
        let options = PHVideoRequestOptions()
        options.version = .original
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            if let avURLAsset = avAsset as? AVURLAsset {
                completion(avURLAsset.url)
            } else {
                completion(nil)
            }
        }
    }

    
    private func getVideoName(from asset: PHAsset) -> String {
        var videoName = ""
        if let assetResources = PHAssetResource.assetResources(for: asset).first {
            videoName = assetResources.originalFilename
        }
        return videoName
    }
}



struct VideoListView: View {
    var videos: [VideoModel]

        var body: some View {
            List(videos) { video in
                HStack(spacing: 20) {
                    if let thumbnailImage = video.thumbnailImage {
                        Image(uiImage: thumbnailImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .clipped()
                    }
    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(video.name)
                            .font(.headline)
    
                        Text(video.size)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            
        }
}


struct ImageListView: View {
    var images: [ImageModel]
    
    var body: some View {
        List(images) { image in
            HStack(spacing: 20) {
                Image(uiImage: image.imageSizeInfo.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(image.originalFilename)
                        .font(.headline)

                    Text(image.imageSizeInfo.sizeString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
    
        }
    }
}


struct OutputsView_Previews: PreviewProvider {
    static var previews: some View {
        OutputsView()
    }
}



struct ImageModel:Identifiable {
    let id = UUID()
    let imageSizeInfo: ImageSizeInfo
    let originalFilename: String

    // Other properties related to the image if needed
    
    // Optionally, you can include additional functionality or methods within the ImageModel struct
}
