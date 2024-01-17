//
//  LogoutButton.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 17/05/23.
//

import SwiftUI

struct LogoutButton: View {
    let logoutAction: () -> Void
    
    @State private var showAlert = false
    
    var body: some View {
        Button(action: {
            showAlert = true
        }) {
            Image(systemName: "power")
                .imageScale(.large)
                .foregroundColor(.white)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout"), action: {
                    // Perform logout action here
                    logoutAction()
                }),
                secondaryButton: .cancel()
            )
        }
    }
}


extension View {
    func withCommonLogoutButton(logoutAction: @escaping () -> Void) -> some View {
        self.modifier(CommonLogoutButtonModifier(logoutAction: logoutAction))
    }
}

struct CommonLogoutButtonModifier: ViewModifier {
    let logoutAction: () -> Void
    
    @State private var isPresentingLoginView = false
    @State private var showAlert = false
    
    func body(content: Content) -> some View {
        content
            .navigationBarItems(trailing: Group {
                Button(action: {
                    showAlert = true // Set the flag to show the alert
                }) {
                    Image(systemName: "power")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout"), action: {
                        logoutAction() // Perform logout action
                        isPresentingLoginView = true // Set the flag to present the login view
                    }),
                    secondaryButton: .cancel()
                )
            }
            .fullScreenCover(isPresented: $isPresentingLoginView) {
                LoginView()
            }
    }
}

