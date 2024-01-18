//
//  ShrinkmanMacosApp.swift
//  ShrinkmanMacos
//
//  Created by Vishal Kamble on 19/06/23.
//

import SwiftUI

@main
struct ShrinkmanMacosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SideMenu()
                .preferredColorScheme(.light) // Set initial color scheme
                .background()

//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
