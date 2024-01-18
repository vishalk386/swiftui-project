//
//  TestAppMacOSApp.swift
//  TestAppMacOS
//
//  Created by Vishal Kamble on 13/12/23.
//

import SwiftUI

@main
struct TestAppMacOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
