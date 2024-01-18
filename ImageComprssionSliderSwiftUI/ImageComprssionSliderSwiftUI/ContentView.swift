//
//  ContentView.swift
//  ImageComprssionSliderSwiftUI
//
//  Created by Vishal Kamble on 08/09/23.
//

import SwiftUI
import Cocoa

enum ImageType: String, CaseIterable {
    case jpeg = "JPEG"
    case png = "PNG"
    case heic = "HEIC"
}

struct ContentView: View {
    @State private var selectedImage: NSImage?
    @State private var compressedImage: NSImage?
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var originalSizeText = "Original Size: N/A"
    @State private var compressedSizeText = "Compressed Size: N/A"
    @State private var selectedImageType: ImageType = .jpeg // Default to JPEG
    @State private var sliderValueChanged = false
    @State private var isFileDetailsViewPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Select Image") {
                    selectImage()
                }
                
                VStack {
                    SettingSlider(value: settingsViewModel.binding(for: .jpeg), title: "JPEG Quality", showTickMarks: true) { newValue in
                        // The slider value will be automatically updated in the settings dictionary
                        sliderValueChanged = true // Set the flag to indicate slider value change
                    }

                    SettingSlider(value: settingsViewModel.binding(for: .png), title: "PNG Quality", showTickMarks: true) { newValue in
                        // The slider value will be automatically updated in the settings dictionary
                        sliderValueChanged = true // Set the flag to indicate slider value change
                    }
                }

                Text(originalSizeText)
                    .padding()
                
                Image(nsImage: selectedImage ?? NSImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                NavigationLink(
                    destination: FileDetailsView(settingsViewModel: settingsViewModel),
                                    isActive: $isFileDetailsViewPresented,
                                    label: {
                                        Text("Open File Details")
                                    }
                                )
                Text(compressedSizeText)
                    .padding()
            }
            .padding()
            .onChange(of: sliderValueChanged) { _ in
                // When slider value changes, trigger image compression
                if sliderValueChanged {
                    compressImage()
                    sliderValueChanged = false // Reset the flag
                }
            }
        }
    }
    
    func selectImage() {
        // Use an NSOpenPanel to allow the user to select an image
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["jpg", "jpeg", "png"]
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        
        if openPanel.runModal() == .OK, let imageURL = openPanel.url {
            selectedImage = NSImage(contentsOf: imageURL)
            originalSizeText = "Original Size: \(formattedSize(fileSize: getFileSize(fileURL: imageURL)))"
        }
    }
    
    func compressImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        
        if let compressedImageData = compressJPEGImage(image: selectedImage, quality: settingsViewModel.settings[.jpeg] ?? 0.5) {
            let compressedImage = NSImage(data: compressedImageData)
            self.compressedImage = compressedImage
            compressedSizeText = "Compressed Size: \(formattedSize(fileSize: Int64(compressedImageData.count)))"
        }
    }
    
    func formattedSize(fileSize: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
    
    func getFileSize(fileURL: URL) -> Int64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            if let fileSize = fileAttributes[FileAttributeKey.size] as? NSNumber {
                return fileSize.int64Value
            }
        } catch {
            print("Error getting file size: \(error)")
        }
        return 0
    }
    
    func compressJPEGImage(image: NSImage, quality: CGFloat) -> Data? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let properties: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: quality // Set the compression quality
        ]
        
        if let compressedData = bitmapRep.representation(using: .jpeg, properties: properties) {
            return compressedData
        } else {
            return nil
        }
    }
}


struct SettingSlider: View {
    @Binding var value: CGFloat
    let title: String
    @State private var isDragging = false // Track if the circle is being dragged
    var showTickMarks: Bool = false // Control the visibility of tick marks
    var onChanged: ((CGFloat) -> Void)? // Add an onChanged closure
    
