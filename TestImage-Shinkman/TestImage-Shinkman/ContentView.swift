//
//  ContentView.swift
//  TestImage-Shinkman
//
//  Created by Vishal Kamble on 12/09/23.
//





import SwiftUI
import Cocoa
import FYVideoCompressor


/*
struct ContentView: View {

        @State private var selectedImageURL: URL?
        @State private var compressedImageURL: URL?
    @State private var appSettings = AppSettings(
        enterName: "",
        selectedOption: "Before",
        isSavedOriginalFilename: false,
        isSavedWithDate: true,
        isReplaceOriginalFolderFS: true, // Replace with your default value
        isSavetoFolderFS: false, // Replace with your default value
        folderNameFS: "", // Replace with your default folder name
        outputfileSizeKbFS: "300", // Replace with your default value
        isImageResizeFS: true, // Replace with your default value
        isOutputSizeFS: false, // Replace with your default value
        fileWidthFS: "500", // Replace with your default value
        fileHeightFS: "500" // Replace with your default value
    )


    @State private var isCompressing = false // Indicates whether compression is in progress

        var body: some View {
            VStack {
                Button("Pick an Image") {
                    selectImage()
                }
                if let selectedImageURL = selectedImageURL {
                    Image(nsImage: NSImage(contentsOf: selectedImageURL) ?? NSImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding()

                    Button("Compress Image") {
                        compressImage()
                    }
                    .disabled(isCompressing) // Disable the button during compression

                    if isCompressing {
                                        ProgressView("Compressing...")
                                            .progressViewStyle(CircularProgressViewStyle())
                                    }

                    if let compressedImageURL = compressedImageURL {
                        Text("Original File Name: \(selectedImageURL.lastPathComponent)")
                            .font(.headline)
                            .padding()

                        Text("Compressed File Name: \(compressedImageURL.lastPathComponent)")
                            .font(.headline)
                            .padding()

                        if let originalFileSize = fileSize(of: selectedImageURL),
                           let compressedFileSize = fileSize(of: compressedImageURL) {
                            Text("Original Size: \(originalFileSize)")
                            Text("Compressed Size: \(compressedFileSize)")
                        }

                        Text("Compressed Path: \(compressedImageURL.path)")
                            .font(.headline)
                            .padding()

                        Image(nsImage: NSImage(contentsOf: compressedImageURL) ?? NSImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                }
            }
            .padding()
        }

        private func selectImage() {
            let dialog = NSOpenPanel()
            dialog.title = "Select an Image"
            dialog.allowedFileTypes = ["png"]
            dialog.allowsMultipleSelection = false

            if dialog.runModal() == .OK {
                selectedImageURL = dialog.urls.first
            }
        }

        private func compressImage() {
            isCompressing = true
            DispatchQueue.global().async {
                compressedImageURL = Self.compressPNGImage(from: selectedImageURL!, appSettings: appSettings)
                isCompressing = false
            }
        }
    

    private func fileSize(of url: URL) -> String? {
           do {
               let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
               if let fileSize = attributes[.size] as? Int64 {
                   let formatter = ByteCountFormatter()
                   formatter.allowedUnits = [.useKB, .useMB, .useGB]
                   formatter.countStyle = .file
                   return formatter.string(fromByteCount: fileSize)
               }
           } catch {
               return nil
           }
           return nil
       }
    


    static func compressPNGImage(from imageURL: URL, appSettings: AppSettings) -> URL? {
        guard let image = NSImage(contentsOf: imageURL),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        var compressedImageURL: URL

        if appSettings.isReplaceOriginalFolderFS {
            // Keep the original file name
            compressedImageURL = documentsDirectory.appendingPathComponent(imageURL.lastPathComponent)
        } else {
            if let compressedName = compressedFileName(appSettings: appSettings, originalFileName: imageURL.lastPathComponent) {
                
                compressedImageURL = documentsDirectory.appendingPathComponent(compressedName)
            } else {
                // Handle the case when the compressed file name cannot be generated
                return nil
            }
        }

        if appSettings.isOutputSizeFS, let fileSizeKb = Int(appSettings.outputfileSizeKbFS) {
            // Calculate compression quality based on desired file size
            let compressionQuality = calculateCompressionQuality(cgImage, sourceSize: image.size, desiredFileSizeBytes: fileSizeKb * 1024)
            print(compressionQuality, "compressionQualitycompressionQuality")
            guard let imageDestination = CGImageDestinationCreateWithURL(compressedImageURL as CFURL, kUTTypePNG, 1, nil) else {
                return nil
            }

            let options: NSDictionary = [
                kCGImageDestinationLossyCompressionQuality: compressionQuality
            ]

            CGImageDestinationAddImage(imageDestination, cgImage, options)
            guard CGImageDestinationFinalize(imageDestination) else {
                return nil
            }
        } else {
            // If output size compression is not enabled, copy the original image to the compressed location
            do {
                try FileManager.default.copyItem(at: imageURL, to: compressedImageURL)
            } catch {
                return nil
            }
        }

        return compressedImageURL
    }

    static private func compressedFileName(appSettings: AppSettings, originalFileName: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let currentDate = dateFormatter.string(from: Date())

        if appSettings.isSavedOriginalFilename{
            return originalFileName
        }
       else if appSettings.isSavedWithDate {
            // Add current date to the file name
            var fileName: String

            if appSettings.selectedOption == "Before" {
                fileName = "\(appSettings.enterName)_\(currentDate)_\(originalFileName)"
            } else if appSettings.selectedOption == "After" {
                fileName = "\(currentDate)_\(appSettings.enterName)_\(originalFileName)"
            } else {
                fileName = "\(originalFileName)"
            }

            return fileName
        } else {
            // Handle the case when isSavedWithDate is false
            var fileName: String

            if appSettings.selectedOption == "Before" {
                fileName = "\(appSettings.enterName)_\(originalFileName)"
            } else if appSettings.selectedOption == "After" {
                fileName = "\(originalFileName)_\(appSettings.enterName)"
            } else {
                fileName = "\(originalFileName)"
            }

            return fileName
        }
    }

    static private func calculateCompressionQuality(_ cgImage: CGImage, sourceSize: CGSize, desiredFileSizeBytes: Int) -> CGFloat {
        var minQuality: CGFloat = 0.0
        var maxQuality: CGFloat = 1.0
        var currentQuality: CGFloat = 0.1 // Initial guess for quality

        while minQuality <= maxQuality {
            let currentData = compressImageWithQuality(cgImage, sourceSize: sourceSize, quality: currentQuality)
            if let currentSize = currentData?.count {
                if currentSize <= desiredFileSizeBytes {
                    return currentQuality // Found a quality level that meets the desired size
                } else if currentSize > desiredFileSizeBytes * 2 {
                    maxQuality = currentQuality // Current quality produces a file size much larger than desired
                } else {
                    minQuality = currentQuality // Current quality produces a file size larger than desired, but not by too much
                }
            }

            // Update current quality using binary search
            currentQuality = (minQuality + maxQuality) / 2.0
        }

        return currentQuality
    }

    static private func compressImageWithQuality(_ cgImage: CGImage, sourceSize: CGSize, quality: CGFloat) -> Data? {
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
        if let context = CGContext(data: nil, width: Int(sourceSize.width), height: Int(sourceSize.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue) {
            context.interpolationQuality = .high
            context.setShouldAntialias(true)
            context.setAllowsAntialiasing(true)
            context.draw(cgImage, in: CGRect(origin: .zero, size: sourceSize))
            if let compressedImage = context.makeImage() {
                let compressedData = NSMutableData()
                if let imageDestination = CGImageDestinationCreateWithData(compressedData, kUTTypePNG, 1, nil) {
                    let options: NSDictionary = [
                        kCGImageDestinationLossyCompressionQuality: quality
                    ]
                    CGImageDestinationAddImage(imageDestination, compressedImage, options)
                    if CGImageDestinationFinalize(imageDestination) {
                        return compressedData as Data
                    }
                }
            }
        }
        return nil
    }


    
}
 
 func pickVideo() {
     let panel = NSOpenPanel()
     panel.allowedFileTypes = ["mp4", "mov"] // Specify the allowed file types
     panel.canChooseFiles = true
     panel.canChooseDirectories = false
     panel.allowsMultipleSelection = false

     if panel.runModal() == .OK, let url = panel.url {
         selectedVideoURL = url
     }
 }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


*/

