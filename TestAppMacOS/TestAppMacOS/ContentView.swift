//
//  ContentView.swift
//  TestAppMacOS
//
//  Created by Vishal Kamble on 13/12/23.
//

import SwiftUI
import CoreData

import SwiftUI

class FilePicker: ObservableObject {
    @Published var selectedURL: URL?

    func pickFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true

        panel.begin { response in
            if response.rawValue == NSApplication.ModalResponse.OK.rawValue {
                self.selectedURL = panel.urls.first
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var filePicker = FilePicker()

    private func fileSizeString(for url: URL?) -> String {
        guard let url = url else { return "Unknown Size" }

        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = attributes[FileAttributeKey.size] as? Int64 {
                return ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
            }
        } catch {
            print("Error getting file size: \(error)")
        }

        return "Unknown Size"
    }

    var body: some View {
        VStack {
            Button("Pick File") {
                filePicker.pickFile()
            }
            .padding()

            if let selectedURL = filePicker.selectedURL {
                Text("Selected File: \(selectedURL.lastPathComponent)")
                    .padding()

                Text("Original Size: \(fileSizeString(for: selectedURL))")
                    .padding()

                // Assuming you have a function to get compressed size
                Text("Compressed Size: \(compressedFileSizeString(for: selectedURL))")
                    .padding()
            }
        }
        .padding()
    }

    // Function to get compressed file size (replace with your actual implementation)
    private func compressedFileSizeString(for url: URL?) -> String {
        // Replace this with actual compressed file size calculation
        return "Compressed Size: Calculating..."
    }
}




private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
