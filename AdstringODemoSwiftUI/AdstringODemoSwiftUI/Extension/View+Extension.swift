//
//  View+Extension.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 16/05/23.
//

import SwiftUI

extension View {
    func setupNavigationBarAppearance(titleColor: UIColor, barColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = barColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

