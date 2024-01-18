//
//  SettingsViewModel.swift
//  TestImage-Shinkman
//
//  Created by Vishal Kamble on 12/09/23.
//

import AppKit
import Foundation



// Create a struct to hold the settings
struct AppSettings {
    var enterName: String
    var selectedOption: String
    var isSavedOriginalFilename: Bool
    var isSavedWithDate: Bool
    var isReplaceOriginalFolderFS: Bool
    var isSavetoFolderFS: Bool
    var folderNameFS:String
    var outputfileSizeKbFS:String
    var isoOptimizeDefault:Bool = true
    var isImageResizeFS:Bool
    var isOutputSizeFS:Bool
    var fileWidthFS:String
    var fileHeightFS:String
}

let DefaultFolderURLKey = "DefaultFolderURLKey"

class SettingsViewModel: ObservableObject {
    @Published var appSettings: AppSettings
//    {
//        didSet {
////            print("appSettings updated: \(appSettings)")
//        }
//    }
    @Published var optSettings: OptSettingsData

    // Step 2: Initialize UserDefaults with the default folder URL
    init() {
        appSettings = AppSettings(
            enterName: UserDefaults.standard.string(forKey: "EnterNameKey") ?? "",
            selectedOption: UserDefaults.standard.string(forKey: "SelectedOptionKey") ?? "Before",
            isSavedOriginalFilename: UserDefaults.standard.bool(forKey: "IsSavedOriginalFilenameKey"),
            isSavedWithDate: UserDefaults.standard.bool(forKey: "IsSavedWithDateKey"),
            isReplaceOriginalFolderFS: UserDefaults.standard.bool(forKey: "IsReplaceOriginalFolderFSKey"),
            isSavetoFolderFS: UserDefaults.standard.bool(forKey: "IsSavetoFolderFSKey"),
            folderNameFS: UserDefaults.standard.string(forKey: DefaultFolderURLKey) ?? "",
            outputfileSizeKbFS: UserDefaults.standard.string(forKey: "OutputfileSizeKbFS") ?? "",
            isoOptimizeDefault: UserDefaults.standard.bool(forKey: "IsoOptimizeDefault"),
            isImageResizeFS: UserDefaults.standard.bool(forKey: "IsImageResizeFS"),
            isOutputSizeFS: UserDefaults.standard.bool(forKey: "IsOutputSizeFS"),
            fileWidthFS: UserDefaults.standard.string(forKey: "FileWidthFS") ?? "", fileHeightFS: UserDefaults.standard.string(forKey: "FileHeightFS") ?? ""

        )
        if let data = UserDefaults.standard.data(forKey: "settings"),
                  let savedSettings = try? JSONDecoder().decode(OptSettingsData.self, from: data) {
                   self.optSettings = savedSettings
               } else {
                   // Provide default values if settings are not found in UserDefaults
                   self.optSettings = OptSettingsData(
                       imageQuality: 70,
                       pdfQuality: 70,
                       tiffQuality: 70,
                        pngQuality: 70,
                        wordQuality: 70,
                        excelQuality: 70,
                        powerpointQuality: 70,
                        videoQuality: 70
                   )
               }

        if UserDefaults.standard.url(forKey: DefaultFolderURLKey) == nil {
            setDefaultFolderToHomeDirectory()
        }
        
      

        appSettings = getSavedSettings()
    }

    
    // Function to set the default folder to the user's home directory
    func setDefaultFolderToHomeDirectory() {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        let folderPath = homeDirectory.path
        appSettings.folderNameFS = folderPath
        UserDefaults.standard.set(folderPath, forKey: DefaultFolderURLKey)
    }

    
    // Function to update the default folder URL in UserDefaults
    func updateDefaultFolder(_ newFolderURL: URL) {
        UserDefaults.standard.set(newFolderURL, forKey: DefaultFolderURLKey)
    }
    
