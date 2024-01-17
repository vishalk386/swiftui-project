//
//  ContentView.swift
//  AdstringOMultiPlatformMac
//
//  Created by Vishal Kamble on 16/06/23.
//
import SwiftUI

struct SideTabBarView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Home")) {
                    Label("Home", systemImage: "house")
                }
                
                NavigationLink(destination: Text("Profile")) {
                    Label("Profile", systemImage: "person")
                }
                
                NavigationLink(destination: Text("Settings")) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .listStyle(SidebarListStyle())
            
            Text("Select an item from the side tab bar")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
        }
        .frame(minWidth: 800, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
    }
}

struct SideTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideTabBarView()
    }
}
