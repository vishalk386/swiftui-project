//
//  AdstringOTestAppApp.swift
//  AdstringOTestApp
//
//  Created by Vishal Kamble on 16/06/23.
//

import SwiftUI

@main
struct AdstringOTestAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    
    }
}
