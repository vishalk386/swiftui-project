//
//  SideMenuView.swift
//  SwiftUIApp
//
//  Created by Vishal Kamble on 13/07/23.
//
import SwiftUI

struct SideMenuView: View {
    enum MenuItem: String, CaseIterable {
        case home = "Home"
        case dashboard = "Dashboard"
        case key = "Key"
        case help = "Help"
        case logout = "Logout"
        
        var iconName: String {
            switch self {
                case .home: return "house"
                case .dashboard: return "rectangle.3.group.fill"
                case .key: return "key.horizontal.fill"
                case .help: return "questionmark.circle"
                case .logout: return "power"
            }
        }
        
        var destination: AnyView {
            switch self {
                case .home: return AnyView(HomeView()) // Replace HomeView with your actual destination view
                case .dashboard: return AnyView(DashboardView()) // Replace DashboardView with your actual destination view
                case .key: return AnyView(KeyView()) // Replace KeyView with your actual destination view
                case .help: return AnyView(HelpView()) // Replace HelpView with your actual destination view
                case .logout: return AnyView(LogoutView()) // Replace LogoutView with your actual destination view
            }
        }
    }
    

    @State private var selectedItem: MenuItem? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 100) {
                ForEach(MenuItem.allCases, id: \.self) { item in
                    NavigationLink(destination: item.destination) {
                        HStack {
                            Image(systemName: item.iconName)
                                .imageScale(.large)
                                .foregroundColor(
                                    selectedItem == item ? Color(hex: "#064494") : Color.white
                                ) // Set selected item color
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(
                            selectedItem == item ? Color.white : Color.clear // Set background color conditionally
                        )
                    }
                    .background(Color(hex: "#064494")) // Set sidebar background color
                    .tag(item) // Associate the NavigationLink with the corresponding item
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#064494")) // Set overall background color
        }
    }
}






struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}



extension Color {
    init?(hex: String, alpha: Double = 1.0) {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.count == 6 {
            formattedHex = "FF" + formattedHex
        }
        guard let hexValue = UInt32(formattedHex, radix: 16) else {
            return nil
        }
        let red = Double((hexValue >> 16) & 0xFF) / 255.0
        let green = Double((hexValue >> 8) & 0xFF) / 255.0
        let blue = Double(hexValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}
