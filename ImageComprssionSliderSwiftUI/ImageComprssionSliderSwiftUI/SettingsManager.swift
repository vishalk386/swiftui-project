//
//  SettingsManager.swift
//  ImageComprssionSliderSwiftUI
//
//  Created by Vishal Kamble on 08/09/23.
//

import Foundation
import CoreGraphics // Import CoreGraphics for CGFloat
import SwiftUI

// Define the AppSettings struct with Codable conformance
struct AppSettings: Codable {
    var enterName: String
    var selectedOption: String
    var isSavedOriginalFilename: Bool
    var isSavedWithDate: Bool
    var isReplaceOriginalFolderFS: Bool
    var isSavetoFolderFS: Bool
    var folderNameFS: String
    var outputfileSizeKbFS: String
    var isoOptimizeDefault: Bool
    var isImageResizeFS: Bool
    var isOutputSizeFS: Bool
    var fileWidthFS: String
    var fileHeightFS: String

    // CodingKeys enumeration for decoding
    enum CodingKeys: String, CodingKey {
        // Add all the coding keys for your properties here
        case enterName
        case selectedOption
        case isSavedOriginalFilename
        case isSavedWithDate
        case isReplaceOriginalFolderFS
        case isSavetoFolderFS
        case folderNameFS
        case outputfileSizeKbFS
        case isoOptimizeDefault
        case isImageResizeFS
        case isOutputSizeFS
        case fileWidthFS
        case fileHeightFS
    }
}

// Enum to represent different setting types
enum SettingType: String, CaseIterable {
    case jpeg
    case pdf
    case png
    case word
    case tiff
    case gif
    
    // Computed property to generate UserDefaults key for a setting type
    var userDefaultsKey: String {
        return "Setting_\(self.rawValue)_Quality"
    }
}

// ViewModel to manage settings
class SettingsViewModel: ObservableObject {
    @Published var settings: [SettingType: CGFloat] // Change Double to CGFloat
    @Published var appSettings: AppSettings
    
    init() {
        // Initialize appSettings with default values
        let defaultDirectoryURL = FileManager.default.homeDirectoryForCurrentUser

        self.appSettings = AppSettings(
            enterName: "",
            selectedOption: "Before",
            isSavedOriginalFilename: false,
            isSavedWithDate: false,
            isReplaceOriginalFolderFS: false,
            isSavetoFolderFS: false,
            folderNameFS: defaultDirectoryURL.path,
            outputfileSizeKbFS: "",
            isoOptimizeDefault: true,
            isImageResizeFS: false,
            isOutputSizeFS: false,
            fileWidthFS: "",
            fileHeightFS: ""
        )
        
        settings = SettingType.allCases.reduce(into: [:]) { result, type in
                    result[type] = 70.0
                }

                loadAllSettings()
                loadAppSettings()
            }
    
    func binding(for settingType: SettingType) -> Binding<CGFloat> {
           return Binding(
               get: {
                   return self.settings[settingType] ?? 70.0
               },
               set: { newValue in
                   self.settings[settingType] = newValue
               }
           )
       }

    // Function to load the slider value for a specific setting type
    func loadSliderValue(for settingType: SettingType) -> CGFloat { // Change Double to CGFloat
        return CGFloat(UserDefaults.standard.double(forKey: settingType.userDefaultsKey))
    }

    // Function to save the slider value for a specific setting type
    func saveSliderValue(for settingType: SettingType, value: CGFloat) { // Change Double to CGFloat
        UserDefaults.standard.set(Double(value), forKey: settingType.userDefaultsKey)
    }

    // Load all settings
    func loadAllSettings() {
        var loadedSettings: [SettingType: CGFloat] = [:] // Change Double to CGFloat
        for settingType in SettingType.allCases {
            let value = loadSliderValue(for: settingType)
            loadedSettings[settingType] = value
        }
        settings = loadedSettings
    }

    // Save all settings
    func saveAllSettings() {
        for (settingType, value) in settings {
            saveSliderValue(for: settingType, value: value)
        }
    }

    // Load appSettings from UserDefaults
    func loadAppSettings() {
        if let data = UserDefaults.standard.data(forKey: "AppSettings") {
            if let decodedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
                appSettings = decodedSettings
            }
        }
    }

    // Save appSettings to UserDefaults
    func saveAppSettings() {
        if let encodedSettings = try? JSONEncoder().encode(appSettings) {
            UserDefaults.standard.set(encodedSettings, forKey: "AppSettings")
        }
    }
}
