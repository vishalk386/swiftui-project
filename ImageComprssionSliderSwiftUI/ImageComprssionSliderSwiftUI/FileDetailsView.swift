//
//  FileDetailsView.swift
//  ImageComprssionSliderSwiftUI
//
//  Created by Vishal Kamble on 08/09/23.
//

import SwiftUI
import Cocoa
import SwiftUI
import Cocoa
import Combine

struct FileDetailsView: View {
    @State private var selectedFolder: URL?
    @State private var fileDetails: [FileDetailsModel] = []
    @ObservedObject var settingsViewModel: SettingsViewModel

    let supportedFileExtensions = ["jpeg", "jpg", "png", "heic"]
    private let compressionQueue = DispatchQueue(label: "ImageCompressionQueue")

    var body: some View {
        VStack {
            Button("Select Folder") {
                selectFolder()
            }

            ScrollView(.horizontal) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 20) {
                        Text("Filename").font(.headline)
                        Text("Original Size").font(.headline)
                        Text("Compressed Size").font(.headline)
                    }
                    .padding(.horizontal, 20)

                    ForEach(supportedFileExtensions, id: \.self) { fileExtension in
                        Section(header: Text(fileExtension.uppercased())) {
                            ForEach(fileDetails.indices, id: \.self) { index in
                                if fileDetails[index].fileExtension == fileExtension {
                                    FileDetailRowView(
                                        fileDetail: $fileDetails[index],
                                        compressionQuality: settingsViewModel.binding(for: SettingType(rawValue: fileExtension) ?? .jpeg),
                                        onCompressionQualityChange: {
                                            fileDetails[index].optimizePercentage = settingsViewModel.settings[SettingType(rawValue: fileExtension) ?? .jpeg] ?? 70.0
                                        },
                                        compressionQueue: compressionQueue
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func selectFolder() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = supportedFileExtensions

        if openPanel.runModal() == .OK, let folderURL = openPanel.url {
            selectedFolder = folderURL
            fetchFileDetailsFromFolder(folderURL)
        }
    }

    func fetchFileDetailsFromFolder(_ folderURL: URL) {
        let initialCompressionQuality = 70.0

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])

            fileDetails = fileURLs.compactMap { fileURL in
                guard let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path) else {
                    return nil
                }

                let fileSize = fileAttributes[.size] as? Int64 ?? 0
                let sizeString = ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
                let fileName = fileURL.lastPathComponent
                let fileExtension = fileURL.pathExtension

                let initialOptimizePercentage = initialCompressionQuality

                return FileDetailsModel(
                    id: UUID(),
                    filename: fileName,
                    originalSize: sizeString,
                    fileExtension: fileExtension,
                    fileURL: fileURL,
                    folderURL: folderURL,
                    optimizedFolder: folderURL,
                    optimizedURL: fileURL,
                    optimizedName: fileName,
                    optimizedSize: sizeString,
                    optimizePercentage: initialOptimizePercentage,
                    isChecked: false,
                    isFileShrinked: false
                )
            }
        } catch {
            print("Error fetching file details: \(error)")
        }
    }
    
    private func subscribeToFileDetail(_ fileDetail: FileDetailsModel) {
           // Create a publisher to perform image compression and update the view
           _ = Just(fileDetail) // Create a publisher with the file detail
               .map { detail -> String in
                   // Perform image compression here and return the optimized size as a String
                   return calculateOptimizedSize(for: detail)
               }
               .receive(on: DispatchQueue.main) // Receive on the main queue to update the view
               .sink { optimizedSize in
                   // Update the fileDetail's optimizedSize when the compression is complete
                   if let index = fileDetails.firstIndex(where: { $0.id == fileDetail.id }) {
                       fileDetails[index].optimizedSize = optimizedSize
                   }
               }
       }
    
    private func calculateOptimizedSize(for fileDetail: FileDetailsModel) -> String {
        // Perform image compression and return the optimized size as a String
        if let compressedData = compressImage(fileDetail.fileURL, quality: fileDetail.optimizePercentage) {
            let optimizedSize = ByteCountFormatter.string(fromByteCount: Int64(compressedData.count), countStyle: .file)
            return optimizedSize
        } else {
            return "N/A"
        }
    }

    private func compressImage(_ imageFileURL: URL, quality: CGFloat) -> Data? {
        // Perform image compression here based on the imageFileURL and quality
        // Replace this with your actual image compression logic
        
        guard let image = NSImage(contentsOf: imageFileURL),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }

        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let properties: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: quality
        ]

