//
//  ContentView.swift
//  TestPythonKit
//
//  Created by Vishal Kamble on 03/10/23.
//

//import SwiftUI
//import PythonKit
//import Cocoa
//
//struct ContentView: View {
//    @State private var outputText = ""
//    @State private var selectedFilePath: String?
//
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        
//
//            Button("Select DOCX File") {
//                selectedFilePath = openFilePanel()
//                dispData()
//            }
//
//            Button("Compress") {
////                if let filePath = selectedFilePath {
//                dispData()
////                } else {
////                    // Handle case where no file is selected
////                    print("No file selected.")
////                }
//            }
//        }
//        .padding()
//    }
//    func openFilePanel() -> String? {
//        let dialog = NSOpenPanel()
//
//        dialog.title = "Select a DOCX file"
//        dialog.allowedFileTypes = ["docx"]
//        dialog.allowsMultipleSelection = false
//        dialog.canChooseFiles = true
//        dialog.canChooseDirectories = false
//
//        if dialog.runModal() == NSApplication.ModalResponse.OK {
//            return dialog.url?.path
//        } else {
//            return nil
//        }
//    }
//
//    func dispData() -> PythonObject {
//        let sys = Python.import("sys")
//
//        print("Python \(sys.version_info.major).\(sys.version_info.minor)")
//        print("Python Version: \(sys.version)")
//        print("Python Encoding: \(sys.getdefaultencoding().upper())")
//      
//        let functionModule = Python.import("abc")
//        sys.path.append("/Users/adstringo_macmini/Desktop/DESKTOP/Vishal Projects/TestPythonKit/TestPythonKit")
//        
//        let a = 5
//                       let b = 7
//                       let sum = functionModule.helloworld()
//       
//
//        // Print the result or perform further actions as needed
//        print("Compression result: \(sum)")
//        return sum
//    }
//}



  /*
import SwiftUI
import PythonKit
import Cocoa
import ImageIO
import CoreGraphics
import CoreGraphics
import CoreServices
import Foundation
import CoreMediaIO


struct ContentView: View {
    @State private var result = 0
    @State private var test = ""
    @State private var selectedFilePath: String?

    var body: some View {
        VStack {
            Text("Python Function Call Example")
                .font(.title)
            
            
            
            
//            Button("Compress Image") {
//                if let filePath = selectedFilePath {
//                    let compressionMethod = "LZW" // Specify your desired compression method
//                    
//                    let outputURL = URL(fileURLWithPath: "/Users/adstringo_macmini/Desktop/compressed_output1245_asd121.tiff")
//    //                let outputURL = URL(fileURLWithPath: "/path/to/your/compressed.tiff")
//                    let compressionQuality: CGFloat = 0.8 // Adjust the compression quality as needed
//                    
//                    
//                    let inputURL = URL(fileURLWithPath: selectedFilePath!)
//        
//
//                    if compressMultipageTIFF(inputFilePath: filePath, outputFilePath: outputURL.path) {
//                        print("Compression successful.")
//                    } else {
//                        print("Compression failed.")
//                    }
//        
//                    let outputFolderPath =  "/Users/adstringo_macmini/Desktop/"
//                    
//                    
//                    let jpegFilepaths = convertTIFFToJPEGs(inputFilePath: filePath, outputFolder: outputFolderPath)
//
//                    
//                    // Step 1: Compress individual JPEGs
//                    if jpegFilepaths.isEmpty {
//                        print("No JPEGs created from TIFF file.")
//                    } else {
//                        let compressedJPEGFilepaths = jpegFilepaths.map { jpegFilePath -> String in
//                            let compressedFilePath = (outputFolderPath as NSString).appendingPathComponent("compressed_\(URL(fileURLWithPath: jpegFilePath).lastPathComponent)")
//
//                            if compressJPEG(jpegFilePath: jpegFilePath, outputFilePath: compressedFilePath) {
//                                return compressedFilePath
//                            } else {
//                                return jpegFilePath
//                            }
//                        }
//
//                        // Step 3: Merge compressed JPEGs into a multipage TIFF
//                        if mergeJPEGsToMultipageTIFF(jpegFilepaths: compressedJPEGFilepaths, outputFilePath: outputURL.path) {
//                            print("Conversion, compression, and merging successful. INPUT_PATH URL\(inputURL.absoluteString) OutputURL Path URL::\(outputURL.path)")
//                        } else {
//                            print("Merging into TIFF failed.")
//                        }
//                    }
//
//                    
//                } else {
//                    print("No image selected. Please choose an image file.")
//                }
//                
//                
//                
//                
//          
//                
//                
//                
//                let tiffURL = URL(fileURLWithPath: selectedFilePath!)
//                let pageCount = numberOfTIFFPages(in: tiffURL)
//                print("Number of pages in the TIFF file: \(pageCount)")
//            }
            
            Button("TIFF COMPRESSION"){
                if let filepath = selectedFilePath {
                    let outputFolderPath =  "/Users/adstringo_macmini/Desktop/abv.tiff"
                    
                    compressMultiPageTIFF(inputFilePath: filepath,compressionQuality: 0.1)
                }
            }
                

            Button("Select Image") {
                selectedFilePath = openFilePanel()
            }
            Button("Compress Image"){
                
                
//                let (beforeSize, afterSize) = pythonCompress(file_path: selectedFilePath!)
//                    print("Before Size: \(beforeSize) bytes")
//                    print("After Size: \(afterSize) bytes")
                
           
            }

            Button("Calculate Sum") {
                
                selectedFilePath = openFilePanel()
                let sys = Python.import("sys")
                sys.path.append(Bundle.main.resourcePath!)

//                let mathOperations = Python.import("math_operations")
//                let a = 531242356346
//                let b = 721321
//                let sum = mathOperations.subtract(a, b)
////                let test1 = mathOperations.hello2()
//
//                result = Int(sum)!
////                test = String("\(test1)")
//                
//                let fileSizeInBytes = 123456789
//                let formattedSize = mathOperations.convert_size(fileSizeInBytes)
//                    print("File Size: \(formattedSize)")
            }
            
            Text("Result: \(result)")
                .font(.headline)
        }
        .padding()
    }
    
    
    func compressTIFFImage(inputURL: URL, outputURL: URL) {
        guard let imageSource = CGImageSourceCreateWithURL(inputURL as CFURL, nil) else {
            print("Error: Unable to create image source")
            return
        }

        let destinationURL = outputURL as CFURL
        guard let destination = CGImageDestinationCreateWithURL(destinationURL, kUTTypeTIFF, 1, nil) else {
            print("Error: Unable to create image destination")
            return
        }

        // Set compression options (you can adjust the compression quality)
        let options: [CFString: Any] = [
            kCGImagePropertyTIFFCompression: kCGImagePropertyTIFFCompressionLZW,
            kCGImagePropertyTIFFDictionary as CFString: [
                kCGImagePropertyTIFFXResolution: 72,
                kCGImagePropertyTIFFYResolution: 72,
                kCGImagePropertyTIFFResolutionUnit: kCGImagePropertyTIFFUnitInch
            ]
        ]

        CGImageDestinationSetProperties(destination, options as CFDictionary)

        for index in 0..<CGImageSourceGetCount(imageSource) {
            if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, index, nil) {
                CGImageDestinationAddImage(destination, cgImage, nil)
            }
        }

        if CGImageDestinationFinalize(destination) {
            print("TIFF image compression successful")
        } else {
            print("Error: Unable to finalize image destination")
        }
    }
    
    
    func compressMultiPageTIFF(inputFilePath: String, compressionQuality: CGFloat = 0.5) {
        // Initialize the multi-page TIFF file URL
        let inputFileURL = URL(fileURLWithPath: inputFilePath)
        
        // Check if the input file exists
        if !FileManager.default.fileExists(atPath: inputFileURL.path) {
            print("Error: Input file does not exist")
            return
        }
        // Create an image source from the input file
        guard let source = CGImageSourceCreateWithURL(inputFileURL as CFURL, nil) else {
            print("Error: Failed to create an image source from the input file")
            return
        }
    
        let desktopDirectoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!

        // Specify the filename (e.g., "output.tiff") for the output file
        let outputFileName = "output.tiff"
        let outputFilePathOnDesktop = desktopDirectoryURL.appendingPathComponent(outputFileName)
        
        // Create a destination for the compressed TIFF
        guard let destination = CGImageDestinationCreateWithURL(outputFilePathOnDesktop as CFURL, kUTTypeTIFF, CGImageSourceGetCount(source), nil) else {
            print("Error: Failed to create an image destination for the output file")
            return
        }
        
        // Set compression options
        let compressionQualityOptions: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality as CFString: compressionQuality]
        
        let options: [CFString: Any] = [
            kCGImagePropertyTIFFCompression as CFString: "public.lzw2",
            kCGImageDestinationLossyCompressionQuality as CFString: compressionQuality
        ]
        
        // Read and compress each page
        for i in 0..<CGImageSourceGetCount(source) {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                print("Error: Failed to create an image at page \(i)")
                continue
            }
            CGImageDestinationAddImage(destination, image, options as CFDictionary)
        }
        
        // Finalize the destination
        if !CGImageDestinationFinalize(destination) {
            print("Error: Failed to finalize the destination")
        }
    }


    func convertTIFFToJPEGs(inputFilePath: String, outputFolder: String) -> [String] {
        guard let source = CGImageSourceCreateWithURL(URL(fileURLWithPath: inputFilePath) as CFURL, nil) else {
            print("Error creating image source for TIFF file.")
            return []
        }

        var jpegFilepaths: [String] = []

        for index in 0..<CGImageSourceGetCount(source) {
            if let img = CGImageSourceCreateImageAtIndex(source, index, nil) {
                let jpegFilePath = (outputFolder as NSString).appendingPathComponent("page\(index + 1).jpg")
                guard let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: jpegFilePath) as CFURL, kUTTypeJPEG, 1, nil) else {
                    print("Error creating image destination for JPEG file.")
                    continue
                }
                CGImageDestinationAddImage(destination, img, nil)
                if CGImageDestinationFinalize(destination) {
                    jpegFilepaths.append(jpegFilePath)
                }
            }
        }

        return jpegFilepaths
    }
    
    
    
    
    
    func convertAndCompressTIFFToJPEG(inputFilePath: String, outputFolderPath: String, compressionQuality: CGFloat = 0.1) -> [String] {
        guard let source = CGImageSourceCreateWithURL(URL(fileURLWithPath: inputFilePath) as CFURL, nil) else {
            print("Error creating image source.")
            return []
        }

        var jpegFilepaths: [String] = []

        for index in 0..<CGImageSourceGetCount(source) {
            if let img = CGImageSourceCreateImageAtIndex(source, index, nil) {
                let jpegData = NSMutableData()
                guard let destination = CGImageDestinationCreateWithData(jpegData, kUTTypeJPEG, 1, nil) else {
                    print("Error creating JPEG destination.")
                    continue
                }

                let options: [CFString: Any] = [
                    kCGImageDestinationLossyCompressionQuality: compressionQuality
                ]

                CGImageDestinationAddImage(destination, img, options as CFDictionary)
                if CGImageDestinationFinalize(destination) {
                    let jpegFilename = "page\(index + 1).jpg"
                    let jpegFilePath = (outputFolderPath as NSString).appendingPathComponent(jpegFilename)
                    jpegData.write(toFile: jpegFilePath, atomically: true)
                    jpegFilepaths.append(jpegFilePath)
                }
            }
        }

        return jpegFilepaths
    }
    
    
    func mergeJPEGsToMultipageTIFF(jpegFilepaths: [String], outputFilePath: String) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: outputFilePath) as CFURL, kUTTypeTIFF, jpegFilepaths.count, nil) else {
            print("Error creating image destination.")
            return false
        }
        
        for jpegFilePath in jpegFilepaths {
            if let jpegImageSource = CGImageSourceCreateWithURL(URL(fileURLWithPath: jpegFilePath) as CFURL, nil),
               let jpegImage = CGImageSourceCreateImageAtIndex(jpegImageSource, 0, nil) {
                CGImageDestinationAddImage(destination, jpegImage, nil)
            }
        }
        
        
        return CGImageDestinationFinalize(destination)
    }
    

    
    
    func compressJPEG(jpegFilePath: String, outputFilePath: String, compressionQuality: CGFloat = 0.7) -> Bool {
        guard let jpegImageSource = CGImageSourceCreateWithURL(URL(fileURLWithPath: jpegFilePath) as CFURL, nil),
              let jpegImage = CGImageSourceCreateImageAtIndex(jpegImageSource, 0, nil) else {
            print("Error creating image source for JPEG file.")
            return false
        }

        guard let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: outputFilePath) as CFURL, kUTTypeJPEG, 1, nil) else {
            print("Error creating image destination.")
            return false
        }

        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: compressionQuality
        ]

        CGImageDestinationAddImage(destination, jpegImage, options as CFDictionary)

        return CGImageDestinationFinalize(destination)
    }
    
    func compressAllJPEGsInFolder(inputFolderPath: String, outputFolder: String) -> [String] {
        guard let jpegFileURLs = try? FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: inputFolderPath), includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            print("No JPEG files found in the input folder.")
            return []
        }

        var compressedJPEGFilepaths: [String] = []

        for jpegFileURL in jpegFileURLs {
            let compressedJPEGFilePath = (outputFolder as NSString).appendingPathComponent(jpegFileURL.lastPathComponent)
            if compressJPEG(jpegFilePath: jpegFileURL.path, outputFilePath: compressedJPEGFilePath) {
                compressedJPEGFilepaths.append(compressedJPEGFilePath)
            }
        }

        return compressedJPEGFilepaths
    }

    
    func mergeJPEGsToMultipageTIFF1(jpegFilepaths: [String], outputFilePath: String) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: outputFilePath) as CFURL, kUTTypeTIFF, jpegFilepaths.count, nil) else {
            print("Error creating image destination.")
            return false
        }

        for jpegFilePath in jpegFilepaths {
            if let jpegImageSource = CGImageSourceCreateWithURL(URL(fileURLWithPath: jpegFilePath) as CFURL, nil),
               let jpegImage = CGImageSourceCreateImageAtIndex(jpegImageSource, 0, nil) {
                CGImageDestinationAddImage(destination, jpegImage, nil)
            }
        }

        return CGImageDestinationFinalize(destination)
    }

    
    
    func compressMultipageTIFF(inputFilePath: String, outputFilePath: String, compressionQuality: CGFloat = 0.1) -> Bool {
        guard let source = CGImageSourceCreateWithURL(URL(fileURLWithPath: inputFilePath) as CFURL, nil) else {
            print("Error creating image source.")
            return false
        }

        guard let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: outputFilePath) as CFURL, kUTTypeJPEG, CGImageSourceGetCount(source), nil) else {
            print("Error creating image destination.")
            return false
        }


        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: compressionQuality
        ]

        for index in 0..<CGImageSourceGetCount(source) {
            if let img = CGImageSourceCreateImageAtIndex(source, index, nil) {
                CGImageDestinationAddImage(destination, img, options as CFDictionary)
            }
        }

        return CGImageDestinationFinalize(destination)
    }

    func numberOfTIFFPages(in tiffURL: URL) -> Int {
        guard let sourceImage = CGImageSourceCreateWithURL(tiffURL as CFURL, nil) else {
            print("Error loading the TIFF file.")
            return 0
        }
        
        return CGImageSourceGetCount(sourceImage)
    }

  


    func pythonCompressImage(imagePath: String, quality: Int = 75) -> PythonObject {
        let sys = Python.import("sys")
        sys.path.append(Bundle.main.resourcePath!)
        let python = Python.import("math_operations")
        let result = python.compress_image(imagePath, quality)
        return result
    }
    
    
    func openFilePanel() -> String? {
            let dialog = NSOpenPanel()
    
            dialog.title = "Select a DOCX file"
            dialog.allowedFileTypes = ["jpeg","jpg", "zip", "tif","tiff"]
            dialog.allowsMultipleSelection = false
            dialog.canChooseFiles = true
            dialog.canChooseDirectories = false
    
            if dialog.runModal() == NSApplication.ModalResponse.OK {
                return dialog.url?.path
            } else {
                return nil
            }
        }
    
    func pythonCompress(file_path: String) -> (Int, Int) {
        let sys = Python.import("sys")
        sys.path.append(Bundle.main.resourcePath!)
        let mathOperations = Python.import("math_operations")
        let result = mathOperations.compress(file_path)
        return (Int(result[0])!, Int(result[1])!)
    }

    
 

    func compressMultiPageTIFF(inputURL: URL, outputURL: URL, compressionMethod: String) -> URL? {
        // Attempt to create a CGImageSource from the input URL
        guard let sourceImage = CGImageSourceCreateWithURL(inputURL as CFURL, nil) else {
            print("Error loading the source multi-page TIFF image.")
            return nil
        }
        
        let destinationData = NSMutableData()
        
        // Determine the number of pages in the source multi-page TIFF
        let pageCount = CGImageSourceGetCount(sourceImage)
        
        // Create a destination for the multi-page TIFF
        guard let destinationImage = CGImageDestinationCreateWithData(destinationData as CFMutableData, kUTTypeTIFF, pageCount, nil) else {
            print("Error creating the destination multi-page TIFF image.")
            return nil
        }
        
        // Set the compression options
        let compressionOptions: [CFString: Any] = [
            kCGImagePropertyTIFFCompression as CFString: compressionMethod as CFString
        ]
        
        let imageProperties: [CFString: Any] = [
            kCGImagePropertyTIFFDictionary as CFString: compressionOptions
        ]
        
        for pageIndex in 0..<pageCount {
            // Get each page from the source multi-page TIFF
            guard let image = CGImageSourceCreateImageAtIndex(sourceImage, pageIndex, nil) else {
                print("Error creating image at index \(pageIndex).")
                continue
            }
            
            // Set compression properties for each page
            let frameProperties: [CFString: Any] = [
                kCGImagePropertyTIFFDictionary as CFString: compressionOptions
            ]
            
            // Add each page to the destination
            CGImageDestinationAddImage(destinationImage, image, frameProperties as CFDictionary)
        }
        
        // Finalize the destination for the multi-page TIFF
        if CGImageDestinationFinalize(destinationImage) {
            do {
                try destinationData.write(to: outputURL, options: .atomic)
                print("Compression complete. Compressed multi-page TIFF saved at \(outputURL.path)")
                return outputURL
            } catch {
                print("Error writing the compressed image data to the desktop: \(error)")
            }
        } else {
            print("Error finalizing the destination multi-page TIFF image.")
        }
        
        return nil
    }


}






#Preview {
    ContentView()
   }*/

