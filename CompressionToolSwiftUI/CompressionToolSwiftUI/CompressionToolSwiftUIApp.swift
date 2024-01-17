//
//  CompressionToolSwiftUIApp.swift
//  CompressionToolSwiftUI
//
//  Created by Vishal Kamble on 19/05/23.
//

import SwiftUI

@main
struct CompressionToolSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