    var body: some View {
        HStack(alignment: .center) {
            Text("\(title)")
                .font(
                    Font.custom("Lato", size: 14)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.bottom, -20)
                .frame(width: 80) // Set a fixed width for the title to create spacing
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.2))
                            .frame(width: geometry.size.width, height: 24)
                            .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.02, green: 0.27, blue: 0.58), lineWidth: 1)
                            )
                            .onTapGesture(coordinateSpace: .local) { location in
                                self.onTap(location: location, geometry: geometry)
                            }
                        
                        Rectangle()
                            .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
                            .frame(width: self.progressWidth(geometry: geometry), height: 24)
                            .cornerRadius(12)
                            .gesture(DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    self.onDragChanged(value: value, geometry: geometry)
                                })
                                .onEnded({ value in
                                    self.onDragEnded(value: value, geometry: geometry)
                                    onChanged?(self.value)
                                })
                            )
                        
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .offset(x: self.thumbOffset(for: geometry), y: 0)
                            .gesture(DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    self.onDragCircleChanged(value: value, geometry: geometry)
                                })
                                .onEnded({ value in
                                    self.onDragCircleEnded(value: value, geometry: geometry)
                                    onChanged?(self.value)
                                })
                            )
                            .animation(.none) // Disable animation for the circle while dragging
                        
                        // Add tick marks inside this ZStack to position them above the main Rectangle
                        if showTickMarks {
                            ZStack(alignment: .top) {
                                ForEach(1..<11) { index in
                                    let tickOffset = CGFloat(index) * (geometry.size.width - 30) / 10
                                    VStack(alignment: .center, spacing: -30) {
                                        Text("\(index)")
                                            .foregroundColor(.red)
                                            .font(.caption)
                                            .offset(x: tickOffset, y: -30)
                                        Rectangle()
                                            .foregroundColor(.black)
                                            .frame(width: 1, height: 8)
                                            .offset(x: tickOffset, y: 5)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
    }
    
    private func thumbOffset(for geometry: GeometryProxy) -> CGFloat {
        if isDragging {
            let dragWidth = max(0, min(geometry.size.width, (value - 0.1) / 0.9 * geometry.size.width))
            return dragWidth - 12 // Adjust the circle's offset to center it
        } else {
            let sliderWidth = geometry.size.width
            let thumbX = CGFloat((value - 0.1) / 0.9) * sliderWidth
            let halfThumbWidth = CGFloat(24) / 2 // Assuming thumb width is 24
            let offset = thumbX - halfThumbWidth
            return max(min(offset, sliderWidth - 24), 0)
        }
    }
    
    private func progressWidth(geometry: GeometryProxy) -> CGFloat {
        let width = (value - 0.1) / 0.9 * geometry.size.width
        return max(min(width, geometry.size.width), 0)
    }
    
    private func onDragChanged(value: DragGesture.Value, geometry: GeometryProxy) {
        let dragWidth = value.location.x
        let totalWidth = geometry.size.width
        let newValue = CGFloat(min(max(0, dragWidth / totalWidth), 1)) * 0.9 + 0.1
        self.value = newValue
        onChanged?(self.value)
    }
    
    private func onDragEnded(value: DragGesture.Value, geometry: GeometryProxy) {
        let newValue = CGFloat(round(value.location.x / geometry.size.width * 10) / 10) * 0.9 + 0.1
        self.value = newValue
        onChanged?(self.value)
    }
    
    private func onTap(location: CGPoint, geometry: GeometryProxy) {
        let tapX = location.x
        let totalWidth = geometry.size.width
        let newValue = CGFloat(min(max(0, tapX / totalWidth), 1)) * 0.9 + 0.1
        self.value = newValue
        onChanged?(self.value)
    }
    
    private func onDragCircleChanged(value: DragGesture.Value, geometry: GeometryProxy) {
        self.isDragging = true
        self.onDragChanged(value: value, geometry: geometry)
        onChanged?(self.value)
    }
    
    private func onDragCircleEnded(value: DragGesture.Value, geometry: GeometryProxy) {
        self.isDragging = false
        self.onDragEnded(value: value, geometry: geometry)
        onChanged?(self.value)
    }
}