import SwiftUI

struct DemoCustomCursor: View {
    @State private var showToast = false
    
    var body: some View {
        Button(action: {
            showToast = true
        }) {
            Text("Cross Button")
                .padding(20)
                .background(Color.blue)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { inside in
            if inside {
                showToast = true
            } else {
                showToast = false
            }
        }
        .overlay(
            showToast ? ToastView(message: "Hovered over the button") : nil
        )
    }
}

struct ToastView: View {
    var message: String
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}

struct ContentView: View {
    @State private var showToast = false

     var body: some View {
         Button("vishal"){
             showToast = true
         }
         .onHover { inside in
             if inside {
                 showToast = true
             } else {
                 showToast = false
             }
         }
         .toast(message: "Current time:\n\(Date().formatted(date: .complete, time: .complete))",
                isShowing: $showToast,
                duration: Toast.short)

     }
   }








struct Toast: ViewModifier {
  // these correspond to Android values f
  // or DURATION_SHORT and DURATION_LONG
  static let short: TimeInterval = 2
  static let long: TimeInterval = 3.5

  let message: String
  @Binding var isShowing: Bool
  let config: Config

  func body(content: Content) -> some View {
    ZStack {
      content
      toastView
    }
  }

  private var toastView: some View {
    VStack {
        Spacer()
      if isShowing {
        Group {
          Text(message)
            .multilineTextAlignment(.center)
            .foregroundColor(config.textColor)
            .font(config.font)
            .padding(8)
        }
        .background(config.backgroundColor)
        .cornerRadius(8)
        .onTapGesture {
          isShowing = false
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
            isShowing = false
          }
        }
      }
    
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 18)
    .animation(config.animation, value: isShowing)
    .transition(config.transition)
    .frame(maxWidth: 100)
  }

