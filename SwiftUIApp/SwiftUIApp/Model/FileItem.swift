//
//  FileItem.swift
//  SwiftUIApp
//
//  Created by Vishal Kamble on 13/07/23.
//

import Foundation

    struct FileItem: Identifiable {
        let id = UUID()
        let fileName: String
        let fileSize: String
        let optimizationPercentage: Int
        var isChecked: Bool = false
    }

