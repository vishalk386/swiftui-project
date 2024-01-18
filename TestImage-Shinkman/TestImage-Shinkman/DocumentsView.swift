//
//  DocumentsView.swift
//  TestImage-Shinkman
//
//  Created by Vishal Kamble on 29/09/23.
//

import SwiftUI
import WebKit

class WebViewDelegate: NSObject, WKNavigationDelegate {
    var images: Binding<[NSImage]> // Use Binding

    init(images: Binding<[NSImage]>) {
        self.images = images
    }

    // In WebViewDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // WebView finished loading, now capture the snapshot
        let image = webView.snapshot()

        if let image = image {
            // Add the generated image to the images array
            images.wrappedValue.append(image)

            // Save the image to a folder
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let imageFileName = "image\(images.wrappedValue.count).jpeg"
                let imagePath = documentsDirectory.appendingPathComponent(imageFileName)

                if let imageData = image.tiffRepresentation {
                    let bitmap = NSBitmapImageRep(data: imageData)
                    if let jpegData = bitmap?.representation(using: .jpeg, properties: [:]) {
                        do {
                            try jpegData.write(to: imagePath)
                            print("Image saved to: \(imagePath)")
                        } catch {
                            print("Error saving image: \(error)")
                        }
                    }
                }
            } else {
                print("Error: Could not access Documents directory")
            }
        } else {
            // Handle the case where snapshot() returns nil
            print("Error capturing snapshot: WebView content may not be fully loaded")
        }
    }
}


struct DocumentsView: View {
    @State private var images: [NSImage] = []
    @State private var docxURL: URL?

    var body: some View {
        VStack {
            Button("Convert DOCX to JPEG") {
                if let docxURL = docxURL {
                    convertDocxToJpeg(docxURL: docxURL)
                }
            }
            .disabled(docxURL == nil)

            Button("Open Panel") {
                openFilePanel()
            }

            ScrollView {
                HStack {
                    ForEach(images, id: \.self) { image in
                        Image(nsImage: image)
                            .resizable()
                            .frame(width: 200, height: 200)
                    }
                }
            }
        }
    }

    func openFilePanel() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["docx"]

        panel.begin { (result) in
            if result == .OK, let url = panel.url {
                self.docxURL = url
            }
        }
    }

    func convertDocxToJpeg(docxURL: URL) {
        let webView = WKWebView()

        // Load the DOCX file using WebView
        let request = URLRequest(url: docxURL)
        webView.navigationDelegate = WebViewDelegate(images: $images) // Use the delegate

        webView.load(request)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsView()
    }
}

extension WKWebView {
    func snapshot() -> NSImage? {
        // Check if WKWebView is nil or not loaded yet
        guard let layer = self.layer,
              self.isLoading == false,
              self.bounds.size.width > 0,
              self.bounds.size.height > 0
        else {
            return nil
        }

        let bounds = self.bounds
        guard let bitmapImageRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(bounds.size.width),
            pixelsHigh: Int(bounds.size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: Int(bounds.size.width) * 4,
            bitsPerPixel: 32
        ) else {
            return nil
        }
        
        let context = NSGraphicsContext(bitmapImageRep: bitmapImageRep)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context
        
        // Ensure that you are rendering the WebView's layer
        if let webViewLayer = self.layer {
            webViewLayer.render(in: context!.cgContext)
        }
        
        NSGraphicsContext.restoreGraphicsState()

        let image = NSImage(size: bounds.size)
        image.addRepresentation(bitmapImageRep)

        return image
    }
}
