//
//  SideMenu.swift
//  ShrinkmanMacos
//
//  Created by Vishal Kamble on 19/06/23.
//

import SwiftUI

struct SideMenu: View {
    @State private var selectedMenuItem: MenuItem?
    
    enum MenuItem: String, CaseIterable, Identifiable {
        case home
        case settings
        case key
        case help
        case logout
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .home:
                return "house.fill" // Replace with the actual home icon name
            case .settings:
                return "gearshape.fill" // Replace with the actual settings icon name
            case .key:
                return "key.fill" // Replace with the actual key icon name
            case .help:
                return "questionmark.circle.fill" // Replace with the actual help icon name
            case .logout:
                return "arrowshape.turn.up.left.fill" // Replace with the actual logout icon name
            }
        }
    }
    
    let sideMenuWidth: CGFloat = 50 // Set the desired width for the side menu
    let buttonHeight: CGFloat = 40 // Set the desired height for each button
    let sideMenuBackgroundColor = Color.blue // Set the background color for the side menu
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ForEach(MenuItem.allCases, id: \.self) { menuItem in
                        NavigationLink(
                            destination: destinationForMenuItem(menuItem),
                            tag: menuItem,
                            selection: $selectedMenuItem
                        ) {
                            HStack {
                                Spacer()
                                Image(systemName: menuItem.icon)
                                    .frame(width: 20, height: 20) // Adjust the icon size if needed
                                Spacer()
                            }
                            .contentShape(Rectangle()) // Make the entire cell tappable
                            .frame(height: buttonHeight) // Set the height of each menu item
                        }
                        .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove the selection highlighting
                    }
                    Spacer()
                }
                .frame(width: sideMenuWidth)
                .background(sideMenuBackgroundColor)
                .padding(.vertical, (geometry.size.height - CGFloat(MenuItem.allCases.count * Int(buttonHeight))) / 2) // Vertically center the icons
            }
        }
        .frame(minWidth: 800, minHeight: 600) // Adjust the size as needed
    }
    
    func destinationForMenuItem(_ menuItem: MenuItem) -> some View {
        switch menuItem {
        case .home:
            return Text("Home View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .settings:
            return Text("Settings View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .key:
            return Text("Key View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .help:
            return Text("Help View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .logout:
            return Text("Logout View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // Helper function to create a menu item icon
    private func menuIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 100))
            .foregroundColor(.white) // Set the icon color to white
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu()
    }
}



