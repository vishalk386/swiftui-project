//
//  ImageComprssionSliderSwiftUIApp.swift
//  ImageComprssionSliderSwiftUI
//
//  Created by Vishal Kamble on 08/09/23.
//

import SwiftUI

@main
struct ImageComprssionSliderSwiftUIApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsViewModel)
        }
    }
}

class Settings: ObservableObject {
    @Published var compressionQuality: CGFloat = 1.0 // Initial value
    @Published var pngCompressionQuality: CGFloat = 1.0
}