import SwiftUI
import FYVideoCompressor
import AVFoundation

struct VideoCompressionView: View {
    @State private var selectedVideoURL: URL?
    @State private var compressionResult: Result<URL, Error>?

    var body: some View {
        VStack {
            Button("Pick Video") {
                pickVideo()
            }

            if selectedVideoURL != nil {
                Text("Selected Video: \(selectedVideoURL!.lastPathComponent)")
            }

            Button("Compress Video") {
                compressVideo()
            }

            if let result = compressionResult {
                switch result {
                case .success(let compressedURL):
                    Text("Compression succeeded. Compressed video saved at \(compressedURL.path)")
                case .failure(let error):
                    Text("Compression failed. Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func pickVideo() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["mp4", "mov"] // Specify the allowed file types
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            selectedVideoURL = url
        }
    }

    func compressVideo() {
        guard let sourceURL = selectedVideoURL else {
            return
        }

        let compressor = FYVideoCompressor1()
        let quality = FYVideoCompressor1.VideoQuality.custom1(qualityPercentage: 10) // You can change the quality as needed.
        
        let homeDirectoryURL = FileManager.default.homeDirectoryForCurrentUser

         
          let   outputDirectoryURL = homeDirectoryURL.appendingPathComponent("Desktop")
      
        compressor.compressVideo(sourceURL, quality: quality, outputPath: outputDirectoryURL) { result in
            DispatchQueue.main.async {
                self.compressionResult = result
            }
        }
    }
}

struct VideoCompressionView_Previews: PreviewProvider {
    static var previews: some View {
        VideoCompressionView()
    }
}