        if let compressedData = bitmapRep.representation(using: .jpeg, properties: properties) {
            return compressedData
        } else {
            return nil
        }
    }

}

struct FileDetailRowView: View {
    @Binding var fileDetail: FileDetailsModel
    @Binding var compressionQuality: CGFloat
    var onCompressionQualityChange: (() -> Void)?
    let compressionQueue: DispatchQueue

    var body: some View {
        HStack(spacing: 20) {
            Text(fileDetail.filename)
            Text(fileDetail.originalSize)
            Text(fileDetail.optimizedSize)
            Text(String(format: "%.1f", compressionQuality))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onChange(of: compressionQuality) { newValue in
            updateOptimizedSize()
            onCompressionQualityChange?()
        }
    }

    private func updateOptimizedSize() {
        fileDetail.optimizedSize = calculateOptimizedSize()
    }

    private func calculateOptimizedSize() -> String {
        var optimizedSize = "N/A"

        compressionQueue.async {
            let compressedData = compressImage(fileDetail.fileURL, quality: compressionQuality)
            if let data = compressedData {
                optimizedSize = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
                DispatchQueue.main.async {
                    fileDetail.optimizedSize = optimizedSize
                    fileDetail.filename = "vishal"
                    print(optimizedSize, fileDetail.fileURL, "**************", fileDetail.filename)
                }
            }
        }

        return optimizedSize
    }

    func compressImage(_ imageFileURL: URL, quality: CGFloat) -> Data? {
        guard let image = NSImage(contentsOf: imageFileURL),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }

        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let properties: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: quality
        ]

        if let compressedData = bitmapRep.representation(using: .jpeg, properties: properties) {
            return compressedData
        } else {
            return nil
        }
    }
    
}



// Modify FileDetailsModel to conform to ObservableObject
class FileDetailsModel: Identifiable, Equatable, ObservableObject {
    @Published var id: UUID
    @Published var filename: String
    @Published var originalSize: String
    @Published var fileExtension: String
    @Published var fileURL: URL
    @Published var folderURL: URL
    @Published var optimizedFolder: URL
    @Published var optimizedURL: URL
    @Published var optimizedName: String
    @Published var optimizedSize: String
    @Published var optimizePercentage: CGFloat
    @Published var isChecked: Bool
    @Published var isFileShrinked: Bool

    init(id: UUID, filename: String, originalSize: String, fileExtension: String, fileURL: URL, folderURL: URL, optimizedFolder: URL, optimizedURL: URL, optimizedName: String, optimizedSize: String, optimizePercentage: CGFloat, isChecked: Bool, isFileShrinked: Bool) {
        self.id = id
        self.filename = filename
        self.originalSize = originalSize
        self.fileExtension = fileExtension
        self.fileURL = fileURL
        self.folderURL = folderURL
        self.optimizedFolder = optimizedFolder
        self.optimizedURL = optimizedURL
        self.optimizedName = optimizedName
        self.optimizedSize = optimizedSize
        self.optimizePercentage = optimizePercentage
        self.isChecked = isChecked
        self.isFileShrinked = isFileShrinked
    }
    
    static func == (lhs: FileDetailsModel, rhs: FileDetailsModel) -> Bool {
        return lhs.id == rhs.id
    }
}
