//
//  URL+Extension.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 22/05/23.
//

import Foundation

extension URL {
    func fileSizeInMB() -> String {
        let p = self.path
        
        let attr = try? FileManager.default.attributesOfItem(atPath: p)
        
        if let attr = attr {
            let fileSize = Float(attr[FileAttributeKey.size] as! UInt64) / (1000.0 * 1000.0)
            
            return String(format: "%.2f MB", fileSize)
        } else {
            return "Failed to get size"
        }
    }
}
