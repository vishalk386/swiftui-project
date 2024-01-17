//
//  ImageDetails.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 23/05/23.
//

import Foundation
import UIKit

struct ImageDetails: Identifiable {
    let id = UUID()
    let image: UIImage
    let title: String
    let size: String
}