  struct Config {
    let textColor: Color
    let font: Font
    let backgroundColor: Color
    let duration: TimeInterval
    let transition: AnyTransition
    let animation: Animation

    init(textColor: Color = .white,
         font: Font = .system(size: 14),
         backgroundColor: Color = .black.opacity(0.588),
         duration: TimeInterval = Toast.short,
         transition: AnyTransition = .opacity,
         animation: Animation = .linear(duration: 0.3)) {
      self.textColor = textColor
      self.font = font
      self.backgroundColor = backgroundColor
      self.duration = duration
      self.transition = transition
      self.animation = animation
    }
  }
}

extension View {
  func toast(message: String,
             isShowing: Binding<Bool>,
             config: Toast.Config) -> some View {
    self.modifier(Toast(message: message,
                        isShowing: isShowing,
                        config: config))
  }

  func toast(message: String,
             isShowing: Binding<Bool>,
             duration: TimeInterval) -> some View {
    self.modifier(Toast(message: message,
                        isShowing: isShowing,
                        config: .init(duration: duration)))
  }
}

struct ColorfulPageView: View {
    var body: some View {
        Color(.yellow) // Background color
            .opacity(1) // Opacity for the entire view
            .overlay(
                ZStack {
                    // Background gradient
                    LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Welcome to My App")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                        
                        Button("Submit") {
                            // Button action
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.yellow)
                                .frame(width: 200, height: 200)
                                .overlay(Text("Colorful!").foregroundColor(.black))
                        )
                        
                        Spacer()
                    }
                }
            )
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isOnboardingComplete = false

    let onboardingImages = ["sm1", "sm2","sm3", "sm4", "sm5", "sm6","sm7","sm8", "sm9"]
    @State private var viewStack: [AnyView] = []

    var body: some View {
        ZStack {
            // Container view for the image
            Image(onboardingImages[currentPage])
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    HStack {
                        if currentPage < onboardingImages.count - 1 {
                            Button("Skip") {
                                // Handle "Skip" action (e.g., complete the onboarding)
                                isOnboardingComplete = true
                            }
                            .padding()
                        } else {
                            Button("Finish") {
                                // Handle "Finish" action (e.g., complete the onboarding)
                                isOnboardingComplete = true
                            }
                            .padding()
                        }

                        Button(currentPage < onboardingImages.count - 1 ? "Next" : "") {
                            // Handle "Next" action (e.g., go to the next onboarding page)
                            if currentPage < onboardingImages.count - 1 {
                                currentPage += 1
                            } else {
                                // Push a new view to the stack (e.g., ContentView)
                                viewStack.append(AnyView(ContentView()))
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            // Push the initial onboarding view onto the stack
            viewStack.append(AnyView(self))
        }
        .background(
            StackNavigation(viewStack: $viewStack)
        )
    }
}


struct StackNavigation: View {
    @Binding var viewStack: [AnyView]

    var body: some View {
        ZStack {
            ForEach(viewStack.indices, id: \.self) { index in
                viewStack[index]
            }
        }
    }
}
