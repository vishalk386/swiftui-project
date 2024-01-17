//
//  SettingsView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 24/05/23.
//

import SwiftUI

struct SettingsMenuView: View {
    
    init() {
            // Set the navigation bar background color to clear
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().backgroundColor = UIColor.clear
            UINavigationBar.appearance().isTranslucent = true
        }
    var body: some View {
      
            VStack(spacing: 10){
                List {
                    NavigationLink(destination: WebView(url: "http://adstringo.in/")) {
                        Text("About Us")
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                    
                    NavigationLink(destination: WebView(url: "http://adstringo.in/solution.html")) {
                        Text("Solutions")
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                    
                    
                    NavigationLink(destination: WebView(url: "http://adstringo.in/team.html")) {
                        Text("Our Team")
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                    
                    
                    NavigationLink(destination: WebView(url: "http://adstringo.in/awards.html")) {
                        Text("Our awards")
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                
                    
                    Text("Version 1.0.0")
                        .foregroundColor(.white)
                    
                    // Add more menu items as needed
                        .listRowBackground(Color.clear)
                    
                  
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .listRowBackground(Color.yellow)
                .gradientBackground()
            }
        .withCommonLogoutButton {
            
        }
        .navigationBarBackButtonHidden(false)
        .toolbarBackground(
            Color.clear,
            for: .navigationBar)
        .navigationBarTitle("Settings")
        .gradientBackground()
//        .navigationBarColor(backgroundColor: .clear, tintColor: .white)
    }
}