    // Function to get the current default folder URL from UserDefaults
    func getDefaultFolderURL() -> URL? {
        return UserDefaults.standard.url(forKey: DefaultFolderURLKey)
    }
    
    func saveSetting(appSettings: AppSettings) -> (String, String) {
        var enteredText = appSettings.enterName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !enteredText.isEmpty {
            if appSettings.isSavedOriginalFilename {
                return ("", "")
            }
            
            if appSettings.isSavedWithDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
               enteredText = dateFormatter.string(from: Date())
                return (appSettings.selectedOption, enteredText)
            }
            
            // Include the selectedOption in the return value
            return (appSettings.selectedOption, enteredText)
        }
        
        // If no text is entered, return the selectedOption directly
        return (appSettings.selectedOption, "")
    }
    
    func saveFileSettings(appsettings: AppSettings) -> AppSettings {
        var updatedSettings = appsettings

        if appsettings.isImageResizeFS {
            let fileWidth = appsettings.fileWidthFS
            let fileHeight = appsettings.fileHeightFS
            updatedSettings.isOutputSizeFS = false // To ensure only one option is selected
            updatedSettings.isImageResizeFS = true
            updatedSettings.fileWidthFS = fileWidth
            updatedSettings.fileHeightFS = fileHeight
        } else if appsettings.isOutputSizeFS {
            let outputSize = appsettings.outputfileSizeKbFS
            updatedSettings.isImageResizeFS = false // To ensure only one option is selected
            updatedSettings.isOutputSizeFS = true
            updatedSettings.outputfileSizeKbFS = outputSize
        } else {
            // If neither option is selected, set both to false and clear values
            updatedSettings.isImageResizeFS = false
            updatedSettings.isOutputSizeFS = false
            updatedSettings.fileWidthFS = ""
            updatedSettings.fileHeightFS = ""
            updatedSettings.outputfileSizeKbFS = ""
            updatedSettings.isoOptimizeDefault = true
        }

        return updatedSettings
    }

   
    
    
    // Retrieve the saved settings from UserDefaults
    func getSavedSettings() -> AppSettings {
        let enterName = UserDefaults.standard.string(forKey: "EnterNameKey") ?? ""
        let selectedOption = UserDefaults.standard.string(forKey: "SelectedOptionKey") ?? "Before"
        let isSavedOriginalFilename = UserDefaults.standard.bool(forKey: "IsSavedOriginalFilenameKey")
        let isSavedWithDate = UserDefaults.standard.bool(forKey: "IsSavedWithDateKey")
        let isReplaceOriginalFolderFS = UserDefaults.standard.bool(forKey: "IsReplaceOriginalFolderFSKey")
        let isSavetoFolderFS = UserDefaults.standard.bool(forKey: "IsSavetoFolderFSKey")
        let isoOptimizeDefault = UserDefaults.standard.bool(forKey: "IsoOptimizeDefault")
        let folderNameFS = UserDefaults.standard.string(forKey: DefaultFolderURLKey) ?? ""
        let fileWidthFS = UserDefaults.standard.string(forKey: "FileWidthFS") ?? ""
        let fileHeightFS = UserDefaults.standard.string(forKey: "FileHeightFS") ?? ""
        let outputfileSizeKbFS = UserDefaults.standard.string(forKey: "OutputfileSizeKbFS") ?? ""
        let isOutputSizeFS = UserDefaults.standard.bool(forKey: "IsOutputSizeFS")
        let isImageResizeFS =  UserDefaults.standard.bool(forKey: "IsImageResizeFS")
        

        return AppSettings(
            enterName: enterName,
            selectedOption: selectedOption,
            isSavedOriginalFilename: isSavedOriginalFilename,
            isSavedWithDate: isSavedWithDate,
            isReplaceOriginalFolderFS: isReplaceOriginalFolderFS,
            isSavetoFolderFS: isSavetoFolderFS,
            folderNameFS: folderNameFS,
            outputfileSizeKbFS: outputfileSizeKbFS,
            isoOptimizeDefault: true,
            isImageResizeFS: isImageResizeFS,
            isOutputSizeFS: isOutputSizeFS,
            fileWidthFS: fileWidthFS,
            fileHeightFS: fileHeightFS
        )
    }

    // Save the settings to UserDefaults
    func saveSettingsToUserDefaults() {
        UserDefaults.standard.set(appSettings.enterName, forKey: "EnterNameKey")
        UserDefaults.standard.set(appSettings.selectedOption, forKey: "SelectedOptionKey")
        UserDefaults.standard.set(appSettings.isSavedOriginalFilename, forKey: "IsSavedOriginalFilenameKey")
        UserDefaults.standard.set(appSettings.isSavedWithDate, forKey: "IsSavedWithDateKey")
        UserDefaults.standard.set(appSettings.isReplaceOriginalFolderFS, forKey: "IsReplaceOriginalFolderFSKey")
        UserDefaults.standard.set(appSettings.isSavetoFolderFS, forKey: "IsSavetoFolderFSKey")
        UserDefaults.standard.set(true, forKey: "IsoOptimizeDefault")
        UserDefaults.standard.set(appSettings.folderNameFS, forKey: DefaultFolderURLKey)
        UserDefaults.standard.set(appSettings.outputfileSizeKbFS, forKey: "OutputfileSizeKbFS")
        UserDefaults.standard.set(appSettings.isOutputSizeFS, forKey: "IsOutputSizeFS")
        UserDefaults.standard.set(appSettings.isImageResizeFS, forKey: "IsImageResizeFS")
        UserDefaults.standard.set(appSettings.fileWidthFS, forKey: "FileWidthFS")
        UserDefaults.standard.set(appSettings.fileHeightFS, forKey: "FileHeightFS")
       
    }

    func selectFolder() {
            let dialog = NSOpenPanel()
            dialog.title = "Select a folder"
            dialog.canChooseFiles = false
            dialog.canChooseDirectories = true
            dialog.allowsMultipleSelection = false

            guard let window = NSApplication.shared.keyWindow else {
                return
            }

            dialog.beginSheetModal(for: window) { response in
                if response == .OK {
                    guard let folderURL = dialog.urls.first else {
                        return
                    }
                    // Update the enterName with the selected folder path
                    self.appSettings.folderNameFS = folderURL.path
                    self.updateDefaultFolder(folderURL)
                }
            }
        }
    
    
    func saveSettings() {
           if let encodedSettings = try? JSONEncoder().encode(optSettings) {
               UserDefaults.standard.set(encodedSettings, forKey: "settings")
           }
       }
    func resetQualityParametersToDefault() {
            optSettings.imageQuality = 70
            optSettings.pdfQuality = 70
            optSettings.tiffQuality = 70
            optSettings.pngQuality = 70
            optSettings.wordQuality = 70
            optSettings.excelQuality = 70
            optSettings.powerpointQuality = 70
            optSettings.videoQuality = 70
        appSettings.isoOptimizeDefault = true
        saveSettings()
        }

}








struct OptSettingsData:Codable,Equatable {
    var imageQuality: CGFloat
    var pdfQuality: CGFloat
    var tiffQuality: CGFloat
    var pngQuality: CGFloat
    var wordQuality: CGFloat
    var excelQuality: CGFloat
    var powerpointQuality: CGFloat
    var videoQuality: CGFloat
    
    static func == (lhs: OptSettingsData, rhs: OptSettingsData) -> Bool {
            return lhs.imageQuality == rhs.imageQuality &&
                   lhs.pdfQuality == rhs.pdfQuality &&
                   lhs.tiffQuality == rhs.tiffQuality &&
                   lhs.pngQuality == rhs.pngQuality &&
                   lhs.wordQuality == rhs.wordQuality &&
                   lhs.excelQuality == rhs.excelQuality &&
                   lhs.powerpointQuality == rhs.powerpointQuality &&
                   lhs.videoQuality == rhs.videoQuality
        }
}
