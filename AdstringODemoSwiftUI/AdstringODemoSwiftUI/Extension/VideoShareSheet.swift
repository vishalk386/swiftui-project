//
//  VideoShareSheet.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 23/05/23.
//

import SwiftUI
import UIKit

struct VideoShareSheet: UIViewControllerRepresentable {
    let videoURL: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoShareSheet>) -> UIViewController {
        let activityViewController = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<VideoShareSheet>) {
        // No need to update the view controller
    }
}

