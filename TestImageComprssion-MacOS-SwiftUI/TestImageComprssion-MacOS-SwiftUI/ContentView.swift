//
//  ContentView.swift
//  TestImageComprssion-MacOS-SwiftUI
//
//  Created by Vishal Kamble on 01/09/23.
//


import SwiftUI
import ImageIO
import Cocoa
import SwiftImage


struct ContentView: View {
    @State private var selectedImage: NSImage?
    @State private var selectURL:URL?
    @State private var selectURLPath:String
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No image selected")
            }
            
            Button("Select Image") {
                // Implement code to select an image
                selectImage()
            }
            
            Button("Compress Image") {
                // Implement code to compress the selected image
//                compressImage(at: selectURL!, quality: 10)
            }
        }
        .padding()
    }
    
    func selectImage() {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = [ "png"]
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                selectedImage = NSImage(contentsOf: url)
                selectURL = url
                selectURLPath = url.absoluteString
            }
        }
    }

    
    func compressImage(at imagePath: String, quality: CGFloat) {
            do {
                // Load the image from the specified file path using SwiftImage
                guard let image = Image(contentsOfFile: imagePath) else {
                                print("Error: Unable to load the image.")
                                return
                            }
                // Compress the image using SwiftImage
                let compressedImage = image.jpeg(compressionQuality: quality)

                // Convert the compressed Image to Data
                if let compressedData = compressedImage.data {
                    // Save the compressed image data or perform further actions
                    // For example, you can save it to a file or display it in your UI
                    // Here, we'll just print the compressed data size
                    print("Compressed Image Size: \(compressedData.count) bytes")
                }
            } catch {
                // Handle image loading or compression errors
                print("Error: \(error.localizedDescription)")
            }
        }


    
  
}
